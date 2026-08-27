import { useCallback, useEffect, useState, type FormEvent } from "react";
import { api } from "../../lib/api";
import { Button } from "../../components/ui/Button";
import { Input } from "../../components/ui/Input";
import { Select } from "../../components/ui/Select";
import type { Paged, Siswa } from "../../lib/types";

export default function AdminSiswa() {
  const [data, setData] = useState<Paged<Siswa> | null>(null);
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [kelasFilter, setKelasFilter] = useState("");

  const [nama, setNama] = useState("");
  const [kelas, setKelas] = useState(7);
  const [editId, setEditId] = useState<number | null>(null);
  const [err, setErr] = useState("");

  const [importOpen, setImportOpen] = useState(false);
  const [importText, setImportText] = useState("");
  const [importKelas, setImportKelas] = useState(7);
  const [importMsg, setImportMsg] = useState("");

  const load = useCallback(() => {
    setErr("");
    api
      .listSiswa({
        search: search || undefined,
        kelas: kelasFilter ? Number(kelasFilter) : undefined,
        page,
        perPage: 10,
      })
      .then(setData)
      .catch((e) => setErr(String(e)));
  }, [search, kelasFilter, page]);

  useEffect(() => {
    load();
  }, [load]);

  const resetForm = () => {
    setNama("");
    setKelas(7);
    setEditId(null);
  };

  const onSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setErr("");
    try {
      if (editId) {
        await api.updateSiswa(editId, nama, kelas);
      } else {
        await api.createSiswa(nama, kelas);
      }
      resetForm();
      load();
    } catch (e) {
      setErr(String(e));
    }
  };

  const onEdit = (s: Siswa) => {
    setEditId(s.id);
    setNama(s.nama_siswa);
    setKelas(s.kelas);
  };

  const onDelete = async (id: number) => {
    if (!confirm("Hapus siswa ini? Point-nya ikut terhapus.")) return;
    await api.deleteSiswa(id);
    load();
  };

  const onImport = async (e: FormEvent) => {
    e.preventDefault();
    setImportMsg("");
    try {
      const r = await api.importSiswa(importText, importKelas);
      setImportMsg(`Berhasil: ${r.inserted}, dilewati: ${r.skipped}`);
      setImportText("");
      load();
    } catch (e) {
      setImportMsg(String(e));
    }
  };

  return (
    <div className="space-y-5">
      <div className="glass-card flex items-center justify-between p-4">
        <h1 className="text-xl font-semibold">Kelola Siswa</h1>
      </div>
      {err && <div className="text-sm text-destructive">{err}</div>}

      <form
        onSubmit={onSubmit}
        className="glass-card flex flex-wrap items-end gap-3 p-4"
      >
        <div className="flex-1 min-w-[200px]">
          <label className="mb-1 block text-xs text-muted-foreground">Nama Siswa</label>
          <Input value={nama} onChange={(e) => setNama(e.target.value)} placeholder="Nama" />
        </div>
        <div className="w-28">
          <label className="mb-1 block text-xs text-muted-foreground">Kelas</label>
          <Select value={kelas} onChange={(e) => setKelas(Number(e.target.value))}>
            {[7, 8, 9, 10, 11, 12].map((k) => (
              <option key={k} value={k}>
                {k}
              </option>
            ))}
          </Select>
        </div>
        <Button variant="glow" type="submit">
          {editId ? "Simpan" : "Tambah"}
        </Button>
        {editId && (
          <Button type="button" variant="ghost" onClick={resetForm}>
            Batal
          </Button>
        )}
      </form>

      <div className="flex flex-wrap items-end gap-3">
        <div className="flex-1 min-w-[200px]">
          <Input
            placeholder="Cari nama…"
            value={search}
            onChange={(e) => {
              setSearch(e.target.value);
              setPage(1);
            }}
          />
        </div>
        <div className="w-28">
          <Select
            value={kelasFilter}
            onChange={(e) => {
              setKelasFilter(e.target.value);
              setPage(1);
            }}
          >
            <option value="">Semua kelas</option>
            {[7, 8, 9, 10, 11, 12].map((k) => (
              <option key={k} value={k}>
                Kelas {k}
              </option>
            ))}
          </Select>
        </div>
        <Button
          type="button"
          variant="ghost"
          onClick={() => setImportOpen((v) => !v)}
        >
          Import Teks
        </Button>
      </div>

      {importOpen && (
        <form onSubmit={onImport} className="glass-card space-y-3 p-4">
          <p className="text-sm text-muted-foreground">
            Satu nama per baris. Semua akan masuk ke kelas di bawah.
          </p>
          <textarea
            className="w-full rounded-md border border-border bg-transparent px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-ring"
            rows={6}
            value={importText}
            onChange={(e) => setImportText(e.target.value)}
            placeholder={"Ahmad\nBudi\nCici"}
          />
          <div className="flex items-end gap-3">
            <div className="w-28">
              <label className="mb-1 block text-xs text-muted-foreground">Kelas</label>
              <Select
                value={importKelas}
                onChange={(e) => setImportKelas(Number(e.target.value))}
              >
                {[7, 8, 9, 10, 11, 12].map((k) => (
                  <option key={k} value={k}>
                    {k}
                  </option>
                ))}
              </Select>
            </div>
            <Button variant="glow" type="submit">
              Import
            </Button>
          </div>
          {importMsg && <div className="text-sm">{importMsg}</div>}
        </form>
      )}

      <div className="glass-card overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border text-left text-muted-foreground">
              <th className="px-4 py-2">Nama</th>
              <th className="px-4 py-2">Kelas</th>
              <th className="px-4 py-2 text-right">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {data?.data.map((s) => (
              <tr key={s.id} className="border-b border-border/50">
                <td className="px-4 py-2">{s.nama_siswa}</td>
                <td className="px-4 py-2">{s.kelas}</td>
                <td className="px-4 py-2 text-right">
                  <button
                    className="rounded-lg bg-amber-100 px-2 py-1 text-xs font-medium text-amber-700 hover:bg-amber-200 dark:bg-amber-900/50 dark:text-amber-200"
                    onClick={() => onEdit(s)}
                  >
                    Edit
                  </button>
                  <button
                    className="rounded-lg bg-rose-100 px-2 py-1 text-xs font-medium text-rose-700 hover:bg-rose-200 dark:bg-rose-900/50 dark:text-rose-200"
                    onClick={() => onDelete(s.id)}
                  >
                    Hapus
                  </button>
                </td>
              </tr>
            ))}
            {data?.data.length === 0 && (
              <tr>
                <td colSpan={3} className="px-4 py-6 text-center text-muted-foreground">
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

export function Pagination({
  page,
  perPage,
  total,
  onPage,
}: {
  page: number;
  perPage: number;
  total: number;
  onPage: (p: number) => void;
}) {
  const pages = Math.ceil(total / perPage);
  if (pages <= 1) return null;
  return (
    <div className="flex items-center justify-center gap-2 text-sm">
      <Button variant="ghost" disabled={page <= 1} onClick={() => onPage(page - 1)}>
        ‹
      </Button>
      <span className="text-muted-foreground">
        {page} / {pages}
      </span>
      <Button variant="ghost" disabled={page >= pages} onClick={() => onPage(page + 1)}>
        ›
      </Button>
    </div>
  );
}
