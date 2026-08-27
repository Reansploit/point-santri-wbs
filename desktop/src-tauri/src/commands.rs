use crate::db::AppState;
use crate::models::*;
use rusqlite::types::Value;
use rusqlite::{params, params_from_iter, OptionalExtension};
use serde::Serialize;
use std::collections::HashMap;
use std::path::PathBuf;
use tauri::State;
use tauri_plugin_dialog::DialogExt;

fn today() -> String {
    chrono::Local::now().format("%Y-%m-%d").to_string()
}

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

#[tauri::command]
pub fn login(state: State<'_, AppState>, username: String, password: String) -> Result<User, String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    let row: Option<(i64, String, String)> = conn
        .query_row(
            "SELECT id, password, role FROM users WHERE username = ?",
            params![&username],
            |r| Ok((r.get(0)?, r.get(1)?, r.get(2)?)),
        )
        .optional()
        .map_err(|e| e.to_string())?;

    match row {
        Some((id, pw, role)) => {
            let ok = bcrypt::verify(&password, &pw).unwrap_or(false);
            if ok {
                let user = User {
                    id,
                    username,
                    role,
                };
                *state.current.lock().map_err(|e| e.to_string())? = Some(user.clone());
                Ok(user)
            } else {
                Err("Username atau password salah".into())
            }
        }
        None => Err("Username atau password salah".into()),
    }
}

#[tauri::command]
pub fn logout(state: State<'_, AppState>) {
    *state.current.lock().unwrap() = None;
}

#[tauri::command]
pub fn get_current_user(state: State<'_, AppState>) -> Option<User> {
    state.current.lock().unwrap().clone()
}

// ---------------------------------------------------------------------------
// Siswa (admin)
// ---------------------------------------------------------------------------

#[tauri::command]
pub fn list_siswa(
    state: State<'_, AppState>,
    search: Option<String>,
    kelas: Option<i64>,
    page: Option<i64>,
    per_page: Option<i64>,
) -> Result<Paged<Siswa>, String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    let per_page = per_page.unwrap_or(10).max(1);
    let page = page.unwrap_or(1).max(1);

    let mut wheres: Vec<String> = vec![];
    let mut params: Vec<Value> = vec![];
    if let Some(s) = &search {
        if !s.trim().is_empty() {
            wheres.push("LOWER(nama_siswa) LIKE LOWER(?)".into());
            params.push(Value::Text(format!("%{}%", s.trim())));
        }
    }
    if let Some(k) = kelas {
        wheres.push("kelas = ?".into());
        params.push(Value::Integer(k));
    }
    let where_sql = if wheres.is_empty() {
        String::new()
    } else {
        format!(" WHERE {}", wheres.join(" AND "))
    };

    let total: i64 = conn
        .query_row(
            &format!("SELECT COUNT(*) FROM siswa{}", where_sql),
            params_from_iter(params.iter()),
            |r| r.get(0),
        )
        .map_err(|e| e.to_string())?;

    let offset = (page - 1) * per_page;
    let q = format!(
        "SELECT id, nama_siswa, kelas FROM siswa{} ORDER BY kelas, nama_siswa LIMIT ? OFFSET ?",
        where_sql
    );
    let mut qp = params.clone();
    qp.push(Value::Integer(per_page));
    qp.push(Value::Integer(offset));

    let mut stmt = conn
        .prepare(&q)
        .map_err(|e| e.to_string())?;
    let rows = stmt
        .query_map(params_from_iter(qp.iter()), |r| {
            Ok(Siswa {
                id: r.get(0)?,
                nama_siswa: r.get(1)?,
                kelas: r.get(2)?,
            })
        })
        .map_err(|e| e.to_string())?;

    let mut data = vec![];
    for s in rows {
        data.push(s.map_err(|e| e.to_string())?);
    }
    Ok(Paged {
        data,
        page,
        per_page,
        total,
    })
}

#[tauri::command]
pub fn create_siswa(state: State<'_, AppState>, nama_siswa: String, kelas: i64) -> Result<Siswa, String> {
    if !(7..=12).contains(&kelas) {
        return Err("Kelas harus antara 7 dan 12".into());
    }
    if nama_siswa.trim().is_empty() {
        return Err("Nama siswa wajib diisi".into());
    }
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "INSERT INTO siswa (nama_siswa, kelas) VALUES (?1, ?2)",
        params![&nama_siswa.trim(), kelas],
    )
    .map_err(|e| e.to_string())?;
    let id = conn.last_insert_rowid();
    Ok(Siswa {
        id,
        nama_siswa: nama_siswa.trim().to_string(),
        kelas,
    })
}

