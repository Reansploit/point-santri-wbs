import type { ButtonHTMLAttributes } from "react";

type Variant = "glow" | "default" | "destructive" | "ghost";

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
}

const base =
  "inline-flex items-center justify-center gap-2 rounded-xl px-3 py-2 text-sm font-medium transition disabled:opacity-50 disabled:cursor-not-allowed";

export function Button({ variant = "default", className = "", ...rest }: Props) {
  let styles = "border border-border bg-card text-foreground hover:bg-accent";
  if (variant === "glow") styles = "qism-glow-btn";
  else if (variant === "destructive")
    styles = "bg-destructive text-destructive-foreground hover:opacity-90";
  else if (variant === "ghost") styles = "hover:bg-accent text-foreground";
  return <button className={`${base} ${styles} ${className}`} {...rest} />;
}
