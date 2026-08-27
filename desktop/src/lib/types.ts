export interface User {
  id: number;
  username: string;
  role: string;
}

export interface Siswa {
  id: number;
  nama_siswa: string;
  kelas: number;
}

export interface Point {
  id: number;
  siswa_id: number;
  siswa_nama?: string | null;
  tanggal?: string | null;
  deskripsi?: string | null;
  kategori?: string | null;
  point_positif: number;
  point_negatif: number;
  input_by?: number | null;
}

export interface Paged<T> {
  data: T[];
  page: number;
  per_page: number;
  total: number;
}

export interface RekapRow {
  siswa_id: number;
  nama_siswa: string;
  kelas: number;
  total_positif: number;
  total_negatif: number;
  total: number;
  jumlah: number;
}

export interface KelasRekap {
  kelas: number;
  rows: RekapRow[];
  total_positif: number;
  total_negatif: number;
  total: number;
}

export interface SiswaRekap {
  siswa: Siswa;
  rows: Point[];
  total_positif: number;
  total_negatif: number;
  total: number;
}

export interface Totals {
  total_positif: number;
  total_negatif: number;
  jumlah_siswa: number;
  jumlah_point: number;
}

export interface KelasStat {
  kelas: number;
  jumlah_siswa: number;
  total_positif: number;
  total_negatif: number;
  total: number;
  top: RekapRow[];
}

export interface KategoriStat {
  kategori: string;
  total_positif: number;
  total_negatif: number;
  total: number;
}

export interface Statistik {
  totals: Totals;
  per_kelas: KelasStat[];
  kategori: KategoriStat[];
  total_siswa: number;
  top_global_positif: RekapRow[];
  top_global_negatif: RekapRow[];
  top_per_angkatan_positif: Record<string, RekapRow[]>;
  top_per_angkatan_negatif: Record<string, RekapRow[]>;
}

export interface ImportResult {
  inserted: number;
  skipped: number;
}
