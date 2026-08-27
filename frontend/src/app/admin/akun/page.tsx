"use client";

import { Shell } from "@/components/layout/shell";
import { Toast } from "@/components/shared/toast";
import { api } from "@/lib/api";
import { useQuery } from "@tanstack/react-query";
import { useState } from "react";

export default function AdminAkunPage() {
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);
  const [form, setForm] = useState({ username: "", password: "", role: "qism" });
  const [toast, setToast] = useState<{ message: string; type: "success" | "error" }>({ message: "", type: "success" });
  const { data, isLoading } = useQuery({
    queryKey: ["admin-users", search, page],
    queryFn: async () => (await api.get("/admin/users", { params: { search, page, per_page: 10 } })).data,
  });

  const submit = async () => {
    try {
      await api.post("/admin/users", form);
      setToast({ message: "Akun berhasil ditambahkan", type: "success" });
      setForm({ username: "", password: "", role: "qism" });
      location.reload();
    } catch {
      setToast({ message: "Gagal tambah akun", type: "error" });
    }
  };

  const updateRole = async (id: number, username: string, role: string) => {
    try {
      await api.put(`/admin/users/${id}`, { username, role });
      setToast({ message: "Role berhasil diubah", type: "success" });
      location.reload();
    } catch {
      setToast({ message: "Gagal ubah role", type: "error" });
    }
  };

  const resetPassword = async (id: number) => {
    const password = prompt("Password baru (min 6 karakter):");
    if (!password) return;
    try {
      await api.put(`/admin/users/${id}/password`, { password });
      setToast({ message: "Password berhasil diubah", type: "success" });
    } catch {
      setToast({ message: "Gagal ubah password", type: "error" });
    }
  };

  const remove = async (id: number) => {
    try {
      await api.delete(`/admin/users/${id}`);
      setToast({ message: "Akun dihapus", type: "success" });
      location.reload();
    } catch {
      setToast({ message: "Gagal hapus akun", type: "error" });
    }
  };

  return (
    <Shell title="Manajemen Akun">
      <Toast message={toast.message} type={toast.type} />
      <div className="glass-card grid gap-3 p-4 md:grid-cols-4">
        <input value={form.username} onChange={(e) => setForm({ ...form, username: e.target.value })} placeholder="Username" className="rounded-xl border p-2" />
        <input value={form.password} onChange={(e) => setForm({ ...form, password: e.target.value })} type="password" placeholder="Password" className="rounded-xl border p-2" />
        <select value={form.role} onChange={(e) => setForm({ ...form, role: e.target.value })} className="rounded-xl border p-2">
          <option value="qism">qism</option>
          <option value="admin">admin</option>
        </select>
        <button onClick={submit} className="rounded-xl bg-slate-900 dark:bg-slate-700 px-4 py-2 text-white">Tambah Akun</button>
      </div>
      <div className="glass-card grid gap-3 p-4 md:grid-cols-3">
        <input value={search} onChange={(e) => setSearch(e.target.value)} placeholder="Cari username..." className="rounded-xl border p-2" />
      </div>
      <div className="glass-card overflow-auto p-4">
        {isLoading && <div className="animate-pulse text-slate-500 dark:text-slate-400">Memuat akun...</div>}
        <table className="min-w-full text-sm">
          <thead><tr><th className="text-left">Username</th><th>Role</th><th>Aksi</th></tr></thead>
          <tbody>
            {(data?.data || []).map((u: any) => (
              <tr key={u.id}>
                <td>{u.username}</td>
                <td>
                  <select defaultValue={u.role} onChange={(e) => updateRole(u.id, u.username, e.target.value)} className="rounded border p-1">
                    <option value="qism">qism</option>
                    <option value="admin">admin</option>
                  </select>
                </td>
                <td className="space-x-2">
                  <button onClick={() => resetPassword(u.id)} className="rounded bg-amber-100 dark:bg-amber-900/50 dark:text-amber-200 px-2">Ganti Password</button>
                  <button onClick={() => remove(u.id)} className="rounded bg-rose-100 dark:bg-rose-900/50 dark:text-rose-200 px-2">Hapus</button>
                </td>
              </tr>
            ))}
          </tbody>
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

