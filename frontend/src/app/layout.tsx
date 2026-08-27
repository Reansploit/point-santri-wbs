import "./globals.css";
import type { ReactNode } from "react";
import { Providers } from "@/components/shared/providers";

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="id">
      <body className="min-h-screen antialiased">
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}

