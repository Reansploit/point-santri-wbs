import { NextRequest, NextResponse } from "next/server";

const BACKEND_API_BASE = process.env.BACKEND_API_URL || "http://127.0.0.1:8000/api";

async function handler(request: NextRequest, context: { params: Promise<{ path: string[] }> }) {
  const { path } = await context.params;
  const targetUrl = new URL(`${BACKEND_API_BASE}/${path.join("/")}`);
  request.nextUrl.searchParams.forEach((value, key) => targetUrl.searchParams.append(key, value));

  const contentType = request.headers.get("content-type");
  const authorization = request.headers.get("authorization");

  const init: RequestInit = {
    method: request.method,
    headers: {
      ...(contentType ? { "content-type": contentType } : {}),
      ...(authorization ? { authorization } : {}),
      accept: request.headers.get("accept") || "*/*",
    },
    body: ["GET", "HEAD"].includes(request.method) ? undefined : await request.arrayBuffer(),
  };

  const response = await fetch(targetUrl.toString(), init);
  const responseBody = await response.arrayBuffer();
  const nextResponse = new NextResponse(responseBody, { status: response.status });

  const passthroughHeaders = ["content-type", "content-disposition"];
  passthroughHeaders.forEach((header) => {
    const value = response.headers.get(header);
    if (value) nextResponse.headers.set(header, value);
  });

  return nextResponse;
}

export { handler as GET, handler as POST, handler as PUT, handler as PATCH, handler as DELETE };

