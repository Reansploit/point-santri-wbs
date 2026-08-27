#!/usr/bin/env node
// Migrasi satu kali: dump PostgreSQL (pg_dump --inserts) -> qism_point.sqlite
// yang dipakai app desktop (SQLite). Tanpa dependency eksternal (pakai node:sqlite).
//
// Cara pakai (di Windows, setelah backup dibuat):
//   pg_dump -h localhost -U <user> -d <db> -a --inserts --column-inserts \
//           -t siswa -t points -t users -f backup.sql
//   node --experimental-sqlite scripts/migrate.mjs backup.sql
//   # hasil: qism_point.sqlite  ->  taruh di  %APPDATA%/com.qism.natijah/
//
// Tabel siswa, points, DAN users diimpor. Password users (hash $2y$ Laravel)
// ikut terbawa — bcrypt Rust 0.15 mendukung format $2y$, jadi password asli
// tetap bisa dipakai. seed() Rust tetap menambah akun fallback qism/password.

import { DatabaseSync } from "node:sqlite";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const __dirname = dirname(fileURLToPath(import.meta.url));

const SCHEMA = `
CREATE TABLE IF NOT EXISTS users (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    username   TEXT UNIQUE NOT NULL,
    password   TEXT NOT NULL,
    role       TEXT NOT NULL DEFAULT 'qism',
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);
CREATE TABLE IF NOT EXISTS siswa (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    nama_siswa TEXT NOT NULL,
    kelas      INTEGER NOT NULL CHECK (kelas BETWEEN 7 AND 12),
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);
CREATE TABLE IF NOT EXISTS points (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    siswa_id      INTEGER NOT NULL REFERENCES siswa(id) ON DELETE CASCADE,
    tanggal       TEXT,
    deskripsi     TEXT DEFAULT '-',
    kategori      TEXT DEFAULT 'Umum',
    point_positif INTEGER NOT NULL DEFAULT 0,
    point_negatif INTEGER NOT NULL DEFAULT 0,
    input_by      INTEGER REFERENCES users(id),
    created_at    TEXT DEFAULT (datetime('now')),
    updated_at    TEXT DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_points_tanggal ON points(tanggal);
CREATE INDEX IF NOT EXISTS idx_points_kategori ON points(kategori);
CREATE INDEX IF NOT EXISTS idx_siswa_kelas     ON siswa(kelas);
`;

const DEFAULT_COLS = {
  siswa: ["id", "nama_siswa", "kelas", "created_at", "updated_at"],
  points: ["id", "siswa_id", "tanggal", "deskripsi", "kategori", "point_positif", "point_negatif", "input_by", "created_at", "updated_at"],
  users: ["id", "username", "password", "role", "created_at", "updated_at"],
};

function fail(msg) {
  console.error("ERROR: " + msg);
  process.exit(1);
}

