"use client";

import { Shell } from "@/components/layout/shell";
import { api } from "@/lib/api";
import { useQuery } from "@tanstack/react-query";

export default function RekapPage() {
  const { data } = useQuery({ queryKey: ["rekap"], queryFn: async () => (await api.get("/qism/rekap")).data });
  return (
    <Shell title="Rekap Siswa">
      <div className="glass-card overflow-auto p-4">
        <table className="min-w-full text-sm">
          <thead><tr><th className="text-left">Nama</th><th>Kelas</th><th>Positif</th><th>Negatif</th><th>Input</th></tr></thead>
          <tbody>{data?.map((s: any) => <tr key={s.id}><td>{s.nama_siswa}</td><td>{s.kelas}</td><td>{s.total_positif || 0}</td><td>{s.total_negatif || 0}</td><td>{s.total_input || 0}</td></tr>)}</tbody>
        </table>
      </div>
    </Shell>
  );
}

