export type Role = "admin" | "qism";

export interface User {
  id: number;
  username: string;
  role: Role;
}

export interface Siswa {
  id: number;
  nama_siswa: string;
  kelas: number;
  total_positif?: number;
  total_negatif?: number;
  total_input?: number;
}

