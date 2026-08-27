"use client";

import Link from "next/link";
import { Shell } from "@/components/layout/shell";
import { api } from "@/lib/api";
import { useState } from "react";
import { Toast } from "@/components/shared/toast";

export default function AdminPage() {
  const [toast, setToast] = useState<{ message: string; type: "success" | "error" }>({ message: "", type: "success" });

  const clearPoints = async () => {
    if (!window.confirm("Yakin ingin menghapus SEMUA point? Tindakan ini tidak bisa dibatalkan.")) return;
    try {
      const { data } = await api.post("/admin/points/clear");
      setToast({ message: `Semua point dihapus (${data.deleted} record)`, type: "success" });
    } catch {
      setToast({ message: "Gagal menghapus point", type: "error" });
    }
  };

  const clearSiswa = async () => {
    if (!window.confirm("Yakin ingin menghapus SEMUA data siswa? Point mereka ikut terhapus, tetapi akun login tetap aman.")) return;
    try {
      const { data } = await api.post("/admin/siswa/clear");
      setToast({ message: `Semua data siswa dihapus (${data.deleted} siswa, ${data.points_deleted} point)`, type: "success" });
    } catch {
      setToast({ message: "Gagal menghapus data siswa", type: "error" });
    }
  };

  return (
    <Shell title="Admin Dashboard">
      <Toast message={toast.message} type={toast.type} />
      <div className="glass-card p-6">
        <p className="mb-4 text-slate-600 dark:text-slate-400">Kelola master data siswa.</p>
        <div className="flex gap-3">
          <Link href="/admin/siswa" className="rounded-xl bg-slate-900 dark:bg-slate-700 px-4 py-2 text-white">Buka Data Siswa</Link>
          <Link href="/admin/akun" className="rounded-xl bg-emerald-600 px-4 py-2 text-white">Manajemen Akun</Link>
        </div>
      </div>
      <div className="glass-card p-6">
        <h2 className="mb-1 text-lg font-semibold">Reset Data</h2>
        <p className="mb-4 text-sm text-slate-500 dark:text-slate-400">Hapus seluruh data point dan/atau data siswa. Akun login tidak terpengaruh.</p>
        <div className="flex gap-3">
          <button onClick={clearPoints} className="rounded-xl bg-amber-600 px-4 py-2 text-white">Clear Semua Point</button>
          <button onClick={clearSiswa} className="rounded-xl bg-rose-600 px-4 py-2 text-white">Clear Semua Data Siswa</button>
        </div>
      </div>
    </Shell>
  );
}
