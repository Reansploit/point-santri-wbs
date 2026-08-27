export type BugSeverity = "low" | "medium" | "high" | "critical";

export interface BugMetadata {
  userAgent?: string;
  appVersion?: string;
  timestamp?: string;
  viewport?: {
    width: number;
    height: number;
  };
  [key: string]: unknown;
}

export interface BugPayload {
  title: string;
  description: string;
  sourceApp: string;
  severity?: BugSeverity;
  reporter?: string;
  route?: string;
  screenshot?: string;
  metadata?: BugMetadata;
}

export interface BuildBugPayloadInput extends Omit<BugPayload, "sourceApp" | "metadata"> {
  metadata?: Record<string, unknown>;
  sourceApp?: string;
}

export interface ReportBugResult {
  ok: boolean;
  status: number;
  id?: string;
  error?: string;
}

const DEFAULT_SOURCE_APP = process.env.NEXT_PUBLIC_DEVHUB_SOURCE_APP_NAME || "unknown-source-app";
const DEFAULT_TIMEOUT_MS = 9000;
const MAX_TEXT_LENGTH = 4000;
const MAX_STACK_LENGTH = 6000;
const DEDUPE_WINDOW_MS = 60_000;
const recentHashes = new Map<string, number>();
const SENSITIVE_KEY_PATTERN = /(password|token|authorization|cookie|secret|api[_-]?key|credit[_-]?card|card[_-]?number)/i;
const SENSITIVE_VALUE_PATTERN = /(bearer\s+[a-z0-9._-]+|sk_[a-z0-9]+|api[_-]?key|password|token|authorization|cookie|secret|\b\d{13,19}\b)/i;

function truncate(value: string, maxLength: number): string {
  if (value.length <= maxLength) return value;
  return `${value.slice(0, maxLength)}...[truncated]`;
}

function sanitizeString(value: string): string {
  const redacted = value.replace(SENSITIVE_VALUE_PATTERN, "[REDACTED]");
  return truncate(redacted, MAX_TEXT_LENGTH);
}

function sanitizeObject(value: unknown): unknown {
  if (Array.isArray(value)) {
    return value.map((item) => sanitizeObject(item));
  }

  if (!value || typeof value !== "object") {
    if (typeof value === "string") return sanitizeString(value);
    return value;
  }

  const sanitized: Record<string, unknown> = {};
  for (const [key, raw] of Object.entries(value as Record<string, unknown>)) {
    if (SENSITIVE_KEY_PATTERN.test(key)) {
      sanitized[key] = "[REDACTED]";
      continue;
    }

    if (typeof raw === "string") {
      sanitized[key] = sanitizeString(raw);
      continue;
    }

    sanitized[key] = sanitizeObject(raw);
  }

  return sanitized;
}

function hashPayload(payload: BugPayload): string {
  return JSON.stringify({
    title: payload.title,
    description: payload.description,
    route: payload.route,
    severity: payload.severity,
  });
}

function shouldSkipByDedupe(hash: string): boolean {
  const now = Date.now();
  const last = recentHashes.get(hash);
  if (last && now - last < DEDUPE_WINDOW_MS) {
    return true;
  }

  recentHashes.set(hash, now);

  if (recentHashes.size > 200) {
    for (const [key, timestamp] of recentHashes.entries()) {
      if (now - timestamp > DEDUPE_WINDOW_MS * 2) {
        recentHashes.delete(key);
      }
    }
  }

  return false;
}

function normalizePayload(payload: BugPayload): BugPayload {
  const safeTitle = sanitizeString(payload.title.trim());
  const safeDescription = truncate(sanitizeString(payload.description.trim()), MAX_STACK_LENGTH);

  return {
    ...payload,
    title: safeTitle,
    description: safeDescription,
    sourceApp: sanitizeString(payload.sourceApp.trim()),
    reporter: payload.reporter ? sanitizeString(payload.reporter.trim()) : undefined,
    route: payload.route ? sanitizeString(payload.route.trim()) : undefined,
    screenshot: payload.screenshot ? sanitizeString(payload.screenshot.trim()) : undefined,
    metadata: sanitizeObject(payload.metadata) as BugMetadata | undefined,
  };
}

function validatePayload(payload: BugPayload): string | null {
  if (!payload.title?.trim()) return "Title is required";
  if (!payload.description?.trim()) return "Description is required";
  if (!payload.sourceApp?.trim()) return "Source app is required";
  return null;
}

async function fetchWithTimeout(url: string, init: RequestInit, timeoutMs: number): Promise<Response> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    return await fetch(url, { ...init, signal: controller.signal });
  } finally {
    clearTimeout(timeoutId);
  }
}

export function buildBugPayload(input: BuildBugPayloadInput): BugPayload {
  const now = new Date().toISOString();
  const viewport = typeof window !== "undefined"
    ? { width: window.innerWidth, height: window.innerHeight }
    : undefined;

  return normalizePayload({
    title: input.title,
    description: input.description,
    sourceApp: input.sourceApp || DEFAULT_SOURCE_APP,
    severity: input.severity,
    reporter: input.reporter,
    route: input.route,
    screenshot: input.screenshot,
    metadata: {
      userAgent: typeof navigator !== "undefined" ? navigator.userAgent : undefined,
      appVersion: process.env.NEXT_PUBLIC_APP_VERSION || "unknown",
      timestamp: now,
      viewport,
      ...(input.metadata || {}),
    },
  });
}

export async function reportBug(payload: BugPayload): Promise<ReportBugResult> {
  const normalized = normalizePayload(payload);
  const validationError = validatePayload(normalized);

  if (validationError) {
    return { ok: false, status: 0, error: validationError };
  }

  const dedupeHash = hashPayload(normalized);
  if (shouldSkipByDedupe(dedupeHash)) {
    return { ok: false, status: 429, error: "Duplicate bug report throttled" };
  }

  const requestInit: RequestInit = {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(normalized),
  };

  for (let attempt = 0; attempt < 2; attempt += 1) {
    try {
      const response = await fetchWithTimeout("/api/report-bug", requestInit, DEFAULT_TIMEOUT_MS);
      const data = (await response.json().catch(() => ({}))) as { id?: string; error?: string };

      if (response.ok) {
        return { ok: true, status: response.status, id: data.id };
      }

      if (response.status >= 500 && attempt === 0) {
        continue;
      }

      return {
        ok: false,
        status: response.status,
        error: data.error || `Request failed with status ${response.status}`,
      };
    } catch (error) {
      if (attempt === 0) {
        continue;
      }

      const message = error instanceof Error ? error.message : "Network error";
      return { ok: false, status: 0, error: message };
    }
  }

  return { ok: false, status: 0, error: "Unknown reporting failure" };
}