// --- Parser INSERT pg_dump (menghargai quote '' dan tuple ganda) ---
function parseInserts(sql) {
  const inserts = [];
  let i = 0;
  const n = sql.length;
  while (i < n) {
    const idx = sql.indexOf("INSERT INTO", i);
    if (idx === -1) break;
    i = idx;
    let j = idx + "INSERT INTO".length;
    while (j < n && /\s/.test(sql[j])) j++;
    const tblStart = j;
    while (j < n && /[A-Za-z0-9_.]/.test(sql[j])) j++;
    let table = sql.slice(tblStart, j).replace(/^public\./, "").replace(/"/g, "");

    let columns = null;
    while (j < n && /\s/.test(sql[j])) j++;
    if (sql[j] === "(") {
      let depth = 0, k = j;
      for (; k < n; k++) {
        if (sql[k] === "(") depth++;
        else if (sql[k] === ")") { depth--; if (depth === 0) break; }
      }
      columns = sql.slice(j + 1, k).split(",").map((s) => s.trim().replace(/"/g, ""));
      j = k + 1;
    }
    while (j < n && /\s/.test(sql[j])) j++;
    if (!sql.slice(j, j + 6).toUpperCase().startsWith("VALUES")) { i = j; continue; }
    j += 6;

    const tuples = [];
    while (j < n) {
      while (j < n && /\s/.test(sql[j])) j++;
      if (sql[j] !== "(") break;
      let depth = 1, inStr = false, k = j + 1, tuple = "";
      for (; k < n; k++) {
        const c = sql[k];
        if (inStr) {
          if (c === "'") {
            if (sql[k + 1] === "'") { tuple += "''"; k += 1; continue; }
            inStr = false; tuple += c; continue;
          }
          tuple += c; continue;
        } else {
          if (c === "'") { inStr = true; tuple += c; continue; }
          if (c === "(") depth++;
          if (c === ")") { depth--; if (depth === 0) { k++; break; } }
          tuple += c;
        }
      }
      tuples.push(splitValues(tuple));
      j = k;
      while (j < n && (/\s/.test(sql[j]) || sql[j] === ",")) j++;
      if (sql[j] === ";") { j++; break; }
    }
    inserts.push({ table, columns, tuples });
    i = j;
  }
  return inserts;
}

function splitValues(s) {
  const out = [];
  let cur = "", inStr = false, i = 0;
  while (i < s.length) {
    const c = s[i];
    if (inStr) {
      if (c === "'") {
        if (i + 1 < s.length && s[i + 1] === "'") {
          cur += "''"; // escaped quote, keep doubled for parseValue
          i += 2;      // skip both source quotes (no hidden increment)
          continue;
        }
        cur += "'";
        inStr = false;
        i++;
        continue;
      }
      cur += c;
      i++;
      continue;
    } else {
      if (c === "'") { inStr = true; cur += "'"; i++; continue; }
      if (c === ",") { out.push(cur); cur = ""; i++; continue; }
      cur += c;
      i++;
    }
  }
  out.push(cur);
  return out.map((v) => parseValue(v.trim()));
}

function parseValue(v) {
  if (v === "NULL" || v === "") return null;
  if (v[0] === "'") return v.slice(1, -1).replace(/''/g, "'");
  if (v.toUpperCase() === "TRUE") return 1;
  if (v.toUpperCase() === "FALSE") return 0;
  if (/^-?\d+(\.\d+)?$/.test(v)) return Number(v);
  return v;
}

function toRows(insert, table) {
  const cols = insert.columns && insert.columns.length ? insert.columns : DEFAULT_COLS[table];
  if (!cols) return [];
  return insert.tuples.map((vals) => {
    const row = {};
    cols.forEach((c, idx) => { row[c] = vals[idx]; });
    return row;
  });
}

// --- main ---
const args = process.argv.slice(2);
let dumpPath = null;
let outPath = join(process.cwd(), "qism_point.sqlite");
for (let a = 0; a < args.length; a++) {
  if (args[a] === "--out") { outPath = args[++a]; }
  else if (!dumpPath) { dumpPath = args[a]; }
}
if (!dumpPath) fail("Pakai: node --experimental-sqlite scripts/migrate.mjs <backup.sql> [--out <file.sqlite>]");
let sql;
try {
  sql = readFileSync(dumpPath, "utf8");
} catch (e) {
  fail("Tidak bisa baca " + dumpPath + ": " + e.message);
}

const inserts = parseInserts(sql);
const byTable = {};
for (const ins of inserts) {
  if (!byTable[ins.table]) byTable[ins.table] = [];
  byTable[ins.table].push(...toRows(ins, ins.table));
}

const siswa = byTable["siswa"] || [];
const points = byTable["points"] || [];
const users = byTable["users"] || [];

const db = new DatabaseSync(outPath);
db.exec(SCHEMA);
db.exec("PRAGMA foreign_keys = ON;");

const insSiswa = db.prepare(
  "INSERT OR IGNORE INTO siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (?, ?, ?, ?, ?)"
);
let siswaOk = 0;
for (const r of siswa) {
  insSiswa.run(
    Number(r.id), String(r.nama_siswa), Number(r.kelas),
    r.created_at ?? null, r.updated_at ?? null
  );
  siswaOk++;
}

const insPoint = db.prepare(
  "INSERT OR IGNORE INTO points (id, siswa_id, tanggal, deskripsi, kategori, point_positif, point_negatif, input_by, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, NULL, ?, ?)"
);
let pointOk = 0;
for (const r of points) {
  insPoint.run(
    Number(r.id), Number(r.siswa_id), r.tanggal ?? null,
    r.deskripsi ?? "-", r.kategori ?? "Umum",
    Number(r.point_positif) || 0, Number(r.point_negatif) || 0,
    r.created_at ?? null, r.updated_at ?? null
  );
  pointOk++;
}

// Users: bawa password asli (hash $2y$ Laravel). bcrypt Rust 0.15 mendukung
// format $2y$, jadi password lama tetap bisa dipakai untuk login.
const insUser = db.prepare(
  "INSERT OR IGNORE INTO users (id, username, password, role, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)"
);
let userOk = 0;
for (const r of users) {
  insUser.run(
    Number(r.id), String(r.username), String(r.password), String(r.role),
    r.created_at ?? null, r.updated_at ?? null
  );
  userOk++;
}

// sqlite_sequence (AUTOINCREMENT) otomatis ter-update ke id terbesar saat
// kita INSERT dengan id eksplisit, jadi tidak perlu diubah manual.

db.close();

console.log("Migrasi selesai -> " + outPath);
console.log("  siswa  : " + siswaOk + " baris");
console.log("  points : " + pointOk + " baris");
console.log("  users  : " + userOk + " baris (password asli ikut terbawa)");
console.log("\nTaruh file ini di: %APPDATA%\\com.qism.natijah\\qism_point.sqlite");
