# Qism Natijah — App Desktop (Offline, Tanpa Install)

Aplikasi pencatat point santri yang dijadikan **app desktop Windows (.exe)** menggunakan
**Tauri v2**. Semua data tersimpan **lokal** di SQLite — tidak ada server, tidak ada
internet, tidak ada database terpisah.

> **Untuk pengguna akhir:** cukup jalankan installer `.exe` hasil build. Tidak perlu
> install Node.js, Laravel, MySQL/PostgreSQL, maupun apa pun. Di Windows 11, WebView2
> sudah tersedia bawaan sistem.

---

## Akun default

| Username | Password  | Role  |
|----------|-----------|-------|
| `admin`  | `admin`   | admin |
| `qism`   | `password`| qism  |

Data aplikasi (database SQLite) disimpan di:

```
%APPDATA%/com.qism.natijah/qism_point.sqlite
```

---

## Build menjadi .exe (dijalankan di Windows)

App ini **dibuild di Windows** (kamu sudah punya Windows buat build). Di mesin Windows
yang dipakai untuk build, siapkan toolchain sekali saja:

1. **Node.js** (LTS) — https://nodejs.org
2. **Rust** (rustup, channel stable) — https://rustup.rs
3. **Microsoft C++ Build Tools (MSVC)** — dari Visual Studio Installer, centang
   *"Desktop development with C++"*.
4. **WebView2 Runtime** — sudah ada di Windows 11. App ini sudah meng-bundle
   installer WebView2 **offline** (`webviewInstallMode: offlineInstaller`), jadi
   `.exe` hasil build bisa di-install di mesin **tanpa internet**. Build tetap butuh
   internet sekali untuk mengunduh bundel WebView2 (~150 MB) yang di-embed ke installer.

Lalu di folder `desktop/` jalankan:

```bash
npm install
npm run tauri build
```

Hasil installer ada di:

```
src-tauri/target/release/bundle/nsis/Qism Natijah_1.0.0_x64-setup.exe   <- installer .exe
src-tauri/target/release/bundle/msi/Qism Natijah_1.0.0_x64_en-US.msi    <- installer .msi
```

Sebar **file `*-setup.exe`** ke user. User cukup klik → install → jalan. Selesai.

---

## Logo aplikasi

Icon aplikasi (taskbar, installer `.exe`, file `.exe`) pakai **`logo-wbs.png`** milik
WBS. Sumber ada di `assets/logo-wbs.png` (dan `assets/logo-wbs-1024.png`, versi
1024×1024 yang dipakai `tauri icon`). Semua format (`.ico`, `.icns`, Store/Android/iOS)
digenerate ke `src-tauri/icons/` lewat:

```bash
npx tauri icon assets/logo-wbs-1024.png
```

Latar `logo-wbs.png` sudah transparan, jadi ikon hasilnya bersih (tidak jadi kotak
putih). Kalau suatu saat ganti logo: ganti file sumber lalu jalankan perintah di atas.

Halaman **login** juga menampilkan logo WBS yang sama — file `public/logo-wbs.png`
(disalin dari `assets/logo-wbs.png`) direferensikan sebagai `/logo-wbs.png` di
`src/pages/Login.tsx` (komponen `<WbsLogo />`), menggantikan ikon sparkle bawaan.

---

## Struktur project

```
desktop/
├── src/                  # Frontend: Vite + React + TypeScript + Tailwind
│   ├── lib/              # api.ts (invoke Tauri), auth.tsx, types.ts
│   ├── pages/            # Login, admin/*, qism/*
│   └── components/       # Layout, ProtectedRoute, ui/*
└── src-tauri/            # Backend Rust (Tauri)
    ├── src/
    │   ├── main.rs       # setup: buka DB di app_data_dir, daftarkan commands
    │   ├── db.rs         # schema SQLite + seed akun default
    │   ├── models.rs     # struct serde (User, Siswa, Point, RekapRow, ...)
    │   └── commands.rs   # semua logika: auth, siswa, point, rekap, statistik, export Excel
    ├── Cargo.toml
    ├── tauri.conf.json   # bundle target: nsis + msi
    └── icons/            # icon hasil `npx tauri icon`
```

## Catatan teknis

- **Tidak butuh server.** Semua `invoke()` dari frontend memanggil fungsi Rust
  langsung; Rust membaca/tulis SQLite lokal.
- **Export Excel** pakai `rust_xlsxwriter` (di-generate di Rust, tanpa library JS).
- **Password** di-hash dengan bcrypt di sisi Rust.
- **Routing** pakai `HashRouter` agar refresh halaman tidak 404 di Tauri.

---

## Migrasi data dari backup lama (PostgreSQL `.sql`)

App lama pakai **PostgreSQL**, app baru pakai **SQLite** — beda engine, jadi butuh
konversi satu kali. Script `scripts/migrate.mjs` (Node, tanpa dependency) membaca
dump PostgreSQL lalu menghasilkan `qism_point.sqlite` yang langsung dipakai app.

### 1. Buat backup dari database lama (PostgreSQL)

```bash
pg_dump -h localhost -U <user> -d <nama_db> \
        -a --inserts --column-inserts \
        -t siswa -t points -t users \
        -f backup.sql
```

Gunakan `--column-inserts` agar urutan kolom eksplisit (lebih aman kalau skema
sedikit beda). Hanya tabel `siswa` & `points` yang diimpor.

### 2. Jalankan konverter

```bash
npm run migrate -- backup.sql --out qism_point.sqlite
# atau langsung:
node --experimental-sqlite scripts/migrate.mjs backup.sql --out qism_point.sqlite
```

> `node:sqlite` butuh Node 22.5+. Di Windows build machine kamu (Node 22) sudah
> ada. Flag `--experimental-sqlite` diperlukan.

Output: `qism_point.sqlite` berisi data siswa, points, & users yang sudah
dimigrasi. Tabel `users` **ikut diimpor** beserta password aslinya (hash
`$2y$` Laravel) — bcrypt Rust 0.15 mendukung format `$2y$`, jadi akun lama
(`admin`, `rafa`, `syamsi`, `zidan`, `kiromim`, `test`) bisa login pakai
password masing-masing. App tetap menambah akun fallback `qism`/`password`
lewat `seed()` Rust kalau belum ada.

### 3. Taruh hasilnya di folder app

Salin `qism_point.sqlite` ke:

```
%APPDATA%/com.qism.natijah/qism_point.sqlite
```

Buka app → data siswa & points lama sudah muncul. Selesai.

