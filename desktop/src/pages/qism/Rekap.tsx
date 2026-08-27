import { useCallback, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { api } from "../../lib/api";
import { Pagination } from "../admin/Siswa";
import type { Paged, RekapRow } from "../../lib/types";

export default function QismRekap() {
  const navigate = useNavigate();
  const [data, setData] = useState<Paged<RekapRow> | null>(null);
  const [page, setPage] = useState(1);

  const load = useCallback(() => {
    api
      .rekap({ page, perPage: 10 })
      .then(setData)
      .catch(() => {});
  }, [page]);

  useEffect(() => {
    load();
  }, [load]);

  return (
    <div className="space-y-5">
      <div className="glass-card flex items-center justify-between p-4">
        <h1 className="text-xl font-semibold">Rekap per Siswa</h1>
      </div>

      <div className="glass-card overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border text-left text-muted-foreground">
              <th className="px-4 py-2">Nama</th>
              <th className="px-4 py-2">Kelas</th>
              <th className="px-4 py-2 text-right">Positif</th>
              <th className="px-4 py-2 text-right">Negatif</th>
              <th className="px-4 py-2 text-right">Total</th>
              <th className="px-4 py-2 text-right">Jumlah</th>
            </tr>
          </thead>
          <tbody>
            {data?.data.map((r) => (
              <tr
                key={r.siswa_id}
                className="cursor-pointer border-b border-border/50 hover:bg-accent"
                onClick={() => navigate(`/qism/siswa/${r.siswa_id}`)}
              >
                <td className="px-4 py-2">{r.nama_siswa}</td>
                <td className="px-4 py-2">{r.kelas}</td>
                <td className="px-4 py-2 text-right text-green-500">{r.total_positif}</td>
                <td className="px-4 py-2 text-right text-red-500">{r.total_negatif}</td>
                <td className="px-4 py-2 text-right font-medium">{r.total}</td>
                <td className="px-4 py-2 text-right text-muted-foreground">{r.jumlah}</td>
              </tr>
            ))}
            {data?.data.length === 0 && (
              <tr>
                <td colSpan={6} className="px-4 py-6 text-center text-muted-foreground">
                  Belum ada data.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      <Pagination
        page={page}
        perPage={data?.per_page ?? 10}
        total={data?.total ?? 0}
        onPage={setPage}
      />
    </div>
  );
}
