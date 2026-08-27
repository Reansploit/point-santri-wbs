"use client";

import { Shell } from "@/components/layout/shell";
import { api } from "@/lib/api";
import { useQuery } from "@tanstack/react-query";
import { Bar, BarChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";

export default function StatistikPage() {
  const { data } = useQuery({ queryKey: ["statistik-page"], queryFn: async () => (await api.get("/qism/statistik")).data });
  return (
    <Shell title="Statistik">
      <div className="glass-card h-[360px] p-4">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data?.per_kelas || []}>
            <XAxis dataKey="kelas" />
            <YAxis />
            <Tooltip />
            <Bar dataKey="total_positif" fill="#10b981" radius={[8, 8, 0, 0]} />
            <Bar dataKey="total_negatif" fill="#ef4444" radius={[8, 8, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </Shell>
  );
}

