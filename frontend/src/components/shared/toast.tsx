"use client";

import { AnimatePresence, motion } from "framer-motion";

export function Toast({ message, type }: { message: string; type: "success" | "error" }) {
  if (!message) return null;
  return (
    <AnimatePresence>
      <motion.div
        initial={{ opacity: 0, y: -8 }}
        animate={{ opacity: 1, y: 0 }}
        exit={{ opacity: 0, y: -8 }}
        className={`fixed right-4 top-4 z-50 rounded-xl px-4 py-2 text-white shadow ${
          type === "success" ? "bg-emerald-600" : "bg-rose-600"
        }`}
      >
        {message}
      </motion.div>
    </AnimatePresence>
  );
}

