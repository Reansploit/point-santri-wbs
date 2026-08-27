"use client";

import { LogOut, Moon, Sun } from "lucide-react";
import { usePathname, useRouter } from "next/navigation";
import { useTheme } from "@/components/shared/providers";

export function Shell({ title, children }: { title: string; children: React.ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const { theme, toggleTheme } = useTheme();
  const isQismRoute = pathname?.startsWith("/qism");

  const onLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("role");
    document.cookie = "token=; Max-Age=0; path=/";
    document.cookie = "role=; Max-Age=0; path=/";
    router.push("/");
  };

  return (
    <main className="p-4 md:p-8">
      <div className="mx-auto max-w-7xl space-y-6">
        <header className="glass-card flex items-center justify-between p-4">
          <h1 className="text-xl font-semibold">{title}</h1>
          <div className="flex items-center gap-3">
            <button
              onClick={toggleTheme}
              className="rounded-xl bg-slate-100 dark:bg-slate-800 px-3 py-2 text-slate-700 dark:text-slate-200 hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors"
              aria-label={theme === "light" ? "Switch to dark mode" : "Switch to light mode"}
            >
              {theme === "light" ? <Moon className="h-5 w-5" /> : <Sun className="h-5 w-5" />}
            </button>
            <button onClick={onLogout} className={isQismRoute ? "qism-glow-btn qism-glow-btn--sm" : "inline-flex items-center gap-2 rounded-xl bg-slate-900 px-4 py-2 text-white dark:bg-slate-100 dark:text-slate-900"}>
              <LogOut className="h-4 w-4" /> Logout
            </button>
          </div>
        </header>
        {children}
      </div>
    </main>
  );
}
