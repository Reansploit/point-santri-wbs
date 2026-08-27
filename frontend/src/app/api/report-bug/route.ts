import { NextResponse } from "next/server";

const DEVHUB_BUG_ENDPOINT = process.env.DEVHUB_BUG_ENDPOINT;
const DEVHUB_BUG_API_KEY = process.env.DEVHUB_BUG_API_KEY;
const DEVHUB_SOURCE_APP_NAME = process.env.DEVHUB_SOURCE_APP_NAME || "unknown-source-app";
const MAX_DESCRIPTION = 6000;

function truncate(value: string, maxLength: number): string {
  if (value.length <= maxLength) return value;
  return `${value.slice(0, maxLength)}...[truncated]`;
}

export async function POST(request: Request) {
  if (!DEVHUB_BUG_ENDPOINT || !DEVHUB_BUG_API_KEY) {
    console.warn("[DevHub Bug] Missing DEVHUB_BUG_ENDPOINT or DEVHUB_BUG_API_KEY. Skipping bug report.");
    return NextResponse.json({ ok: false, error: "DevHub env is not configured" }, { status: 503 });
  }

  try {
    const body = (await request.json()) as Record<string, unknown>;
    const payload = {
      title: String(body.title || "").trim(),
      description: truncate(String(body.description || "").trim(), MAX_DESCRIPTION),
      sourceApp: DEVHUB_SOURCE_APP_NAME,
      severity: body.severity,
      reporter: body.reporter,
      route: body.route,
      screenshot: body.screenshot,
      metadata: body.metadata,
    };

    if (!payload.title || !payload.description) {
      return NextResponse.json({ ok: false, error: "title and description are required" }, { status: 400 });
    }

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 9000);

    let response: Response;
    try {
      response = await fetch(DEVHUB_BUG_ENDPOINT, {
        method: "POST",
        headers: {
          "content-type": "application/json",
          "x-devhub-api-key": DEVHUB_BUG_API_KEY,
        },
        body: JSON.stringify(payload),
        signal: controller.signal,
      });
    } finally {
      clearTimeout(timeoutId);
    }

    const data = (await response.json().catch(() => ({}))) as Record<string, unknown>;
    const id = data.id || data.bugId || (typeof data.data === "object" && data.data ? (data.data as Record<string, unknown>).id : undefined);

    return NextResponse.json(
      {
        ok: response.ok,
        status: response.status,
        id: typeof id === "string" || typeof id === "number" ? String(id) : undefined,
        error: response.ok ? undefined : String(data.error || data.message || "Failed to send bug report"),
      },
      { status: response.ok ? 200 : response.status },
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unexpected reporting failure";
    return NextResponse.json({ ok: false, status: 0, error: message }, { status: 500 });
  }
}
