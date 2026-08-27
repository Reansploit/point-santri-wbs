"use client";

import { Toast } from "@/components/shared/toast";
import { buildBugPayload, reportBug, type BugSeverity } from "@/lib/reportBug";
import { zodResolver } from "@hookform/resolvers/zod";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { z } from "zod";

const schema = z.object({
  title: z.string().trim().min(3, "Title is required"),
  description: z.string().trim().min(10, "Description is required"),
  severity: z.enum(["low", "medium", "high", "critical"]).default("medium"),
  reporter: z.string().trim().optional(),
  screenshot: z.union([z.literal(""), z.string().url("Must be a valid URL")]),
});

type FormValues = z.infer<typeof schema>;

export default function ReportBugPage() {
  const pathname = usePathname();
  const [toast, setToast] = useState<{ message: string; type: "success" | "error" }>({ message: "", type: "success" });
  const [resultId, setResultId] = useState<string | null>(null);

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { severity: "medium", reporter: "", screenshot: "" },
  });

  const onSubmit = handleSubmit(async (values) => {
    setResultId(null);
    setToast({ message: "", type: "success" });

    const payload = buildBugPayload({
      title: values.title,
      description: values.description,
      severity: values.severity as BugSeverity,
      reporter: values.reporter || undefined,
      screenshot: values.screenshot || undefined,
      route: pathname,
    });

    const result = await reportBug(payload);
    if (!result.ok) {
      setToast({ message: result.error || "Failed to submit report", type: "error" });
      return;
    }

    setResultId(result.id || null);
    setToast({ message: "Bug report submitted successfully", type: "success" });
    reset({ severity: "medium", reporter: "", screenshot: "", title: "", description: "" });
  });

  return (
    <main className="mx-auto max-w-3xl p-6 md:p-10">
      <Toast message={toast.message} type={toast.type} />
      <div className="glass-card space-y-6 p-6 md:p-8">
        <div className="space-y-2">
          <h1 className="text-2xl font-semibold">Report Bug</h1>
          <p className="text-sm text-slate-600 dark:text-slate-400">Submit an issue directly to DevHub.</p>
        </div>

        <form onSubmit={onSubmit} className="space-y-4" noValidate>
          <div>
            <label htmlFor="title" className="mb-1 block text-sm font-medium">Title</label>
            <input id="title" {...register("title")} className="w-full rounded-xl border border-slate-300 dark:border-slate-700 px-3 py-2" aria-invalid={Boolean(errors.title)} />
            {errors.title && <p className="mt-1 text-sm text-rose-600 dark:text-rose-400">{errors.title.message}</p>}
          </div>

          <div>
            <label htmlFor="description" className="mb-1 block text-sm font-medium">Description</label>
            <textarea id="description" {...register("description")} rows={6} className="w-full rounded-xl border border-slate-300 dark:border-slate-700 px-3 py-2" aria-invalid={Boolean(errors.description)} />
            {errors.description && <p className="mt-1 text-sm text-rose-600 dark:text-rose-400">{errors.description.message}</p>}
          </div>

          <div>
            <label htmlFor="severity" className="mb-1 block text-sm font-medium">Severity</label>
            <select id="severity" {...register("severity")} className="w-full rounded-xl border border-slate-300 dark:border-slate-700 px-3 py-2">
              <option value="low">Low</option>
              <option value="medium">Medium</option>
              <option value="high">High</option>
              <option value="critical">Critical</option>
            </select>
          </div>

          <div>
            <label htmlFor="reporter" className="mb-1 block text-sm font-medium">Reporter (optional)</label>
            <input id="reporter" {...register("reporter")} className="w-full rounded-xl border border-slate-300 dark:border-slate-700 px-3 py-2" />
          </div>

          <div>
            <label htmlFor="screenshot" className="mb-1 block text-sm font-medium">Screenshot URL (optional)</label>
            <input id="screenshot" {...register("screenshot")} className="w-full rounded-xl border border-slate-300 dark:border-slate-700 px-3 py-2" />
            {errors.screenshot && <p className="mt-1 text-sm text-rose-600 dark:text-rose-400">{errors.screenshot.message}</p>}
          </div>

          <button disabled={isSubmitting} className="rounded-xl bg-slate-900 dark:bg-slate-700 px-4 py-2 text-white disabled:opacity-50">
            {isSubmitting ? "Submitting..." : "Submit Bug"}
          </button>
        </form>

        {resultId && <p className="text-sm text-emerald-700 dark:text-emerald-400">Bug ID: {resultId}</p>}

        <Link href="/" className="inline-block text-sm text-slate-700 dark:text-slate-300 underline">Back to home</Link>
      </div>
    </main>
  );
}
