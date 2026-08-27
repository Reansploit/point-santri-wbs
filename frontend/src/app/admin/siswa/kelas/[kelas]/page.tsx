import { redirect } from "next/navigation";

export default async function AdminSiswaKelasPage({ params }: { params: Promise<{ kelas: string }> }) {
  const resolved = await params;
  redirect(`/admin/siswa?kelas=${resolved.kelas}`);
}
