"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Menu, X, ArrowUpRight } from "lucide-react";
import { NAV_ITEMS, SITE_CONFIG } from "@/config/site";

export function Navbar() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  return (
    <header className="w-full pt-4 md:pt-6 px-4 fixed top-0 left-0 right-0 z-50 pointer-events-none">
      <div className="max-w-6xl mx-auto flex items-center justify-between pointer-events-auto">
        {/* Floating pill navigation container matching land.png */}
        <nav
          aria-label="Navigasi Utama"
          className="w-full bg-[#003B3A]/95 backdrop-blur-md border border-white/50 rounded-full px-4 py-2.5 flex items-center justify-between shadow-2xl transition-all"
        >
          {/* Left: Recycling emblem badge from land.png */}
          <Link
            href="#home"
            className="flex items-center gap-3 group focus:outline-none focus:ring-2 focus:ring-[#F4B323] rounded-full"
            aria-label="Kembali ke Beranda"
          >
            <div className="w-12 h-9 md:w-14 md:h-10 bg-[#D2F7CB] border-2 border-black/80 rounded-full flex items-center justify-center p-1 shadow-inner group-hover:scale-105 transition-transform">
              {/* Bottle recycling graphic */}
              <svg
                viewBox="0 0 48 36"
                className="w-full h-full text-[#14532D]"
                fill="currentColor"
                aria-hidden="true"
              >
                <path d="M14 6 C12 6 10 8 10 11 L10 14 L8 14 C6.9 14 6 14.9 6 16 L6 20 C6 21.1 6.9 22 8 22 L10 22 L10 25 C10 28 12 30 14 30 L22 30 C24 30 26 28 26 25 L26 11 C26 8 24 6 22 6 Z M18 2 L20 2 C20.5 2 21 2.5 21 3 L21 5 L17 5 L17 3 C17 2.5 17.5 2 18 2 Z" opacity="0.9" />
                <path d="M28 10 L36 10 C38 10 40 12 40 14 L40 24 C40 26 38 28 36 28 L28 28 Z" opacity="0.75" />
                <path d="M24 16 L30 12 L30 20 Z" fill="#22C55E" />
              </svg>
            </div>
            <span className="hidden sm:inline-block font-bold tracking-wider text-xs md:text-sm text-white/90 uppercase font-sans">
              {SITE_CONFIG.name}
            </span>
          </Link>

          {/* Center Links matching land.png (HOME, ABOUT, METHOD, etc.) */}
          <div className="hidden md:flex items-center gap-6 lg:gap-8 text-white font-bold tracking-widest text-xs lg:text-sm">
            {NAV_ITEMS.map((item) => (
              <a
                key={item.label}
                href={item.href}
                className="hover:text-[#F4B323] transition-colors py-1 relative group focus:outline-none focus:ring-1 focus:ring-[#F4B323] rounded"
              >
                {item.label}
                <span className="absolute bottom-0 left-0 w-0 h-0.5 bg-[#F4B323] transition-all duration-200 group-hover:w-full" />
              </a>
            ))}
          </div>

          {/* Right Action: Mint-green button matching land.png */}
          <div className="flex items-center gap-3">
            <a
              href="#classifier"
              className="w-10 h-10 md:w-11 md:h-11 bg-[#D2F7CB] hover:bg-[#bcf2b2] text-[#003B3A] border border-black/40 rounded-full md:rounded-2xl flex items-center justify-center shadow-md hover:scale-105 active:scale-95 transition-all focus:outline-none focus:ring-2 focus:ring-[#F4B323]"
              title="Mulai Klasifikasi Sampah"
              aria-label="Buka Classifier"
            >
              {/* Login / classifier entry icon from land.png */}
              <div className="relative flex items-center justify-center">
                <ArrowUpRight className="w-5 h-5 stroke-[2.5]" />
              </div>
            </a>

            {/* Mobile menu trigger */}
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="md:hidden p-2 text-white hover:text-[#F4B323] focus:outline-none focus:ring-2 focus:ring-[#F4B323] rounded-lg"
              aria-label={mobileMenuOpen ? "Tutup menu" : "Buka menu"}
            >
              {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </nav>
      </div>

      {/* Mobile Drawer Menu */}
      {mobileMenuOpen && (
        <div className="md:hidden max-w-sm mx-auto mt-2 bg-[#003B3A]/98 backdrop-blur-lg border border-white/40 rounded-2xl p-5 shadow-2xl pointer-events-auto animate-in fade-in slide-in-from-top-4 duration-200">
          <div className="flex flex-col gap-3">
            {NAV_ITEMS.map((item) => (
              <a
                key={item.label}
                href={item.href}
                onClick={() => setMobileMenuOpen(false)}
                className="text-white font-semibold text-sm tracking-wider py-2 px-3 rounded-lg hover:bg-white/10 hover:text-[#F4B323] transition-colors"
              >
                {item.label}
              </a>
            ))}
            <div className="pt-3 border-t border-white/20">
              <a
                href="#classifier"
                onClick={() => setMobileMenuOpen(false)}
                className="w-full py-2.5 px-4 bg-[#F4B323] text-[#003B3A] font-bold text-center text-sm rounded-xl block shadow hover:bg-[#D99A0B] transition-colors"
              >
                Coba Klasifikasi Sekarang
              </a>
            </div>
          </div>
        </div>
      )}
    </header>
  );
}
