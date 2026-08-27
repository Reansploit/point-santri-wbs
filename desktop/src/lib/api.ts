import { invoke } from "@tauri-apps/api/core";
import type {
  User,
  Siswa,
  Point,
  Paged,
  Statistik,
  RekapRow,
  KelasRekap,
  SiswaRekap,
  ImportResult,
} from "./types";

// Tauri secara otomatis mengonversi argumen camelCase (JS) -> snake_case (Rust).
// Optional args yang `undefined` dihilangkan oleh JSON, sehingga di Rust menjadi `Option::None`.

export const api = {
  // Auth
  login: (username: string, password: string) =>
    invoke<User>("login", { username, password }),
  logout: () => invoke<void>("logout"),
  getCurrentUser: () => invoke<User | null>("get_current_user"),

  // Siswa
  listSiswa: (p: {
    search?: string;
    kelas?: number;
    page?: number;
    perPage?: number;
  }) => invoke<Paged<Siswa>>("list_siswa", p),
  createSiswa: (namaSiswa: string, kelas: number) =>
    invoke<Siswa>("create_siswa", { namaSiswa, kelas }),
  updateSiswa: (id: number, namaSiswa: string, kelas: number) =>
    invoke<Siswa>("update_siswa", { id, namaSiswa, kelas }),
  deleteSiswa: (id: number) => invoke<void>("delete_siswa", { id }),
  importSiswa: (lines: string, kelasDefault: number) =>
    invoke<ImportResult>("import_siswa", { lines, kelasDefault }),
  clearSiswa: () => invoke<void>("clear_siswa"),

  // Points
  listPoints: (p: {
    siswaId?: number;
    search?: string;
    page?: number;
    perPage?: number;
  }) => invoke<Paged<Point>>("list_points", p),
  createPoint: (p: {
    siswaId: number;
    tanggal?: string;
    deskripsi?: string;
    kategori?: string;
    pointPositif?: number;
    pointNegatif?: number;
  }) => invoke<Point>("create_point", p),
  updatePoint: (p: {
    id: number;
    siswaId: number;
    tanggal?: string;
    deskripsi?: string;
    kategori?: string;
    pointPositif?: number;
    pointNegatif?: number;
  }) => invoke<Point>("update_point", p),
  deletePoint: (id: number) => invoke<void>("delete_point", { id }),
  clearPoints: () => invoke<void>("clear_points"),

  // Rekap / statistik
  rekap: (p: { page?: number; perPage?: number }) =>
    invoke<Paged<RekapRow>>("rekap", p),
  rekapSiswa: (siswaId: number) => invoke<SiswaRekap>("rekap_siswa", { siswaId }),
  kelasRekap: (kelas: number) => invoke<KelasRekap>("kelas_rekap", { kelas }),
  statistik: () => invoke<Statistik>("statistik"),

  // Users (admin)
  listUsers: (p: { search?: string; page?: number; perPage?: number }) =>
    invoke<Paged<User>>("list_users", p),
  createUser: (username: string, password: string, role: string) =>
    invoke<User>("create_user", { username, password, role }),
  updateUser: (id: number, username: string, role: string) =>
    invoke<User>("update_user", { id, username, role }),
  updateUserPassword: (id: number, password: string) =>
    invoke<void>("update_user_password", { id, password }),
  deleteUser: (id: number) => invoke<void>("delete_user", { id }),

  // Export
  exportExcel: (kelas?: number) => invoke<string>("export_excel", { kelas }),
};
