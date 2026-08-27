import { useCallback, useEffect, useState, type FormEvent } from "react";
import { api } from "../../lib/api";
import { Button } from "../../components/ui/Button";
import { Input } from "../../components/ui/Input";
import { Select } from "../../components/ui/Select";
import { Pagination } from "../admin/Siswa";
import type { Paged, Point, Siswa } from "../../lib/types";

export default function QismPoint() {
  const [siswa, setSiswa] = useState<Siswa[]>([]);
  const [data, setData] = useState<Paged<Point> | null>(null);
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");

  const [siswaId, setSiswaId] = useState<number | "">("");
  const [tanggal, setTanggal] = useState("");
  const [deskripsi, setDeskripsi] = useState("");
  const [kategori, setKategori] = useState("Umum");
  const [pos, setPos] = useState("");
  const [neg, setNeg] = useState("");
  const [editId, setEditId] = useState<number | null>(null);
  const [err, setErr] = useState("");

  useEffect(() => {
    api
      .listSiswa({ perPage: 1000 })
      .then((r) => setSiswa(r.data))
      .catch(() => {});
  }, []);

  const load = useCallback(() => {
    setErr("");
    api
      .listPoints({ search: search || undefined, page, perPage: 10 })
      .then(setData)
      .catch((e) => setErr(String(e)));
  }, [search, page]);

  useEffect(() => {
    load();
  }, [load]);

  const resetForm = () => {
    setSiswaId("");
    setTanggal("");
    setDeskripsi("");
    setKategori("Umum");
    setPos("");
    setNeg("");
    setEditId(null);
  };

  const onSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setErr("");
    if (siswaId === "") {
      setErr("Pilih siswa terlebih dahulu.");
      return;
    }
    try {
      const payload = {
        siswaId: Number(siswaId),
        tanggal: tanggal || undefined,
        deskripsi: deskripsi || undefined,
        kategori: kategori || undefined,
        pointPositif: pos ? Number(pos) : undefined,
        pointNegatif: neg ? Number(neg) : undefined,
      };
      if (editId) {
        await api.updatePoint({ id: editId, ...payload });
      } else {
        await api.createPoint(payload);
      }
      resetForm();
      load();
    } catch (e) {
      setErr(String(e));
    }
  };

  const onEdit = (p: Point) => {
    setEditId(p.id);
    setSiswaId(p.siswa_id);
    setTanggal(p.tanggal ?? "");
    setDeskripsi(p.deskripsi ?? "");
    setKategori(p.kategori ?? "Umum");
    setPos(String(p.point_positif));
    setNeg(String(p.point_negatif));
  };

  const onDelete = async (id: number) => {
    if (!confirm("Hapus point ini?")) return;
    await api.deletePoint(id);
    load();
  };

  return (
    <div className="space-y-5">
      <div className="glass-card flex items-center justify-between p-4">
        <h1 className="text-xl font-semibold">Input Point</h1>
      </div>
      {err && <div className="text-sm text-destructive">{err}</div>}

      <form onSubmit={onSubmit} className="glass-card space-y-3 p-4">
        <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
          <div>
            <label className="mb-1 block text-xs text-muted-foreground">Siswa</label>
            <Select
              value={siswaId}
              onChange={(e) => setSiswaId(e.target.value ? Number(e.target.value) : "")}
            >
              <option value="">— pilih —</option>
              {siswa.map((s) => (
                <option key={s.id} value={s.id}>
                  {s.nama_siswa} (Kelas {s.kelas})
                </option>
              ))}
            </Select>
          </div>
          <div>
            <label className="mb-1 block text-xs text-muted-foreground">Tanggal</label>
            <Input type="date" value={tanggal} onChange={(e) => setTanggal(e.target.value)} />
          </div>
          <div>
            <label className="mb-1 block text-xs text-muted-foreground">Kategori</label>
            <Input value={kategori} onChange={(e) => setKategori(e.target.value)} placeholder="Umum" />
          </div>
          <div>
            <label className="mb-1 block text-xs text-muted-foreground">Deskripsi</label>
            <Input value={deskripsi} onChange={(e) => setDeskripsi(e.target.value)} />
          </div>
          <div>
            <label className="mb-1 block text-xs text-muted-foreground">Point Positif</label>
            <Input type="number" value={pos} onChange={(e) => setPos(e.target.value)} />
          </div>
          <div>
            <label className="mb-1 block text-xs text-muted-foreground">Point Negatif</label>
            <Input type="number" value={neg} onChange={(e) => setNeg(e.target.value)} />
          </div>
        </div>
        <div className="flex gap-3">
          <Button variant="glow" type="submit">
            {editId ? "Simpan" : "Tambah Point"}
          </Button>
          {editId && (
            <Button type="button" variant="ghost" onClick={resetForm}>
              Batal
            </Button>
          )}
        </div>
      </form>

      <div className="flex flex-wrap items-end gap-3">
        <div className="flex-1 min-w-[200px]">
          <Input
            placeholder="Cari nama / deskripsi…"
            value={search}
            onChange={(e) => {
              setSearch(e.target.value);
              setPage(1);
            }}
          />
        </div>
      </div>

      <div className="glass-card overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border text-left text-muted-foreground">
              <th className="px-4 py-2">Tanggal</th>
              <th className="px-4 py-2">Siswa</th>
              <th className="px-4 py-2">Kategori</th>
              <th className="px-4 py-2">Deskripsi</th>
              <th className="px-4 py-2 text-right">+</th>
              <th className="px-4 py-2 text-right">−</th>
              <th className="px-4 py-2 text-right">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {data?.data.map((p) => (
              <tr key={p.id} className="border-b border-border/50">
                <td className="px-4 py-2">{p.tanggal ?? "-"}</td>
                <td className="px-4 py-2">{p.siswa_nama}</td>
                <td className="px-4 py-2">{p.kategori}</td>
                <td className="px-4 py-2">{p.deskripsi}</td>
                <td className="px-4 py-2 text-right text-green-500">{p.point_positif}</td>
                <td className="px-4 py-2 text-right text-red-500">{p.point_negatif}</td>
                <td className="px-4 py-2 text-right">
                  <button
                    className="rounded-lg bg-amber-100 px-2 py-1 text-xs font-medium text-amber-700 hover:bg-amber-200 dark:bg-amber-900/50 dark:text-amber-200"
                    onClick={() => onEdit(p)}
                  >
                    Edit
                  </button>
                  <button
                    className="rounded-lg bg-rose-100 px-2 py-1 text-xs font-medium text-rose-700 hover:bg-rose-200 dark:bg-rose-900/50 dark:text-rose-200"
                    onClick={() => onDelete(p.id)}
                  >
                    Hapus
                  </button>
                </td>
              </tr>
            ))}
            {data?.data.length === 0 && (
              <tr>
                <td colSpan={7} className="px-4 py-6 text-center text-muted-foreground">
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