#[tauri::command]
pub fn update_siswa(state: State<'_, AppState>, id: i64, nama_siswa: String, kelas: i64) -> Result<Siswa, String> {
    if !(7..=12).contains(&kelas) {
        return Err("Kelas harus antara 7 dan 12".into());
    }
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE siswa SET nama_siswa = ?1, kelas = ?2, updated_at = datetime('now') WHERE id = ?3",
        params![&nama_siswa.trim(), kelas, id],
    )
    .map_err(|e| e.to_string())?;
    Ok(Siswa {
        id,
        nama_siswa: nama_siswa.trim().to_string(),
        kelas,
    })
}

#[tauri::command]
pub fn delete_siswa(state: State<'_, AppState>, id: i64) -> Result<(), String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute("DELETE FROM siswa WHERE id = ?", params![id])
        .map_err(|e| e.to_string())?;
    Ok(())
}

#[tauri::command]
pub fn import_siswa(state: State<'_, AppState>, lines: String, kelas_default: i64) -> Result<ImportResult, String> {
    if !(7..=12).contains(&kelas_default) {
        return Err("Kelas default harus antara 7 dan 12".into());
    }
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    let mut inserted = 0i64;
    let mut skipped = 0i64;
    for raw in lines.lines() {
        let name = raw.trim();
        if name.is_empty() {
            continue;
        }
        match conn.execute(
            "INSERT INTO siswa (nama_siswa, kelas) VALUES (?1, ?2)",
            params![&name.to_string(), kelas_default],
        ) {
            Ok(_) => inserted += 1,
            Err(_) => skipped += 1,
        }
    }
    Ok(ImportResult { inserted, skipped })
}

#[derive(Serialize)]
pub struct ImportResult {
    pub inserted: i64,
    pub skipped: i64,
}

#[tauri::command]
pub fn clear_siswa(state: State<'_, AppState>) -> Result<(), String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute("DELETE FROM siswa", [])
        .map_err(|e| e.to_string())?;
    Ok(())
}

// ---------------------------------------------------------------------------
// Points (qism)
// ---------------------------------------------------------------------------

#[tauri::command]
pub fn list_points(
    state: State<'_, AppState>,
    siswa_id: Option<i64>,
    search: Option<String>,
    page: Option<i64>,
    per_page: Option<i64>,
) -> Result<Paged<Point>, String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    let per_page = per_page.unwrap_or(10).max(1);
    let page = page.unwrap_or(1).max(1);

    let mut wheres: Vec<String> = vec![];
    let mut params: Vec<Value> = vec![];
    if let Some(sid) = siswa_id {
        wheres.push("p.siswa_id = ?".into());
        params.push(Value::Integer(sid));
    }
    if let Some(s) = &search {
        if !s.trim().is_empty() {
            wheres.push(
                "(LOWER(s.nama_siswa) LIKE LOWER(?) OR LOWER(p.deskripsi) LIKE LOWER(?))".into(),
            );
            params.push(Value::Text(format!("%{}%", s.trim())));
            params.push(Value::Text(format!("%{}%", s.trim())));
        }
    }
    let where_sql = if wheres.is_empty() {
        String::new()
    } else {
        format!(" WHERE {}", wheres.join(" AND "))
    };

    let total: i64 = conn
        .query_row(
            &format!(
                "SELECT COUNT(*) FROM points p JOIN siswa s ON s.id = p.siswa_id{}",
                where_sql
            ),
            params_from_iter(params.iter()),
            |r| r.get(0),
        )
        .map_err(|e| e.to_string())?;

    let offset = (page - 1) * per_page;
    let q = format!(
        "SELECT p.id, p.siswa_id, s.nama_siswa, p.tanggal, p.deskripsi, p.kategori,
                p.point_positif, p.point_negatif, p.input_by
         FROM points p JOIN siswa s ON s.id = p.siswa_id{}
         ORDER BY p.tanggal DESC, p.id DESC LIMIT ? OFFSET ?",
        where_sql
    );
    let mut qp = params.clone();
    qp.push(Value::Integer(per_page));
    qp.push(Value::Integer(offset));

    let mut stmt = conn.prepare(&q).map_err(|e| e.to_string())?;
    let rows = stmt
        .query_map(params_from_iter(qp.iter()), |r| {
            Ok(Point {
                id: r.get(0)?,
                siswa_id: r.get(1)?,
                siswa_nama: r.get(2)?,
                tanggal: r.get(3)?,
                deskripsi: r.get(4)?,
                kategori: r.get(5)?,
                point_positif: r.get(6)?,
                point_negatif: r.get(7)?,
                input_by: r.get(8)?,
            })
        })
        .map_err(|e| e.to_string())?;

    let mut data = vec![];
    for p in rows {
        data.push(p.map_err(|e| e.to_string())?);
    }
    Ok(Paged {
        data,
        page,
        per_page,
        total,
    })
}

