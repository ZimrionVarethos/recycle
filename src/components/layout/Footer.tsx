"use client";

import React from "react";
import { SITE_CONFIG, NAV_ITEMS } from "@/config/site";
import { ArrowUp } from "lucide-react";

export function Footer() {
  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  return (
    <footer className="bg-[#003B3A] text-white pt-16 pb-12 border-t border-white/10">
      <div className="max-w-7xl mx-auto px-6 lg:px-12 space-y-12">
        <div className="grid grid-cols-1 md:grid-cols-12 gap-8 items-start">
          {/* Col 1: Brand & Academic Affiliation */}
          <div className="md:col-span-6 space-y-3">
            <div className="flex items-center gap-3">
              <div className="w-10 h-7 bg-[#D2F7CB] rounded-full flex items-center justify-center p-0.5">
                <svg viewBox="0 0 48 36" className="w-full h-full text-[#14532D]" fill="currentColor">
                  <path d="M14 6 C12 6 10 8 10 11 L10 14 L8 14 C6.9 14 6 14.9 6 16 L6 20 C6 21.1 6.9 22 8 22 L10 22 L10 25 C10 28 12 30 14 30 L22 30 C24 30 26 28 26 25 L26 11 C26 8 24 6 22 6 Z" />
                </svg>
              </div>
              <span className="font-extrabold text-xl tracking-wider text-white">
                {SITE_CONFIG.name}
              </span>
            </div>
            <p className="text-xs text-white/80 max-w-md leading-relaxed">
              {SITE_CONFIG.tagline}. Dikembangkan untuk riset klasifikasi visual polimer sampah plastik guna mempermudah pemilihan di bank sampah dan industri daur ulang.
            </p>
            <div className="pt-2 text-xs text-[#D2F7CB] font-medium">
              {SITE_CONFIG.course} • {SITE_CONFIG.institution} ({SITE_CONFIG.team})
            </div>
          </div>

          {/* Col 2: Navigation Links */}
          <div className="md:col-span-3 space-y-2.5">
            <h5 className="text-xs font-bold uppercase tracking-wider text-[#F4B323]">
              Tautan Navigasi
            </h5>
            <ul className="space-y-1.5 text-xs text-white/80">
              {NAV_ITEMS.map((item) => (
                <li key={item.label}>
                  <a
                    href={item.href}
                    className="hover:text-[#F4B323] transition-colors"
                  >
                    {item.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Col 3: Research Metadata */}
          <div className="md:col-span-3 space-y-2.5">
            <h5 className="text-xs font-bold uppercase tracking-wider text-[#F4B323]">
              Status Model
            </h5>
            <ul className="space-y-1.5 text-xs text-white/80">
              <li>Training: Google Colab Pro (~70%)</li>
              <li>Target Acceptance: ≥ 92% Rilis</li>
              <li>Input: 224 × 224 RGB</li>
              <li>Backbone: MobileNetV2 / VGG16</li>
            </ul>
          </div>
        </div>

        {/* Bottom Line */}
        <div className="pt-8 border-t border-white/10 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-white/60">
          <p>
            © 2026 {SITE_CONFIG.team} • {SITE_CONFIG.institution}. Hak Cipta Akademik Dilindungi.
          </p>
          <button
            onClick={scrollToTop}
            className="flex items-center gap-1.5 text-white/80 hover:text-[#F4B323] transition-colors"
          >
            <span>Kembali ke Atas</span>
            <ArrowUp className="w-4 h-4" />
          </button>
        </div>
      </div>
    </footer>
  );
}
