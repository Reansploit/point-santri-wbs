"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import styles from "./styles.module.css";

const INTRO_DURATION_MS = 4200;

const FUR_CLASS_NAMES = Array.from({ length: 31 }, (_, index) => `fur-${31 - index}`);
const LAMP_CLASS_NAMES = Array.from({ length: 28 }, (_, index) => `lamp-${index + 1}`);

function BrushEffect() {
  return (
    <div className="effect-brush">
      {FUR_CLASS_NAMES.map((name) => (
        <span key={name} className={name} />
      ))}
    </div>
  );
}

export default function IntroPage() {
  const router = useRouter();

  useEffect(() => {
    const token = localStorage.getItem("token");
    const roleFromUrl = new URLSearchParams(window.location.search).get("role");
    const savedRole = localStorage.getItem("role");
    const userRole = roleFromUrl ?? savedRole;

    if (!token || !userRole) {
      router.replace("/login");
      return;
    }

    const destination = userRole === "admin" ? "/admin" : "/qism";
    const timeout = window.setTimeout(() => router.replace(destination), INTRO_DURATION_MS);
    return () => window.clearTimeout(timeout);
  }, [router]);

  return (
    <main className={styles.introPage}>
      <div className={styles.container}>
        <div className={styles.netflixIntro} data-letter="N" aria-hidden="true">
          <div className="helper-1">
            <BrushEffect />
            <div className="effect-lumieres">
              {LAMP_CLASS_NAMES.map((name) => (
                <span key={name} className={name} />
              ))}
            </div>
          </div>
          <div className="helper-2">
            <BrushEffect />
          </div>
          <div className="helper-3">
            <BrushEffect />
          </div>
          <div className="helper-4">
            <BrushEffect />
          </div>
        </div>
      </div>
    </main>
  );
}