#[tauri::command]
pub fn create_point(
    state: State<'_, AppState>,
    siswa_id: i64,
    tanggal: Option<String>,
    deskripsi: Option<String>,
    kategori: Option<String>,
    point_positif: Option<i64>,
    point_negatif: Option<i64>,
) -> Result<Point, String> {
    let (pos, neg) = normalize(point_positif.unwrap_or(0), point_negatif.unwrap_or(0));
    let tanggal = tanggal.filter(|t| !t.trim().is_empty()).unwrap_or_else(today);
    let kategori = kategori.filter(|k| !k.trim().is_empty()).unwrap_or_else(|| "Umum".into());
    let deskripsi = deskripsi.filter(|d| !d.trim().is_empty()).unwrap_or_else(|| "-".into());
    let input_by = state.current.lock().map_err(|e| e.to_string())?.as_ref().map(|u| u.id);

    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "INSERT INTO points (siswa_id, tanggal, deskripsi, kategori, point_positif, point_negatif, input_by)
         VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7)",
        params![siswa_id, &tanggal, &deskripsi, &kategori, pos, neg, input_by],
    )
    .map_err(|e| e.to_string())?;
    let id = conn.last_insert_rowid();
    Ok(Point {
        id,
        siswa_id,
        siswa_nama: None,
        tanggal: Some(tanggal),
        deskripsi: Some(deskripsi),
        kategori: Some(kategori),
        point_positif: pos,
        point_negatif: neg,
        input_by,
    })
}

#[tauri::command]
pub fn update_point(
    state: State<'_, AppState>,
    id: i64,
    siswa_id: i64,
    tanggal: Option<String>,
    deskripsi: Option<String>,
    kategori: Option<String>,
    point_positif: Option<i64>,
    point_negatif: Option<i64>,
) -> Result<Point, String> {
    let (pos, neg) = normalize(point_positif.unwrap_or(0), point_negatif.unwrap_or(0));
    let tanggal = tanggal.filter(|t| !t.trim().is_empty()).unwrap_or_else(today);
    let kategori = kategori.filter(|k| !k.trim().is_empty()).unwrap_or_else(|| "Umum".into());
    let deskripsi = deskripsi.filter(|d| !d.trim().is_empty()).unwrap_or_else(|| "-".into());

    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE points SET siswa_id=?1, tanggal=?2, deskripsi=?3, kategori=?4,
         point_positif=?5, point_negatif=?6, updated_at=datetime('now') WHERE id=?7",
        params![siswa_id, &tanggal, &deskripsi, &kategori, pos, neg, id],
    )
    .map_err(|e| e.to_string())?;
    Ok(Point {
        id,
        siswa_id,
        siswa_nama: None,
        tanggal: Some(tanggal),
        deskripsi: Some(deskripsi),
        kategori: Some(kategori),
        point_positif: pos,
        point_negatif: neg,
        input_by: None,
    })
}

fn normalize(pos: i64, neg: i64) -> (i64, i64) {
    let pos = pos.max(0);
    let neg = neg.max(0);
    if pos > 0 {
        (pos, 0)
    } else if neg > 0 {
        (0, neg)
    } else {
        (0, 0)
    }
}

#[tauri::command]
pub fn delete_point(state: State<'_, AppState>, id: i64) -> Result<(), String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute("DELETE FROM points WHERE id = ?", params![id])
        .map_err(|e| e.to_string())?;
    Ok(())
}

