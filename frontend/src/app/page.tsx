import Link from "next/link";

export default function Home() {
  return (
    <main className="mx-auto grid min-h-screen max-w-4xl place-content-center gap-4 p-6">
      <div className="glass-card space-y-4 p-8 text-center">
        <h1 className="text-3xl font-semibold">Qism Natijah</h1>
        <p className="text-slate-600 dark:text-slate-400">gasss polll</p>
        <div className="grid gap-3">
          <Link href="/login" className="block rounded-xl bg-slate-900 dark:bg-slate-700 px-4 py-3 text-white">Login</Link>
          <Link href="/report-bug" className="block rounded-xl border border-slate-300 dark:border-slate-600 px-4 py-3 text-slate-800 dark:text-slate-200">Report Bug</Link>
        </div>
      </div>
    </main>
  );
}
