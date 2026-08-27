"use client";

import { Shell } from "@/components/layout/shell";
import { api } from "@/lib/api";
import { motion } from "framer-motion";
import Link from "next/link";
import { useQuery } from "@tanstack/react-query";
import { useState } from "react";

export default function QismDashboard() {
  const { data } = useQuery({ queryKey: ["statistik"], queryFn: async () => (await api.get("/qism/statistik")).data });
  const [angkatan, setAngkatan] = useState("7");
  return (
    <Shell title="Qism Natijah">
      <section className="grid gap-4 md:grid-cols-3">
        {[7, 8, 9, 10, 11, 12].map((kelas, i) => (
          <motion.div key={kelas} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.05 }} className="glass-card p-5">
            <h3 className="text-lg font-semibold">Kelas {kelas}</h3>
            <p className="text-sm text-slate-600 dark:text-slate-400 mb-3">Portal kelas dan rekap cepat.</p>
            <Link href={`/qism/kelas/${kelas}`} className="qism-glow-btn qism-glow-btn--sm">Lihat Kelas</Link>
          </motion.div>
        ))}
      </section>
      <section className="grid gap-4 md:grid-cols-4">
        <div className="glass-card p-4 md:col-span-4">Total Siswa: {data?.total_siswa ?? 0}</div>
      </section>
      <section className="glass-card flex gap-3 p-4">
        <Link href="/qism/point" className="qism-glow-btn">Tambah Point</Link>
        <Link href="/qism/export" className="qism-glow-btn">Export Excel</Link>
        <Link href="/qism/rekap" className="qism-glow-btn">Lihat Rekap</Link>
      </section>
      <section className="grid gap-4 md:grid-cols-2">
        <div className="glass-card p-4">
          <h3 className="mb-3 text-lg font-semibold text-rose-700 dark:text-rose-400">Top 10 Negatif Global</h3>
          <div className="space-y-2 text-sm">
            {(data?.top_global_negatif || []).map((s: any, i: number) => (
              <div key={s.id} className="flex items-center justify-between rounded-xl bg-rose-50 dark:bg-rose-950/40 px-3 py-2">
                <span>{i + 1}. {s.nama_siswa} (Kelas {s.kelas})</span>
                <span className="font-semibold">{s.total_negatif || 0}</span>
              </div>
            ))}
          </div>
        </div>
        <div className="glass-card p-4">
          <h3 className="mb-3 text-lg font-semibold text-emerald-700 dark:text-emerald-400">Top 10 Positif Global</h3>
          <div className="space-y-2 text-sm">
            {(data?.top_global_positif || []).map((s: any, i: number) => (
              <div key={s.id} className="flex items-center justify-between rounded-xl bg-emerald-50 dark:bg-emerald-950/40 px-3 py-2">
                <span>{i + 1}. {s.nama_siswa} (Kelas {s.kelas})</span>
                <span className="font-semibold">{s.total_positif || 0}</span>
              </div>
            ))}
          </div>
        </div>
      </section>
      <section className="glass-card p-4">
        <div className="mb-3 flex items-center justify-between">
          <h3 className="text-lg font-semibold">Top 10 Per Angkatan</h3>
          <select value={angkatan} onChange={(e) => setAngkatan(e.target.value)} className="rounded-xl border p-2">
            {[7, 8, 9, 10, 11, 12].map((k) => <option key={k} value={k}>{k}</option>)}
          </select>
        </div>
        <div className="grid gap-4 md:grid-cols-2">
          <div>
            <h4 className="mb-2 font-medium text-rose-700 dark:text-rose-400">Negatif Terbanyak (Angkatan {angkatan})</h4>
            <div className="space-y-2 text-sm">
              {(data?.top_per_angkatan_negatif?.[angkatan] || []).map((s: any, i: number) => (
                <div key={s.id} className="flex items-center justify-between rounded-xl bg-rose-50 dark:bg-rose-950/40 px-3 py-2">
                  <span>{i + 1}. {s.nama_siswa}</span>
                  <span className="font-semibold">{s.total_negatif || 0}</span>
                </div>
              ))}
            </div>
          </div>
          <div>
            <h4 className="mb-2 font-medium text-emerald-700 dark:text-emerald-400">Positif Terbanyak (Angkatan {angkatan})</h4>
            <div className="space-y-2 text-sm">
              {(data?.top_per_angkatan_positif?.[angkatan] || []).map((s: any, i: number) => (
                <div key={s.id} className="flex items-center justify-between rounded-xl bg-emerald-50 dark:bg-emerald-950/40 px-3 py-2">
                  <span>{i + 1}. {s.nama_siswa}</span>
                  <span className="font-semibold">{s.total_positif || 0}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>
    </Shell>
  );
}