#[tauri::command]
pub fn clear_points(state: State<'_, AppState>) -> Result<(), String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute("DELETE FROM points", [])
        .map_err(|e| e.to_string())?;
    Ok(())
}

// ---------------------------------------------------------------------------
// Rekap / statistik
// ---------------------------------------------------------------------------

fn map_rekap_row(r: &rusqlite::Row) -> rusqlite::Result<RekapRow> {
    Ok(RekapRow {
        siswa_id: r.get(0)?,
        nama_siswa: r.get(1)?,
        kelas: r.get(2)?,
        total_positif: r.get(3)?,
        total_negatif: r.get(4)?,
        total: r.get(5)?,
        jumlah: r.get(6)?,
    })
}

#[tauri::command]
pub fn rekap(
    state: State<'_, AppState>,
    page: Option<i64>,
    per_page: Option<i64>,
) -> Result<Paged<RekapRow>, String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    let per_page = per_page.unwrap_or(10).max(1);
    let page = page.unwrap_or(1).max(1);

    let total: i64 = conn
        .query_row("SELECT COUNT(*) FROM siswa", [], |r| r.get(0))
        .map_err(|e| e.to_string())?;
    let offset = (page - 1) * per_page;

    let q = "SELECT s.id, s.nama_siswa, s.kelas,
                    COALESCE(SUM(p.point_positif),0), COALESCE(SUM(p.point_negatif),0),
                    COALESCE(SUM(p.point_positif - p.point_negatif),0) AS total, COUNT(p.id)
             FROM siswa s LEFT JOIN points p ON p.siswa_id = s.id
             GROUP BY s.id ORDER BY total DESC, s.kelas, s.nama_siswa
             LIMIT ? OFFSET ?";
    let mut stmt = conn.prepare(q).map_err(|e| e.to_string())?;
    let rows = stmt
        .query_map(params![per_page, offset], map_rekap_row)
        .map_err(|e| e.to_string())?;
    let mut data = vec![];
    for r in rows {
        data.push(r.map_err(|e| e.to_string())?);
    }
    Ok(Paged {
        data,
        page,
        per_page,
        total,
    })
}

#[tauri::command]
pub fn rekap_siswa(state: State<'_, AppState>, siswa_id: i64) -> Result<SiswaRekap, String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    let siswa: Option<Siswa> = conn
        .query_row(
            "SELECT id, nama_siswa, kelas FROM siswa WHERE id = ?",
            params![siswa_id],
            |r| {
                Ok(Siswa {
                    id: r.get(0)?,
                    nama_siswa: r.get(1)?,
                    kelas: r.get(2)?,
                })
            },
        )
        .optional()
        .map_err(|e| e.to_string())?;
    let siswa = siswa.ok_or("Siswa tidak ditemukan")?;

    let mut stmt = conn
        .prepare(
            "SELECT p.id, p.siswa_id, s.nama_siswa, p.tanggal, p.deskripsi, p.kategori,
                    p.point_positif, p.point_negatif, p.input_by
             FROM points p JOIN siswa s ON s.id = p.siswa_id
             WHERE p.siswa_id = ? ORDER BY p.tanggal DESC, p.id DESC",
        )
        .map_err(|e| e.to_string())?;
    let rows = stmt
        .query_map(params![siswa_id], |r| {
            Ok(Point {
                id: r.get(0)?,
                siswa_id: r.get(1)?,
                siswa_nama: r.get(2)?,
                tanggal: r.get(3)?,
                deskripsi: r.get(4)?,
                kategori: r.get(5)?,
                point_positif: r.get(6)?,
                point_negatif: r.get(7)?,
                input_by: r.get(8)?,
            })
        })
        .map_err(|e| e.to_string())?;
    let mut point_rows = vec![];
    for p in rows {
        point_rows.push(p.map_err(|e| e.to_string())?);
    }

    let (tp, tn, tot): (i64, i64, i64) = conn
        .query_row(
            "SELECT COALESCE(SUM(point_positif),0), COALESCE(SUM(point_negatif),0),
                    COALESCE(SUM(point_positif - point_negatif),0)
             FROM points WHERE siswa_id = ?",
            params![siswa_id],
            |r| Ok((r.get(0)?, r.get(1)?, r.get(2)?)),
        )
        .map_err(|e| e.to_string())?;

    Ok(SiswaRekap {
        siswa,
        rows: point_rows,
        total_positif: tp,
        total_negatif: tn,
        total: tot,
    })
}

