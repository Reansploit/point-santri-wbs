"use client";

import { Shell } from "@/components/layout/shell";
import { api } from "@/lib/api";
import { useQuery } from "@tanstack/react-query";
import { Suspense, useMemo, useState } from "react";
import { Toast } from "@/components/shared/toast";
import { useSearchParams } from "next/navigation";

function PointPageContent() {
  const searchParams = useSearchParams();
  const siswaIdFromUrl = searchParams.get("siswa_id") || "";
  const { data: siswa } = useQuery({ queryKey: ["siswa-options"], queryFn: async () => (await api.get("/qism/rekap")).data });
  const [siswaSearch, setSiswaSearch] = useState("");
  const [sort, setSort] = useState<"positif" | "negatif">("positif");
  const [page, setPage] = useState(1);
  const [toast, setToast] = useState<{ message: string; type: "success" | "error" }>({ message: "", type: "success" });
  const { data: points, isLoading, isError } = useQuery({
    queryKey: ["points", page],
    queryFn: async () => (await api.get("/qism/point", { params: { per_page: 10, page } })).data,
  });
  const [form, setForm] = useState({ siswa_id: siswaIdFromUrl, point_positif: 0, point_negatif: 0 });
  const [editId, setEditId] = useState<number | null>(null);
  const filteredSiswa = useMemo(() => {
    const q = siswaSearch.trim().toLowerCase();
    if (!q) return [];
    return (siswa || []).filter((s: any) => s.nama_siswa.toLowerCase().includes(q));
  }, [siswa, siswaSearch]);
  const selectedSiswa = useMemo(
    () => (siswa || []).find((s: any) => String(s.id) === form.siswa_id),
    [siswa, form.siswa_id]
  );

  const submit = async () => {
    if (!form.siswa_id) {
      setToast({ message: "Pilih siswa terlebih dahulu", type: "error" });
      return;
    }
    try {
      if (editId) await api.put(`/qism/point/${editId}`, { ...form, siswa_id: Number(form.siswa_id) });
      else await api.post("/qism/point", { ...form, siswa_id: Number(form.siswa_id) });
      setToast({ message: "Point tersimpan", type: "success" });
    } catch {
      setToast({ message: "Gagal menyimpan point", type: "error" });
    }
    setEditId(null);
    location.reload();
  };
  const remove = async (id: number) => {
    try {
      await api.delete(`/qism/point/${id}`);
      setToast({ message: "Point dihapus", type: "success" });
    } catch {
      setToast({ message: "Gagal menghapus point", type: "error" });
    }
    location.reload();
  };

  return (
    <Shell title="Input Point">
      <Toast message={toast.message} type={toast.type} />
      <div className="glass-card relative z-30 grid gap-3 p-6 md:grid-cols-1">
        <div className="relative z-40">
          <input
            value={siswaSearch}
            onChange={(e) => {
              setSiswaSearch(e.target.value);
              setForm((prev) => ({ ...prev, siswa_id: "" }));
            }}
            placeholder="Cari siswa berdasarkan nama..."
            className="w-full rounded-xl border p-2"
          />
          {filteredSiswa.length > 0 && (
            <div className="absolute left-0 top-full z-[100] mt-2 max-h-56 w-full overflow-auto rounded-xl border bg-white dark:bg-slate-900 dark:border-slate-700 shadow-xl">
              {filteredSiswa.map((s: any) => (
                <button
                  key={s.id}
                  type="button"
                  onClick={() => {
                    setForm({ ...form, siswa_id: String(s.id) });
                    setSiswaSearch(s.nama_siswa);
                  }}
                  className="block w-full border-b dark:border-slate-700 px-3 py-2 text-left text-sm hover:bg-slate-50 dark:hover:bg-slate-800"
                >
                  {s.nama_siswa} - Kelas {s.kelas}
                </button>
              ))}
            </div>
          )}
          {selectedSiswa && (
            <div className="mt-2 text-sm text-emerald-700">
              Dipilih: {selectedSiswa.nama_siswa} (Kelas {selectedSiswa.kelas})
            </div>
          )}
        </div>
      </div>
      <div className="glass-card p-6">
        <div className="mb-2 text-sm font-medium text-slate-600 dark:text-slate-400">Task List Input Point</div>
        <div className="grid grid-cols-12 gap-2 text-sm font-medium text-slate-500 dark:text-slate-400">
          <div className="col-span-6">Nama Siswa</div>
          <div className="col-span-3 text-center">Point Positif</div>
          <div className="col-span-3 text-center">Point Negatif</div>
        </div>
        <div className="mt-2 grid grid-cols-12 gap-2">
          <input
            className="col-span-6 rounded-xl border bg-slate-50 dark:bg-slate-800 p-2"
            value={selectedSiswa ? `${selectedSiswa.nama_siswa} (Kelas ${selectedSiswa.kelas})` : "Belum pilih siswa"}
            readOnly
          />
          <input
            type="number"
            placeholder="0"
            className="col-span-3 rounded-xl border p-2 text-center"
            value={form.point_positif || ""}
            onChange={(e) => setForm({ ...form, point_positif: Number(e.target.value || 0), point_negatif: 0 })}
          />
          <input
            type="number"
            placeholder="0"
            className="col-span-3 rounded-xl border p-2 text-center"
            value={form.point_negatif || ""}
            onChange={(e) => setForm({ ...form, point_negatif: Number(e.target.value || 0), point_positif: 0 })}
          />
        </div>
        <div className="mt-4">
          <button onClick={submit} className="qism-glow-btn qism-glow-btn--sm">Simpan</button>
        </div>
      </div>
      <div className="glass-card flex items-center justify-end p-4">
        <select value={sort} onChange={(e) => setSort(e.target.value as any)} className="rounded-xl border p-2">
          <option value="positif">Sort Positif</option>
          <option value="negatif">Sort Negatif</option>
        </select>
      </div>
      <div className="glass-card overflow-auto p-4">
        {isLoading && <div className="animate-pulse text-slate-500 dark:text-slate-400">Memuat data point...</div>}
        {isError && <div className="text-rose-600">Gagal mengambil data point.</div>}
        <table className="min-w-full text-sm">
          <thead><tr><th>Tanggal</th><th className="text-left">Siswa</th><th>Kategori</th><th>+</th><th>-</th><th>Aksi</th></tr></thead>
          <tbody>
            {(points?.data || []).sort((a: any, b: any) => sort === "positif" ? (b.point_positif - a.point_positif) : (b.point_negatif - a.point_negatif)).map((p: any) => (
              <tr key={p.id}>
                <td>{p.tanggal}</td><td>{p.siswa?.nama_siswa}</td><td>{p.kategori}</td><td>{p.point_positif}</td><td>{p.point_negatif}</td>
                <td className="space-x-2">
                  <button onClick={() => { setEditId(p.id); setForm({ siswa_id: String(p.siswa_id), point_positif: p.point_positif, point_negatif: p.point_negatif }); setSiswaSearch(p.siswa?.nama_siswa || ""); }} className="qism-glow-btn qism-glow-btn--xs">Edit</button>
                  <button onClick={() => remove(p.id)} className="qism-glow-btn qism-glow-btn--xs">Hapus</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <div className="flex items-center justify-end gap-2">
        <button disabled={(points?.meta?.current_page || 1) <= 1} onClick={() => setPage((p) => Math.max(1, p - 1))} className="qism-glow-btn qism-glow-btn--xs">Prev</button>
        <span className="text-sm text-slate-600 dark:text-slate-400">Page {points?.meta?.current_page || 1} / {points?.meta?.last_page || 1}</span>
        <button disabled={(points?.meta?.current_page || 1) >= (points?.meta?.last_page || 1)} onClick={() => setPage((p) => p + 1)} className="qism-glow-btn qism-glow-btn--xs">Next</button>
      </div>
    </Shell>
  );
}

export default function PointPage() {
  return (
    <Suspense fallback={<div className="p-6">Memuat...</div>}>
      <PointPageContent />
    </Suspense>
  );
}
