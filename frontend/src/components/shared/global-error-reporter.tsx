"use client";

import { buildBugPayload, reportBug } from "@/lib/reportBug";
import { useEffect } from "react";

export function GlobalErrorReporter() {
  useEffect(() => {
    const handleError = (event: ErrorEvent) => {
      const payload = buildBugPayload({
        title: `Unhandled Error: ${event.message || "Unknown"}`,
        description: event.error?.stack || event.message || "Unhandled frontend error",
        severity: "high",
        route: window.location.pathname,
        metadata: {
          eventType: "error",
          filename: event.filename,
          lineno: event.lineno,
          colno: event.colno,
        },
      });
      void reportBug(payload);
    };

    const handleRejection = (event: PromiseRejectionEvent) => {
      const reason = event.reason instanceof Error ? event.reason.stack || event.reason.message : String(event.reason);
      const payload = buildBugPayload({
        title: "Unhandled Promise Rejection",
        description: reason,
        severity: "high",
        route: window.location.pathname,
        metadata: {
          eventType: "unhandledrejection",
        },
      });
      void reportBug(payload);
    };

    window.addEventListener("error", handleError);
    window.addEventListener("unhandledrejection", handleRejection);

    return () => {
      window.removeEventListener("error", handleError);
      window.removeEventListener("unhandledrejection", handleRejection);
    };
  }, []);

  return null;
}