#[derive(Serialize)]
pub struct SiswaRekap {
    pub siswa: Siswa,
    pub rows: Vec<Point>,
    pub total_positif: i64,
    pub total_negatif: i64,
    pub total: i64,
}

#[tauri::command]
pub fn kelas_rekap(state: State<'_, AppState>, kelas: i64) -> Result<KelasRekap, String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT s.id, s.nama_siswa, s.kelas,
                    COALESCE(SUM(p.point_positif),0), COALESCE(SUM(p.point_negatif),0),
                    COALESCE(SUM(p.point_positif - p.point_negatif),0) AS total, COUNT(p.id)
             FROM siswa s LEFT JOIN points p ON p.siswa_id = s.id
             WHERE s.kelas = ? GROUP BY s.id ORDER BY total DESC, s.nama_siswa",
        )
        .map_err(|e| e.to_string())?;
    let rows = stmt
        .query_map(params![kelas], map_rekap_row)
        .map_err(|e| e.to_string())?;
    let mut data = vec![];
    for r in rows {
        data.push(r.map_err(|e| e.to_string())?);
    }
    let (tp, tn, tot): (i64, i64, i64) = conn
        .query_row(
            "SELECT COALESCE(SUM(p.point_positif),0), COALESCE(SUM(p.point_negatif),0),
                    COALESCE(SUM(p.point_positif - p.point_negatif),0)
             FROM points p JOIN siswa s ON s.id = p.siswa_id WHERE s.kelas = ?",
            params![kelas],
            |r| Ok((r.get(0)?, r.get(1)?, r.get(2)?)),
        )
        .map_err(|e| e.to_string())?;
    Ok(KelasRekap {
        kelas,
        rows: data,
        total_positif: tp,
        total_negatif: tn,
        total: tot,
    })
}

#[derive(Serialize)]
pub struct KelasRekap {
    pub kelas: i64,
    pub rows: Vec<RekapRow>,
    pub total_positif: i64,
    pub total_negatif: i64,
    pub total: i64,
}

