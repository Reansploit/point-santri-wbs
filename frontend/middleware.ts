import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export function middleware(request: NextRequest) {
  const token = request.cookies.get("token")?.value;
  const role = request.cookies.get("role")?.value;
  const path = request.nextUrl.pathname;

  if ((path.startsWith("/admin") || path.startsWith("/qism")) && !path.includes("/login") && !token) {
    return NextResponse.redirect(new URL("/", request.url));
  }
  if (path === "/intro" && !token) {
    return NextResponse.redirect(new URL("/login", request.url));
  }
  if (token && path.startsWith("/admin") && !path.includes("/login") && role !== "admin") {
    return NextResponse.redirect(new URL("/qism", request.url));
  }
  if (token && path.startsWith("/qism") && !path.includes("/login") && role !== "qism") {
    return NextResponse.redirect(new URL("/admin", request.url));
  }
  if (token && path === "/admin/login" && role === "admin") {
    return NextResponse.redirect(new URL("/admin", request.url));
  }
  if (token && path === "/qism/login" && role === "qism") {
    return NextResponse.redirect(new URL("/qism", request.url));
  }
  if (token && path === "/login") {
    return NextResponse.redirect(new URL(role === "admin" ? "/admin" : "/qism", request.url));
  }
  return NextResponse.next();
}

export const config = {
  matcher: ["/admin/:path*", "/qism/:path*", "/login", "/intro"],
};
