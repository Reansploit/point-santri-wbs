import { useState } from "react";
import { api } from "../../lib/api";
import { Button } from "../../components/ui/Button";
import { Select } from "../../components/ui/Select";

export default function QismExport() {
  const [kelas, setKelas] = useState("");
  const [msg, setMsg] = useState("");
  const [busy, setBusy] = useState(false);

  const onExport = async () => {
    setBusy(true);
    setMsg("");
    try {
      const path = await api.exportExcel(kelas ? Number(kelas) : undefined);
      setMsg(`Tersimpan: ${path}`);
    } catch (e) {
      setMsg(String(e));
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="space-y-5">
      <div className="glass-card flex items-center justify-between p-4">
        <h1 className="text-xl font-semibold">Export Excel</h1>
      </div>

      <div className="glass-card max-w-md space-y-4 p-5">
        <p className="text-sm text-muted-foreground">
          Ekspor rekap point ke file .xlsx. Pilih kelas untuk membatasi, atau
          kosongkan untuk semua kelas.
        </p>
        <div className="w-40">
          <label className="mb-1 block text-xs text-muted-foreground">Kelas</label>
          <Select value={kelas} onChange={(e) => setKelas(e.target.value)}>
            <option value="">Semua kelas</option>
            {[7, 8, 9, 10, 11, 12].map((k) => (
              <option key={k} value={k}>
                Kelas {k}
              </option>
            ))}
          </Select>
        </div>
        <Button variant="glow" onClick={onExport} disabled={busy}>
          {busy ? "Menyimpan…" : "Export Excel"}
        </Button>
        {msg && <div className="text-sm break-all">{msg}</div>}
      </div>
    </div>
  );
}