#[tauri::command]
pub fn statistik(state: State<'_, AppState>) -> Result<Statistik, String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;

    let (total_positif, total_negatif, jumlah_point): (i64, i64, i64) = conn
        .query_row(
            "SELECT COALESCE(SUM(point_positif),0), COALESCE(SUM(point_negatif),0), COUNT(*)
             FROM points",
            [],
            |r| Ok((r.get(0)?, r.get(1)?, r.get(2)?)),
        )
        .map_err(|e| e.to_string())?;
    let jumlah_siswa: i64 = conn
        .query_row("SELECT COUNT(*) FROM siswa", [], |r| r.get(0))
        .map_err(|e| e.to_string())?;

    let mut per_kelas = vec![];
    for k in 7..=12 {
        let (js, tp, tn, tot): (i64, i64, i64, i64) = conn
            .query_row(
                "SELECT COUNT(DISTINCT s.id),
                        COALESCE(SUM(p.point_positif),0), COALESCE(SUM(p.point_negatif),0),
                        COALESCE(SUM(p.point_positif - p.point_negatif),0)
                 FROM siswa s LEFT JOIN points p ON p.siswa_id = s.id WHERE s.kelas = ?",
                params![k],
                |r| Ok((r.get(0)?, r.get(1)?, r.get(2)?, r.get(3)?)),
            )
            .map_err(|e| e.to_string())?;

        let mut stmt = conn
            .prepare(
                "SELECT s.id, s.nama_siswa, s.kelas,
                        COALESCE(SUM(p.point_positif),0), COALESCE(SUM(p.point_negatif),0),
                        COALESCE(SUM(p.point_positif - p.point_negatif),0) AS total, COUNT(p.id)
                 FROM siswa s LEFT JOIN points p ON p.siswa_id = s.id
                 WHERE s.kelas = ? GROUP BY s.id ORDER BY total DESC LIMIT 5",
            )
            .map_err(|e| e.to_string())?;
        let top = stmt
            .query_map(params![k], map_rekap_row)
            .map_err(|e| e.to_string())?
            .map(|r| r.map_err(|e| e.to_string()))
            .collect::<Result<Vec<_>, _>>()?;

        per_kelas.push(KelasStat {
            kelas: k,
            jumlah_siswa: js,
            total_positif: tp,
            total_negatif: tn,
            total: tot,
            top,
        });
    }

    let mut kstmt = conn
        .prepare(
            "SELECT COALESCE(kategori,'Umum'),
                    COALESCE(SUM(point_positif),0), COALESCE(SUM(point_negatif),0),
                    COALESCE(SUM(point_positif - point_negatif),0) AS total
             FROM points GROUP BY kategori ORDER BY total DESC",
        )
        .map_err(|e| e.to_string())?;
    let kategori = kstmt
        .query_map([], |r| {
            Ok(KategoriStat {
                kategori: r.get(0)?,
                total_positif: r.get(1)?,
                total_negatif: r.get(2)?,
                total: r.get(3)?,
            })
        })
        .map_err(|e| e.to_string())?
        .map(|r| r.map_err(|e| e.to_string()))
        .collect::<Result<Vec<_>, _>>()?;

    let top_global_positif: Vec<RekapRow> = conn
        .prepare(
            "SELECT s.id, s.nama_siswa, s.kelas,
                    COALESCE(SUM(p.point_positif),0), COALESCE(SUM(p.point_negatif),0),
                    COALESCE(SUM(p.point_positif - p.point_negatif),0) AS total, COUNT(p.id)
             FROM siswa s LEFT JOIN points p ON p.siswa_id = s.id
             GROUP BY s.id ORDER BY total_positif DESC, s.nama_siswa LIMIT 10",
        )
        .map_err(|e| e.to_string())?
        .query_map([], map_rekap_row)
        .map_err(|e| e.to_string())?
        .map(|r| r.map_err(|e| e.to_string()))
        .collect::<Result<Vec<_>, _>>()?;

    let top_global_negatif: Vec<RekapRow> = conn
        .prepare(
            "SELECT s.id, s.nama_siswa, s.kelas,
                    COALESCE(SUM(p.point_positif),0), COALESCE(SUM(p.point_negatif),0),
                    COALESCE(SUM(p.point_positif - p.point_negatif),0) AS total, COUNT(p.id)
             FROM siswa s LEFT JOIN points p ON p.siswa_id = s.id
             GROUP BY s.id ORDER BY total_negatif DESC, s.nama_siswa LIMIT 10",
        )
        .map_err(|e| e.to_string())?
        .query_map([], map_rekap_row)
        .map_err(|e| e.to_string())?
        .map(|r| r.map_err(|e| e.to_string()))
        .collect::<Result<Vec<_>, _>>()?;

    let mut top_per_angkatan_positif: HashMap<i64, Vec<RekapRow>> = HashMap::new();
    let mut top_per_angkatan_negatif: HashMap<i64, Vec<RekapRow>> = HashMap::new();
    for k in 7..=12 {
        let pos: Vec<RekapRow> = conn
            .prepare(
                "SELECT s.id, s.nama_siswa, s.kelas,
                        COALESCE(SUM(p.point_positif),0), COALESCE(SUM(p.point_negatif),0),
                        COALESCE(SUM(p.point_positif - p.point_negatif),0) AS total, COUNT(p.id)
                 FROM siswa s LEFT JOIN points p ON p.siswa_id = s.id
                 WHERE s.kelas = ? GROUP BY s.id ORDER BY total_positif DESC LIMIT 10",
            )
            .map_err(|e| e.to_string())?
            .query_map(params![k], map_rekap_row)
            .map_err(|e| e.to_string())?
            .map(|r| r.map_err(|e| e.to_string()))
            .collect::<Result<Vec<_>, _>>()?;
        top_per_angkatan_positif.insert(k, pos);

        let neg: Vec<RekapRow> = conn
            .prepare(
                "SELECT s.id, s.nama_siswa, s.kelas,
                        COALESCE(SUM(p.point_positif),0), COALESCE(SUM(p.point_negatif),0),
                        COALESCE(SUM(p.point_positif - p.point_negatif),0) AS total, COUNT(p.id)
                 FROM siswa s LEFT JOIN points p ON p.siswa_id = s.id
                 WHERE s.kelas = ? GROUP BY s.id ORDER BY total_negatif DESC LIMIT 10",
            )
            .map_err(|e| e.to_string())?
            .query_map(params![k], map_rekap_row)
            .map_err(|e| e.to_string())?
            .map(|r| r.map_err(|e| e.to_string()))
            .collect::<Result<Vec<_>, _>>()?;
        top_per_angkatan_negatif.insert(k, neg);
    }

    Ok(Statistik {
        totals: Totals {
            total_positif,
            total_negatif,
            jumlah_siswa,
            jumlah_point,
        },
        per_kelas,
        kategori,
        total_siswa: jumlah_siswa,
        top_global_positif,
        top_global_negatif,
        top_per_angkatan_positif,
        top_per_angkatan_negatif,
    })
}

