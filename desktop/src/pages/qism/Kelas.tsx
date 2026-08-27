import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { api } from "../../lib/api";
import { Button } from "../../components/ui/Button";
import type { KelasRekap } from "../../lib/types";

export default function QismKelas() {
  const { kelas } = useParams();
  const navigate = useNavigate();
  const [detail, setDetail] = useState<KelasRekap | null>(null);

  useEffect(() => {
    if (kelas) {
      api
        .kelasRekap(Number(kelas))
        .then(setDetail)
        .catch(() => setDetail(null));
    } else {
      setDetail(null);
    }
  }, [kelas]);

  if (!kelas) {
    return (
      <div className="space-y-5">
        <div className="glass-card flex items-center justify-between p-4">
          <h1 className="text-xl font-semibold">Per Kelas</h1>
        </div>
        <div className="grid grid-cols-2 gap-4 md:grid-cols-3">
          {[7, 8, 9, 10, 11, 12].map((k) => (
            <button
              key={k}
              onClick={() => navigate(`/qism/kelas/${k}`)}
              className="glass-card p-6 text-center text-lg font-semibold hover:bg-accent"
            >
              Kelas {k}
            </button>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-5">
      <div className="glass-card flex items-center justify-between p-4">
        <h1 className="text-xl font-semibold">Kelas {kelas}</h1>
        <Button variant="ghost" onClick={() => navigate("/qism/kelas")}>
          ‹ Semua Kelas
        </Button>
      </div>

      {detail && (
        <>
          <div className="grid grid-cols-3 gap-4">
            <div className="glass-card p-4">
              <div className="text-xl font-bold text-green-500">{detail.total_positif}</div>
              <div className="text-xs text-muted-foreground">Positif</div>
            </div>
            <div className="glass-card p-4">
              <div className="text-xl font-bold text-red-500">{detail.total_negatif}</div>
              <div className="text-xs text-muted-foreground">Negatif</div>
            </div>
            <div className="glass-card p-4">
              <div className="text-xl font-bold">{detail.total}</div>
              <div className="text-xs text-muted-foreground">Total</div>
            </div>
          </div>

          <div className="glass-card overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-border text-left text-muted-foreground">
                  <th className="px-4 py-2">Nama</th>
                  <th className="px-4 py-2 text-right">Positif</th>
                  <th className="px-4 py-2 text-right">Negatif</th>
                  <th className="px-4 py-2 text-right">Total</th>
                  <th className="px-4 py-2 text-right">Jumlah</th>
                </tr>
              </thead>
              <tbody>
                {detail.rows.map((r) => (
                  <tr key={r.siswa_id} className="border-b border-border/50">
                    <td className="px-4 py-2">{r.nama_siswa}</td>
                    <td className="px-4 py-2 text-right text-green-500">{r.total_positif}</td>
                    <td className="px-4 py-2 text-right text-red-500">{r.total_negatif}</td>
                    <td className="px-4 py-2 text-right font-medium">{r.total}</td>
                    <td className="px-4 py-2 text-right text-muted-foreground">{r.jumlah}</td>
                  </tr>
                ))}
                {detail.rows.length === 0 && (
                  <tr>
                    <td colSpan={5} className="px-4 py-6 text-center text-muted-foreground">
                      Belum ada data.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </>
      )}
    </div>
  );
}
