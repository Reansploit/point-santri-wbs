use crate::models::User;
use rusqlite::Connection;
use std::sync::Mutex;

pub struct AppState {
    pub db: Mutex<Connection>,
    pub current: Mutex<Option<User>>,
}

pub fn open(app_data_dir: std::path::PathBuf) -> Result<Connection, Box<dyn std::error::Error>> {
    std::fs::create_dir_all(&app_data_dir)?;
    let path = app_data_dir.join("qism_point.sqlite");
    let conn = Connection::open(path)?;
    conn.execute_batch("PRAGMA foreign_keys = ON;")?;
    init_schema(&conn)?;
    seed(&conn)?;
    Ok(conn)
}

fn init_schema(conn: &Connection) -> rusqlite::Result<()> {
    conn.execute_batch(
        r#"
        CREATE TABLE IF NOT EXISTS users (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            username   TEXT UNIQUE NOT NULL,
            password   TEXT NOT NULL,
            role       TEXT NOT NULL DEFAULT 'qism',
            created_at TEXT NOT NULL DEFAULT (datetime('now')),
            updated_at TEXT NOT NULL DEFAULT (datetime('now'))
        );

        CREATE TABLE IF NOT EXISTS siswa (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_siswa TEXT NOT NULL,
            kelas      INTEGER NOT NULL CHECK (kelas BETWEEN 7 AND 12),
            created_at TEXT NOT NULL DEFAULT (datetime('now')),
            updated_at TEXT NOT NULL DEFAULT (datetime('now'))
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
            created_at    TEXT NOT NULL DEFAULT (datetime('now')),
            updated_at    TEXT NOT NULL DEFAULT (datetime('now'))
        );

        CREATE INDEX IF NOT EXISTS idx_points_tanggal ON points(tanggal);
        CREATE INDEX IF NOT EXISTS idx_points_kategori ON points(kategori);
        CREATE INDEX IF NOT EXISTS idx_siswa_kelas     ON siswa(kelas);
        "#,
    )
}

fn seed(conn: &Connection) -> rusqlite::Result<()> {
    // Akun default selalu dijamin ada, terlepas dari apakah tabel users
    // sudah berisi (mis. setelah migrasi dari backup lama).
    ensure_user(conn, "admin", "admin", "admin")?;
    ensure_user(conn, "qism", "password", "qism")?;
    Ok(())
}

fn ensure_user(conn: &Connection, username: &str, password: &str, role: &str) -> rusqlite::Result<()> {
    let exists: i64 = conn.query_row(
        "SELECT COUNT(*) FROM users WHERE username = ?",
        [username],
        |r| r.get(0),
    )?;
    if exists == 0 {
        let pw = bcrypt::hash(password, 12).unwrap_or_default();
        conn.execute(
            "INSERT INTO users (username, password, role) VALUES (?1, ?2, ?3)",
            rusqlite::params![username, &pw, role],
        )?;
    }
    Ok(())
}
