# Animated Characters Login Page 🎨✨

Halaman login interaktif dengan karakter animasi yang mengikuti pergerakan kursor mouse dan bereaksi saat Anda mengetik atau melihat password. Dibuat menggunakan **Next.js**, **Tailwind CSS**, dan **shadcn/ui**.

## 🖼️ Preview Tampilan

![Preview Login Page](![alt text](image.png))

## 🚀 Fitur Utama

- **Mouse Tracking**: Mata dan postur karakter akan merespons letak kursor Anda.
- **Interaksi Mengetik**: Karakter bereaksi saling bertatapan ketika Anda mulai mengetik email.
- **Efek Mengintip**: Karakter utama akan mengintip lucunya ketika visibilitas *password* diaktifkan.
- **Responsif**: Memiliki tata letak layar penuh yang cantik di iterasi Desktop dan menyusut secara elegan di versi Mobile.

## 🛠️ Teknologi yang Digunakan

- [Next.js](https://nextjs.org/)
- [React](https://reactjs.org/)
- [Tailwind CSS v3](https://tailwindcss.com/)
- [shadcn/ui](https://ui.shadcn.com/) (Radix UI)
- [TypeScript](https://www.typescriptlang.org/)

## 📦 Cara Memulai

1. **Install dependensi**
   ```bash
   npm install
   ```

2. **Jalankan development server**
   ```bash
   npm run dev
   ```

3. **Lihat Hasilnya**
   Buka [http://localhost:3005/demo](http://localhost:3005/demo) (atau port yang diberikan di terminal) di browser Anda.

## 📁 Struktur Komponen Utama
- `components/ui/animated-characters-login-page.tsx` - File utama untuk seluruh struktur karakter animasi dan form login.
- `app/demo/page.tsx` - Rute yang mengekspor UI utamanya.
