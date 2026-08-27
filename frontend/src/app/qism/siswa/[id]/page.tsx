"use client";

import { Shell } from "@/components/layout/shell";
import { api } from "@/lib/api";
import { useQuery } from "@tanstack/react-query";
import { useParams } from "next/navigation";

export default function SiswaDetailPage() {
  const params = useParams<{ id: string }>();
  const { data } = useQuery({ queryKey: ["siswa-detail", params.id], queryFn: async () => (await api.get(`/qism/rekap/siswa/${params.id}`)).data });
  return (
    <Shell title="Detail Siswa">
      <div className="glass-card p-5">
        <h2 className="text-xl font-semibold">{data?.nama_siswa}</h2>
        <p>Kelas {data?.kelas}</p>
      </div>
    </Shell>
  );
}
