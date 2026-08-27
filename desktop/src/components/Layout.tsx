import { NavLink, Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../lib/auth";
import { Button } from "./ui/Button";

const navBase = "block rounded-md px-3 py-2 text-sm";

export default function Layout() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const isAdmin = user?.role === "admin";

  const links = [
    { to: "/dashboard", label: "Dashboard" },
    ...(isAdmin
      ? [
          { to: "/admin/siswa", label: "Kelola Siswa" },
          { to: "/admin/akun", label: "Kelola Akun" },
        ]
      : []),
    { to: "/qism/point", label: "Input Point" },
    { to: "/qism/rekap", label: "Rekap" },
    { to: "/qism/kelas", label: "Per Kelas" },
    { to: "/qism/export", label: "Export Excel" },
  ];

  const onLogout = async () => {
    await logout();
    navigate("/login");
  };

  return (
    <div className="flex min-h-screen">
      <aside className="w-60 shrink-0 border-r border-border bg-card/40 p-4">
        <div className="mb-6 px-2 text-lg font-bold">Qism Natijah</div>
        <nav className="space-y-1">
          {links.map((l) => (
            <NavLink
              key={l.to}
              to={l.to}
              className={({ isActive }) =>
                `${navBase} ${
                  isActive
                    ? "bg-primary text-primary-foreground"
                    : "hover:bg-accent"
                }`
              }
            >
              {l.label}
            </NavLink>
          ))}
        </nav>
      </aside>
      <div className="flex flex-1 flex-col">
        <header className="flex items-center justify-between border-b border-border px-6 py-3">
          <div className="text-sm text-muted-foreground">
            {user?.username} · {user?.role === "admin" ? "Admin" : "Qism"}
          </div>
          <Button variant="ghost" onClick={onLogout}>
            Keluar
          </Button>
        </header>
        <main className="flex-1 overflow-auto p-6">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