// ---------------------------------------------------------------------------
// Users (admin)
// ---------------------------------------------------------------------------

#[tauri::command]
pub fn list_users(
    state: State<'_, AppState>,
    search: Option<String>,
    page: Option<i64>,
    per_page: Option<i64>,
) -> Result<Paged<User>, String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    let per_page = per_page.unwrap_or(10).max(1);
    let page = page.unwrap_or(1).max(1);

    let mut where_sql = String::new();
    let mut params: Vec<Value> = vec![];
    if let Some(s) = &search {
        if !s.trim().is_empty() {
            where_sql = " WHERE LOWER(username) LIKE LOWER(?)".into();
            params.push(Value::Text(format!("%{}%", s.trim())));
        }
    }
    let total: i64 = conn
        .query_row(
            &format!("SELECT COUNT(*) FROM users{}", where_sql),
            params_from_iter(params.iter()),
            |r| r.get(0),
        )
        .map_err(|e| e.to_string())?;
    let offset = (page - 1) * per_page;
    let mut qp = params.clone();
    qp.push(Value::Integer(per_page));
    qp.push(Value::Integer(offset));

    let mut stmt = conn
        .prepare(&format!(
            "SELECT id, username, role FROM users{} ORDER BY username LIMIT ? OFFSET ?",
            where_sql
        ))
        .map_err(|e| e.to_string())?;
    let rows = stmt
        .query_map(params_from_iter(qp.iter()), |r| {
            Ok(User {
                id: r.get(0)?,
                username: r.get(1)?,
                role: r.get(2)?,
            })
        })
        .map_err(|e| e.to_string())?;
    let mut data = vec![];
    for u in rows {
        data.push(u.map_err(|e| e.to_string())?);
    }
    Ok(Paged {
        data,
        page,
        per_page,
        total,
    })
}

#[tauri::command]
pub fn create_user(state: State<'_, AppState>, username: String, password: String, role: String) -> Result<User, String> {
    if username.trim().is_empty() || password.is_empty() {
        return Err("Username dan password wajib diisi".into());
    }
    let role = if role == "admin" { "admin" } else { "qism" };
    let pw = bcrypt::hash(&password, 12).map_err(|e| e.to_string())?;
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "INSERT INTO users (username, password, role) VALUES (?1, ?2, ?3)",
        params![&username.trim().to_string(), &pw, role],
    )
    .map_err(|e| e.to_string())?;
    let id = conn.last_insert_rowid();
    Ok(User {
        id,
        username: username.trim().to_string(),
        role: role.to_string(),
    })
}

#[tauri::command]
pub fn update_user(state: State<'_, AppState>, id: i64, username: String, role: String) -> Result<User, String> {
    let role = if role == "admin" { "admin" } else { "qism" };
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE users SET username = ?1, role = ?2, updated_at = datetime('now') WHERE id = ?3",
        params![&username.trim().to_string(), role, id],
    )
    .map_err(|e| e.to_string())?;
    Ok(User {
        id,
        username: username.trim().to_string(),
        role: role.to_string(),
    })
}

