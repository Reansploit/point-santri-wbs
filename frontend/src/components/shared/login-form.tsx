"use client";

import { api } from "@/lib/api";
import { zodResolver } from "@hookform/resolvers/zod";
import { motion } from "framer-motion";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { useForm } from "react-hook-form";
import { useState } from "react";
import { z } from "zod";

const schema = z.object({
  username: z.string().min(1),
  password: z.string().min(1),
});

export function LoginForm() {
  const router = useRouter();
  const [errorMessage, setErrorMessage] = useState("");
  const { register, handleSubmit } = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
  });

  const onSubmit = handleSubmit(async (values) => {
    setErrorMessage("");
    try {
      const { data } = await api.post("/auth/login", values);
      const userRole = data.user.role as "admin" | "qism";
      localStorage.setItem("token", data.token);
      localStorage.setItem("role", userRole);
      document.cookie = `token=${data.token}; path=/`;
      document.cookie = `role=${userRole}; path=/`;
      router.push(`/intro?role=${userRole}`);
    } catch (error: any) {
      const apiMessage = error?.response?.data?.message;
      setErrorMessage(apiMessage || "Login gagal. Periksa username/password.");
    }
  });

  return (
    <section className="netflix-auth-shell">
      <div className="netflix-auth-overlay" />
      <nav className="netflix-auth-nav">
        <Image src="/netflix/logo.png" alt="Logo" width={168} height={45} priority />
      </nav>

      <motion.form
        initial={{ opacity: 0, y: 18 }}
        animate={{ opacity: 1, y: 0 }}
        onSubmit={onSubmit}
        className="netflix-auth-card"
      >
        <h1 className="netflix-auth-title">Sign In</h1>

        <div className="netflix-field">
          <input
            {...register("username")}
            id="username"
            placeholder=" "
            autoComplete="username"
            className="netflix-input peer"
          />
          <label htmlFor="username" className="netflix-label">
            Username
          </label>
        </div>

        <div className="netflix-field">
          <input
            {...register("password")}
            id="password"
            type="password"
            placeholder=" "
            autoComplete="current-password"
            className="netflix-input peer"
          />
          <label htmlFor="password" className="netflix-label">
            Password
          </label>
        </div>

        {errorMessage && <p className="text-sm text-[#f87171]">{errorMessage}</p>}

        <button type="submit" className="netflix-submit">
          Sign In
        </button>

        <div className="mt-4 flex items-center justify-between text-sm text-[#b3b3b3]">
          <label className="flex items-center gap-2">
            <input type="checkbox" className="h-4 w-4 accent-[#737373]" />
            Remember me
          </label>
          <a href="#" onClick={(event) => event.preventDefault()} className="hover:underline">
            Need help?
          </a>
        </div>

        <p className="mt-12 text-base text-[#737373]">
          New to Point App?{" "}
          <span className="font-medium text-white">Contact admin.</span>
        </p>
      </motion.form>
    </section>
  );
}
