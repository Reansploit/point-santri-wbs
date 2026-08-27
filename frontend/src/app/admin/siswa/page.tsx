"use client";

import { Shell } from "@/components/layout/shell";
import { api } from "@/lib/api";
import { useQuery } from "@tanstack/react-query";
import Link from "next/link";
import { useMemo, useState } from "react";
import { Toast } from "@/components/shared/toast";

export default function AdminSiswaPage() {
  const [search, setSearch] = useState("");
  const [kelas, setKelas] = useState("");
  const [nama, setNama] = useState("");
  const [formKelas, setFormKelas] = useState("7");
  const [editId, setEditId] = useState<number | null>(null);
  const [page, setPage] = useState(1);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importKelas, setImportKelas] = useState("7");
  const [toast, setToast] = useState<{ message: string; type: "success" | "error" }>({ message: "", type: "success" });
  const { data, isLoading, isError } = useQuery({
    queryKey: ["admin-siswa", search, kelas, page],
    queryFn: async () => (await api.get("/admin/siswa", { params: { search, kelas, per_page: 10, page } })).data,
  });
  const rows = useMemo(() => data?.data || [], [data]);

  const submit = async () => {
    try {
      if (editId) await api.put(`/admin/siswa/${editId}`, { nama_siswa: nama, kelas: Number(formKelas) });
      else await api.post("/admin/siswa", { nama_siswa: nama, kelas: Number(formKelas) });
      setToast({ message: "Data siswa tersimpan", type: "success" });
    } catch {
      setToast({ message: "Gagal menyimpan data", type: "error" });
    }
    setNama("");
    setEditId(null);
    location.reload();
  };

  const remove = async (id: number) => {
    try {
      await api.delete(`/admin/siswa/${id}`);
      setToast({ message: "Data siswa dihapus", type: "success" });
    } catch {
      setToast({ message: "Gagal menghapus data", type: "error" });
    }
    location.reload();
  };

  const importSiswa = async () => {
    if (!importFile) {
      setToast({ message: "Pilih file import dulu", type: "error" });
      return;
    }
    try {
      const formData = new FormData();
      formData.append("file", importFile);
      formData.append("kelas_default", importKelas);
      const { data } = await api.post("/admin/siswa/import", formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });
      setToast({ message: `Import selesai: ${data.inserted} baru, ${data.updated} duplikat`, type: "success" });
      location.reload();
    } catch {
      setToast({ message: "Import gagal", type: "error" });
    }
  };

  return (
    <Shell title="Data Siswa">
      <Toast message={toast.message} type={toast.type} />
      <div className="glass-card grid gap-3 p-4 md:grid-cols-4">
        <input value={search} onChange={(e) => setSearch(e.target.value)} placeholder="Cari nama siswa" className="rounded-xl border p-2" />
        <select value={kelas} onChange={(e) => setKelas(e.target.value)} className="rounded-xl border p-2">
          <option value="">Semua kelas</option>
          {[7, 8, 9, 10, 11, 12].map((k) => <option key={k} value={k}>{k}</option>)}
        </select>
        <input value={nama} onChange={(e) => setNama(e.target.value)} placeholder="Nama siswa" className="rounded-xl border p-2" />
        <div className="flex gap-2">
          <select value={formKelas} onChange={(e) => setFormKelas(e.target.value)} className="w-full rounded-xl border p-2">
            {[7, 8, 9, 10, 11, 12].map((k) => <option key={k} value={k}>{k}</option>)}
          </select>
          <button onClick={submit} className="rounded-xl bg-slate-900 dark:bg-slate-700 px-4 py-2 text-white">{editId ? "Update" : "Tambah"}</button>
        </div>
      </div>
      <div className="glass-card grid gap-3 p-4 md:grid-cols-4">
        <input type="file" accept=".xlsx,.xls,.csv,.txt" onChange={(e) => setImportFile(e.target.files?.[0] || null)} className="rounded-xl border p-2" />
        <select value={importKelas} onChange={(e) => setImportKelas(e.target.value)} className="rounded-xl border p-2">
          {[7, 8, 9, 10, 11, 12].map((k) => <option key={k} value={k}>{k}</option>)}
        </select>
        <button onClick={importSiswa} className="rounded-xl bg-emerald-600 px-4 py-2 text-white">Import Siswa</button>
        <div className="text-sm text-slate-500 dark:text-slate-400">XLSX/CSV: kolom `nama_siswa`,`kelas` | TXT: satu nama per baris (pakai kelas default).</div>
      </div>
      <div className="grid grid-cols-2 md:grid-cols-6 gap-2">
        {[7, 8, 9, 10, 11, 12].map((kelas) => (
          <Link key={kelas} href={`/admin/siswa/kelas/${kelas}`} className="glass-card p-3 text-center">Kelas {kelas}</Link>
        ))}
      </div>
      <div className="glass-card overflow-auto p-4">
        {isLoading && <div className="animate-pulse text-slate-500 dark:text-slate-400">Memuat data siswa...</div>}
        {isError && <div className="text-rose-600">Gagal mengambil data siswa.</div>}
        <table className="min-w-full text-sm">
          <thead><tr><th className="text-left">Nama</th><th>Kelas</th><th>Aksi</th></tr></thead>
          <tbody>{rows.map((s: any) => <tr key={s.id}><td>{s.nama_siswa}</td><td>{s.kelas}</td><td className="space-x-2"><button onClick={() => { setEditId(s.id); setNama(s.nama_siswa); setFormKelas(String(s.kelas)); }} className="rounded bg-amber-100 dark:bg-amber-900/50 dark:text-amber-200 px-2">Edit</button><button onClick={() => remove(s.id)} className="rounded bg-rose-100 dark:bg-rose-900/50 dark:text-rose-200 px-2">Hapus</button></td></tr>)}</tbody>
        </table>
      </div>
      <div className="flex items-center justify-end gap-2">
        <button disabled={(data?.meta?.current_page || 1) <= 1} onClick={() => setPage((p) => Math.max(1, p - 1))} className="rounded-xl border px-3 py-1 disabled:opacity-40">Prev</button>
        <span className="text-sm text-slate-600 dark:text-slate-400">Page {data?.meta?.current_page || 1} / {data?.meta?.last_page || 1}</span>
        <button disabled={(data?.meta?.current_page || 1) >= (data?.meta?.last_page || 1)} onClick={() => setPage((p) => p + 1)} className="rounded-xl border px-3 py-1 disabled:opacity-40">Next</button>
      </div>
    </Shell>
  );
}