#[tauri::command]
pub fn update_user_password(state: State<'_, AppState>, id: i64, password: String) -> Result<(), String> {
    if password.is_empty() {
        return Err("Password wajib diisi".into());
    }
    let pw = bcrypt::hash(&password, 12).map_err(|e| e.to_string())?;
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE users SET password = ?1, updated_at = datetime('now') WHERE id = ?2",
        params![&pw, id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

#[tauri::command]
pub fn delete_user(state: State<'_, AppState>, id: i64) -> Result<(), String> {
    let conn = state.db.lock().map_err(|e| e.to_string())?;
    let n: i64 = conn
        .query_row("SELECT COUNT(*) FROM users", [], |r| r.get(0))
        .map_err(|e| e.to_string())?;
    if n <= 1 {
        return Err("Minimal harus ada 1 user".into());
    }
    conn.execute("DELETE FROM users WHERE id = ?", params![id])
        .map_err(|e| e.to_string())?;
    Ok(())
}

// ---------------------------------------------------------------------------
// Export Excel
// ---------------------------------------------------------------------------

#[tauri::command]
pub fn export_excel(
    app: tauri::AppHandle,
    state: State<'_, AppState>,
    kelas: Option<i64>,
) -> Result<String, String> {
    let (tx, rx) = std::sync::mpsc::channel();
    app.dialog()
        .file()
        .set_title("Simpan Laporan Excel")
        .set_file_name("qism-natijah.xlsx")
        .add_filter("Excel", &["xlsx"])
        .save_file(move |path| {
            let _ = tx.send(path);
        });
    let path = rx.recv().map_err(|e| e.to_string())?;
    let path = path.ok_or("Dibatalkan")?;
    let path: PathBuf = path.into_path().map_err(|e| e.to_string())?;

    let conn = state.db.lock().map_err(|e| e.to_string())?;
    write_excel(&conn, &path, kelas)?;
    Ok(path.to_string_lossy().to_string())
}

fn write_excel(conn: &rusqlite::Connection, path: &PathBuf, kelas: Option<i64>) -> Result<(), String> {
    use rusqlite::types::Value;
    let mut workbook = rust_xlsxwriter::Workbook::new();
    let sheet = workbook.add_worksheet();
    sheet
        .set_name("Rekap")
        .map_err(|e| e.to_string())?;

    sheet
        .write(0, 0, "كشف الدرجات لقسم النتائج")
        .map_err(|e| e.to_string())?;

    let headers = [
        "Tanggal",
        "Nama Siswa",
        "Kelas",
        "Kategori",
        "Deskripsi",
        "Point Positif",
        "Point Negatif",
        "Total",
    ];
    for (c, h) in headers.iter().enumerate() {
        sheet
            .write(3, c as u16, *h)
            .map_err(|e| e.to_string())?;
    }

    let mut sql = "SELECT p.tanggal, s.nama_siswa, s.kelas, p.kategori, p.deskripsi,
                          p.point_positif, p.point_negatif
                   FROM points p JOIN siswa s ON s.id = p.siswa_id"
        .to_string();
    let mut params: Vec<Value> = vec![];
    if let Some(k) = kelas {
        sql.push_str(" WHERE s.kelas = ?");
        params.push(Value::Integer(k));
    }
    sql.push_str(" ORDER BY s.kelas, s.nama_siswa, p.tanggal");

    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let mut rows = stmt
        .query(params_from_iter(params))
        .map_err(|e| e.to_string())?;
    let mut r = 4u32;
    while let Some(row) = rows.next().map_err(|e| e.to_string())? {
        let tanggal: Option<String> = row.get(0).map_err(|e| e.to_string())?;
        let nama: String = row.get(1).map_err(|e| e.to_string())?;
        let nama_ref: &str = nama.as_str();
        let kelasv: i64 = row.get(2).map_err(|e| e.to_string())?;
        let kategori: Option<String> = row.get(3).map_err(|e| e.to_string())?;
        let deskripsi: Option<String> = row.get(4).map_err(|e| e.to_string())?;
        let pos: i64 = row.get(5).map_err(|e| e.to_string())?;
        let neg: i64 = row.get(6).map_err(|e| e.to_string())?;
        sheet.write(r, 0, tanggal.unwrap_or_default()).map_err(|e| e.to_string())?;
        sheet.write(r, 1, nama_ref).map_err(|e| e.to_string())?;
        sheet.write(r, 2, kelasv).map_err(|e| e.to_string())?;
        sheet.write(r, 3, kategori.unwrap_or_default()).map_err(|e| e.to_string())?;
        sheet.write(r, 4, deskripsi.unwrap_or_default()).map_err(|e| e.to_string())?;
        sheet.write(r, 5, pos).map_err(|e| e.to_string())?;
        sheet.write(r, 6, neg).map_err(|e| e.to_string())?;
        sheet.write(r, 7, pos - neg).map_err(|e| e.to_string())?;
        r += 1;
    }

    workbook.save(path).map_err(|e| e.to_string())?;
    Ok(())
}
