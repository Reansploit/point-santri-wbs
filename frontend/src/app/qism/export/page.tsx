"use client";

import { Shell } from "@/components/layout/shell";
import { api } from "@/lib/api";
import { useState } from "react";

export default function ExportPage() {
  const [kelas, setKelas] = useState("7");

  const download = async (url: string, filename: string) => {
    const response = await api.get(url, { responseType: "blob" });
    const blob = new Blob([response.data]);
    const downloadUrl = window.URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = downloadUrl;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    a.remove();
    window.URL.revokeObjectURL(downloadUrl);
  };

  return (
    <Shell title="Export Excel">
      <div className="grid gap-3 md:grid-cols-2">
        <button onClick={() => download("/qism/export/all", "point-semua.xlsx")} className="qism-glow-btn qism-glow-btn--block qism-glow-btn--left">Export Semua Data</button>
        <div className="glass-card space-y-3 p-4">
          <div className="text-sm text-slate-600 dark:text-slate-400">Export Per Kelas</div>
          <div className="flex items-center gap-2">
            <select value={kelas} onChange={(e) => setKelas(e.target.value)} className="rounded-xl border p-2">
              {[7, 8, 9, 10, 11, 12].map((k) => <option key={k} value={k}>Kelas {k}</option>)}
            </select>
            <button onClick={() => download(`/qism/export/kelas/${kelas}`, `point-kelas-${kelas}.xlsx`)} className="qism-glow-btn qism-glow-btn--sm">Download</button>
          </div>
        </div>
      </div>
    </Shell>
  );
}
