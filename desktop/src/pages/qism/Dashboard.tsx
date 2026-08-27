import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { api } from "../../lib/api";
import { Button } from "../../components/ui/Button";
import { Select } from "../../components/ui/Select";
import type { Statistik, RekapRow } from "../../lib/types";

export default function QismDashboard() {
  const navigate = useNavigate();
  const [stat, setStat] = useState<Statistik | null>(null);
  const [angkatan, setAngkatan] = useState("7");

  useEffect(() => {
    api.statistik().then(setStat).catch(() => {});
  }, []);

  if (!stat) return <div className="text-muted-foreground">Memuat…</div>;

  const topNegatif = stat.top_per_angkatan_negatif[angkatan] || [];
  const topPositif = stat.top_per_angkatan_positif[angkatan] || [];

  return (
    <div className="space-y-6">
      <div className="glass-card flex items-center justify-between p-4">
        <h1 className="text-xl font-semibold">Qism Natijah</h1>
      </div>

      <section className="grid gap-4 md:grid-cols-3">
        {[7, 8, 9, 10, 11, 12].map((kelas) => (
          <div key={kelas} className="glass-card p-5">
            <h3 className="text-lg font-semibold">Kelas {kelas}</h3>
            <p className="mb-3 text-sm text-muted-foreground">
              Portal kelas dan rekap cepat.
            </p>
            <Button
              variant="glow"
              className="qism-glow-btn--sm"
              onClick={() => navigate(`/qism/kelas/${kelas}`)}
            >
              Lihat Kelas
            </Button>
          </div>
        ))}
      </section>

      <section className="glass-card p-4">Total Siswa: {stat.total_siswa}</section>

      <section className="glass-card flex flex-wrap gap-3 p-4">
        <Button variant="glow" onClick={() => navigate("/qism/point")}>
          Tambah Point
        </Button>
        <Button variant="glow" onClick={() => navigate("/qism/export")}>
          Export Excel
        </Button>
        <Button variant="glow" onClick={() => navigate("/qism/rekap")}>
          Lihat Rekap
        </Button>
      </section>

      <section className="grid gap-4 md:grid-cols-2">
        <TopList
          title="Top 10 Negatif Global"
          tone="rose"
          rows={stat.top_global_negatif}
          get={(s) => s.total_negatif}
        />
        <TopList
          title="Top 10 Positif Global"
          tone="emerald"
          rows={stat.top_global_positif}
          get={(s) => s.total_positif}
        />
      </section>

      <section className="glass-card p-4">
        <div className="mb-3 flex items-center justify-between">
          <h3 className="text-lg font-semibold">Top 10 Per Angkatan</h3>
          <Select value={angkatan} onChange={(e) => setAngkatan(e.target.value)}>
            {[7, 8, 9, 10, 11, 12].map((k) => (
              <option key={k} value={k}>
                Kelas {k}
              </option>
            ))}
          </Select>
        </div>
        <div className="grid gap-4 md:grid-cols-2">
          <div>
            <h4 className="mb-2 font-medium text-rose-700 dark:text-rose-400">
              Negatif Terbanyak (Angkatan {angkatan})
            </h4>
            <TopRows tone="rose" rows={topNegatif} get={(s) => s.total_negatif} />
          </div>
          <div>
            <h4 className="mb-2 font-medium text-emerald-700 dark:text-emerald-400">
              Positif Terbanyak (Angkatan {angkatan})
            </h4>
            <TopRows tone="emerald" rows={topPositif} get={(s) => s.total_positif} />
          </div>
        </div>
      </section>
    </div>
  );
}

function TopList({
  title,
  tone,
  rows,
  get,
}: {
  title: string;
  tone: "rose" | "emerald";
  rows: RekapRow[];
  get: (s: RekapRow) => number;
}) {
  return (
    <div className="glass-card p-4">
      <h3
        className={`mb-3 text-lg font-semibold ${
          tone === "rose"
            ? "text-rose-700 dark:text-rose-400"
            : "text-emerald-700 dark:text-emerald-400"
        }`}
      >
        {title}
      </h3>
      <TopRows tone={tone} rows={rows} get={get} />
    </div>
  );
}

function TopRows({
  tone,
  rows,
  get,
}: {
  tone: "rose" | "emerald";
  rows: RekapRow[];
  get: (s: RekapRow) => number;
}) {
  if (rows.length === 0)
    return <div className="text-sm text-muted-foreground">Belum ada data.</div>;
  return (
    <div className="space-y-2 text-sm">
      {rows.map((s, i) => (
        <div
          key={s.siswa_id}
          className={`flex items-center justify-between rounded-xl px-3 py-2 ${
            tone === "rose"
              ? "bg-rose-50 dark:bg-rose-950/40"
              : "bg-emerald-50 dark:bg-emerald-950/40"
          }`}
        >
          <span>
            {i + 1}. {s.nama_siswa} (Kelas {s.kelas})
          </span>
          <span className="font-semibold">{get(s) || 0}</span>
        </div>
      ))}
    </div>
  );
}
