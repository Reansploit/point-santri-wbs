use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone)]
pub struct User {
    pub id: i64,
    pub username: String,
    pub role: String,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct Siswa {
    pub id: i64,
    pub nama_siswa: String,
    pub kelas: i64,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct Point {
    pub id: i64,
    pub siswa_id: i64,
    pub siswa_nama: Option<String>,
    pub tanggal: Option<String>,
    pub deskripsi: Option<String>,
    pub kategori: Option<String>,
    pub point_positif: i64,
    pub point_negatif: i64,
    pub input_by: Option<i64>,
}

#[derive(Serialize)]
pub struct Paged<T> {
    pub data: Vec<T>,
    pub page: i64,
    pub per_page: i64,
    pub total: i64,
}

#[derive(Serialize, Clone)]
pub struct RekapRow {
    pub siswa_id: i64,
    pub nama_siswa: String,
    pub kelas: i64,
    pub total_positif: i64,
    pub total_negatif: i64,
    pub total: i64,
    pub jumlah: i64,
}

#[derive(Serialize)]
pub struct Totals {
    pub total_positif: i64,
    pub total_negatif: i64,
    pub jumlah_siswa: i64,
    pub jumlah_point: i64,
}

#[derive(Serialize)]
pub struct KelasStat {
    pub kelas: i64,
    pub jumlah_siswa: i64,
    pub total_positif: i64,
    pub total_negatif: i64,
    pub total: i64,
    pub top: Vec<RekapRow>,
}

#[derive(Serialize)]
pub struct KategoriStat {
    pub kategori: String,
    pub total_positif: i64,
    pub total_negatif: i64,
    pub total: i64,
}

#[derive(Serialize)]
pub struct Statistik {
    pub totals: Totals,
    pub per_kelas: Vec<KelasStat>,
    pub kategori: Vec<KategoriStat>,
    pub total_siswa: i64,
    pub top_global_positif: Vec<RekapRow>,
    pub top_global_negatif: Vec<RekapRow>,
    pub top_per_angkatan_positif: std::collections::HashMap<i64, Vec<RekapRow>>,
    pub top_per_angkatan_negatif: std::collections::HashMap<i64, Vec<RekapRow>>,
}
