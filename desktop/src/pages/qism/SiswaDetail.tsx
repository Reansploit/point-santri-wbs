import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { api } from "../../lib/api";
import { Button } from "../../components/ui/Button";
import type { SiswaRekap } from "../../lib/types";

export default function QismSiswaDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [data, setData] = useState<SiswaRekap | null>(null);

  useEffect(() => {
    if (id) {
      api
        .rekapSiswa(Number(id))
        .then(setData)
        .catch(() => setData(null));
    }
  }, [id]);

  if (!data) return <div className="text-muted-foreground">Memuat…</div>;

  return (
    <div className="space-y-5">
      <div className="glass-card flex items-center justify-between p-4">
        <h1 className="text-xl font-semibold">
          {data.siswa.nama_siswa} · Kelas {data.siswa.kelas}
        </h1>
        <Button variant="ghost" onClick={() => navigate("/qism/rekap")}>
          ‹ Rekap
        </Button>
      </div>

      <div className="grid grid-cols-3 gap-4">
        <div className="glass-card p-4">
          <div className="text-xl font-bold text-green-500">{data.total_positif}</div>
          <div className="text-xs text-muted-foreground">Positif</div>
        </div>
        <div className="glass-card p-4">
          <div className="text-xl font-bold text-red-500">{data.total_negatif}</div>
          <div className="text-xs text-muted-foreground">Negatif</div>
        </div>
        <div className="glass-card p-4">
          <div className="text-xl font-bold">{data.total}</div>
          <div className="text-xs text-muted-foreground">Total</div>
        </div>
      </div>

      <div className="glass-card overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border text-left text-muted-foreground">
              <th className="px-4 py-2">Tanggal</th>
              <th className="px-4 py-2">Kategori</th>
              <th className="px-4 py-2">Deskripsi</th>
              <th className="px-4 py-2 text-right">+</th>
              <th className="px-4 py-2 text-right">−</th>
            </tr>
          </thead>
          <tbody>
            {data.rows.map((p) => (
              <tr key={p.id} className="border-b border-border/50">
                <td className="px-4 py-2">{p.tanggal ?? "-"}</td>
                <td className="px-4 py-2">{p.kategori}</td>
                <td className="px-4 py-2">{p.deskripsi}</td>
                <td className="px-4 py-2 text-right text-green-500">{p.point_positif}</td>
                <td className="px-4 py-2 text-right text-red-500">{p.point_negatif}</td>
              </tr>
            ))}
            {data.rows.length === 0 && (
              <tr>
                <td colSpan={5} className="px-4 py-6 text-center text-muted-foreground">
                  Belum ada point.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
