"use client";

import { Shell } from "@/components/layout/shell";
import { api } from "@/lib/api";
import { useQuery } from "@tanstack/react-query";
import Link from "next/link";
import { useMemo, useState } from "react";
import { useParams } from "next/navigation";

export default function QismKelasPage() {
  const params = useParams<{ kelas: string }>();
  const kelas = Number(params.kelas);
  const [search, setSearch] = useState("");
  const [sort, setSort] = useState<"positif" | "negatif">("negatif");
  const { data } = useQuery({
    queryKey: ["kelas", kelas],
    queryFn: async () => (await api.get(`/qism/kelas/${kelas}`)).data,
  });

  const filtered = useMemo(() => {
    const rows = (data || []).filter((d: any) => d.nama_siswa.toLowerCase().includes(search.toLowerCase()));
    return rows.sort((a: any, b: any) => sort === "positif" ? (b.total_positif || 0) - (a.total_positif || 0) : (b.total_negatif || 0) - (a.total_negatif || 0));
  }, [data, search, sort]);
  const topPositif = Math.max(...(filtered?.map((d: any) => d.total_positif || 0) || [0]));

  return (
    <Shell title={`Kelas ${kelas}`}>
      <div className="glass-card grid gap-3 p-4 md:grid-cols-2">
        <input value={search} onChange={(e) => setSearch(e.target.value)} placeholder="Cari siswa..." className="rounded-xl border p-2" />
        <select value={sort} onChange={(e) => setSort(e.target.value as any)} className="rounded-xl border p-2"><option value="negatif">Sort Negatif</option><option value="positif">Sort Positif</option></select>
      </div>
      <div className="glass-card overflow-auto p-4">
        <table className="min-w-full text-sm">
          <thead><tr><th className="text-left">Nama</th><th>Positif</th><th>Negatif</th><th></th></tr></thead>
          <tbody>
            {filtered?.map((item: any) => {
              const red = (item.total_negatif || 0) >= 50;
              const green = !red && (item.total_positif || 0) === topPositif && topPositif > 0;
              return (
                <tr key={item.id} className={red ? "bg-rose-50 dark:bg-rose-950/40" : green ? "bg-emerald-50 dark:bg-emerald-950/40" : ""}>
                  <td className={red ? "text-rose-700 dark:text-rose-400 font-semibold" : green ? "text-emerald-700 dark:text-emerald-400 font-semibold" : ""}>{item.nama_siswa}</td>
                  <td><span className="rounded-full bg-emerald-100 dark:bg-emerald-900/50 px-2 py-1 text-emerald-700 dark:text-emerald-300">{item.total_positif || 0}</span></td>
                  <td>
                    <div className="flex items-center gap-2">
                      <span className="rounded-full bg-rose-100 dark:bg-rose-900/50 px-2 py-1 text-rose-700 dark:text-rose-300">{item.total_negatif || 0}</span>
                      <Link href={`/qism/point?siswa_id=${item.id}`} className="qism-glow-btn qism-glow-btn--xs">Edit</Link>
                    </div>
                  </td>
                  <td><Link href={`/qism/siswa/${item.id}`} className="qism-glow-btn qism-glow-btn--xs">Detail</Link></td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </Shell>
  );
}
