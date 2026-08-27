import { useCallback, useEffect, useState, type FormEvent } from "react";
import { api } from "../../lib/api";
import { Button } from "../../components/ui/Button";
import { Input } from "../../components/ui/Input";
import { Select } from "../../components/ui/Select";
import { Pagination } from "./Siswa";
import type { Paged, User } from "../../lib/types";

export default function AdminAkun() {
  const [data, setData] = useState<Paged<User> | null>(null);
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");

  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState("qism");
  const [editId, setEditId] = useState<number | null>(null);
  const [err, setErr] = useState("");

  const [pwId, setPwId] = useState<number | null>(null);
  const [pwVal, setPwVal] = useState("");

  const load = useCallback(() => {
    setErr("");
    api
      .listUsers({ search: search || undefined, page, perPage: 10 })
      .then(setData)
      .catch((e) => setErr(String(e)));
  }, [search, page]);

  useEffect(() => {
    load();
  }, [load]);

  const resetForm = () => {
    setUsername("");
    setPassword("");
    setRole("qism");
    setEditId(null);
  };

  const onSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setErr("");
    try {
      if (editId) {
        await api.updateUser(editId, username, role);
      } else {
        await api.createUser(username, password, role);
      }
      resetForm();
      load();
    } catch (e) {
      setErr(String(e));
    }
  };

  const onEdit = (u: User) => {
    setEditId(u.id);
    setUsername(u.username);
    setRole(u.role);
    setPassword("");
  };

  const onDelete = async (id: number) => {
    if (!confirm("Hapus akun ini?")) return;
    try {
      await api.deleteUser(id);
      load();
    } catch (e) {
      alert(String(e));
    }
  };

  const onSavePw = async (id: number) => {
    if (!pwVal) return;
    await api.updateUserPassword(id, pwVal);
    setPwId(null);
    setPwVal("");
    alert("Password diperbarui.");
  };

  return (
    <div className="space-y-5">
      <div className="glass-card flex items-center justify-between p-4">
        <h1 className="text-xl font-semibold">Kelola Akun</h1>
      </div>
      {err && <div className="text-sm text-destructive">{err}</div>}

      <form onSubmit={onSubmit} className="glass-card flex flex-wrap items-end gap-3 p-4">
        <div className="flex-1 min-w-[160px]">
          <label className="mb-1 block text-xs text-muted-foreground">Username</label>
          <Input value={username} onChange={(e) => setUsername(e.target.value)} />
        </div>
        <div className="min-w-[160px]">
          <label className="mb-1 block text-xs text-muted-foreground">
            Password {editId ? "(kosongkan = tidak ubah)" : ""}
          </label>
          <Input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder={editId ? "••••••" : ""}
          />
        </div>
        <div className="w-32">
          <label className="mb-1 block text-xs text-muted-foreground">Role</label>
          <Select value={role} onChange={(e) => setRole(e.target.value)}>
            <option value="qism">qism</option>
            <option value="admin">admin</option>
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
            placeholder="Cari username…"
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
              <th className="px-4 py-2">Username</th>
              <th className="px-4 py-2">Role</th>
              <th className="px-4 py-2 text-right">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {data?.data.map((u) => (
              <tr key={u.id} className="border-b border-border/50">
                <td className="px-4 py-2">{u.username}</td>
                <td className="px-4 py-2">{u.role}</td>
                <td className="px-4 py-2 text-right">
                  <button
                    className="rounded-lg bg-amber-100 px-2 py-1 text-xs font-medium text-amber-700 hover:bg-amber-200 dark:bg-amber-900/50 dark:text-amber-200"
                    onClick={() => onEdit(u)}
                  >
                    Edit
                  </button>
                  <button
                    className="rounded-lg bg-slate-100 px-2 py-1 text-xs font-medium text-slate-700 hover:bg-slate-200 dark:bg-slate-800 dark:text-slate-200"
                    onClick={() => {
                      setPwId(u.id);
                      setPwVal("");
                    }}
                  >
                    PW
                  </button>
                  <button
                    className="rounded-lg bg-rose-100 px-2 py-1 text-xs font-medium text-rose-700 hover:bg-rose-200 dark:bg-rose-900/50 dark:text-rose-200"
                    onClick={() => onDelete(u.id)}
                  >
                    Hapus
                  </button>
                  {pwId === u.id && (
                    <div className="mt-2 flex items-center justify-end gap-2">
                      <Input
                        type="password"
                        className="w-32"
                        value={pwVal}
                        onChange={(e) => setPwVal(e.target.value)}
                        placeholder="Password baru"
                      />
                      <Button
                        variant="glow"
                        className="qism-glow-btn--sm"
                        onClick={() => onSavePw(u.id)}
                      >
                        OK
                      </Button>
                    </div>
                  )}
                </td>
              </tr>
            ))}
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
