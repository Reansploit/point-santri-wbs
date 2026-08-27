import { useEffect, useState } from "react";
import { api } from "../../lib/api";
import { Button } from "../../components/ui/Button";
import type { Statistik } from "../../lib/types";

export default function AdminDashboard() {
  const [stat, setStat] = useState<Statistik | null>(null);

  const load = () => api.statistik().then(setStat).catch(() => {});
  useEffect(() => {
    load();
  }, []);

  const clearPoints = async () => {
    if (!confirm("Hapus SELURUH data point? Tindakan tidak bisa dibatalkan.")) return;
    await api.clearPoints();
    alert("Data point dihapus.");
    load();
  };

  const clearSiswa = async () => {
    if (
      !confirm(
        "Hapus SELURUH data siswa beserta point-nya? Tindakan tidak bisa dibatalkan."
      )
    )
      return;
    await api.clearSiswa();
    alert("Data siswa dihapus.");
    load();
  };

  const cards = stat
    ? [
        { label: "Total Point Positif", value: stat.totals.total_positif },
        { label: "Total Point Negatif", value: stat.totals.total_negatif },
        { label: "Jumlah Siswa", value: stat.totals.jumlah_siswa },
        { label: "Jumlah Transaksi", value: stat.totals.jumlah_point },
      ]
    : [];

  return (
    <div className="space-y-6">
      <div className="glass-card flex items-center justify-between p-4">
        <h1 className="text-xl font-semibold">Dashboard Admin</h1>
      </div>

      <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
        {cards.map((c) => (
          <div key={c.label} className="glass-card p-4">
            <div className="text-2xl font-bold">{c.value}</div>
            <div className="text-sm text-muted-foreground">{c.label}</div>
          </div>
        ))}
      </div>

      <div className="glass-card space-y-3 p-5">
        <h2 className="font-semibold">Reset Data</h2>
        <p className="text-sm text-muted-foreground">
          Hapus seluruh data lokal. Gunakan hanya untuk memulai dari awal.
        </p>
        <div className="flex flex-wrap gap-3">
          <Button variant="destructive" onClick={clearPoints}>
            Hapus Semua Point
          </Button>
          <Button variant="destructive" onClick={clearSiswa}>
            Hapus Semua Siswa
          </Button>
        </div>
      </div>
    </div>
  );
}
