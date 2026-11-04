"use client";

import React from "react";
import { GraduationCap, Users, HeartHandshake, ShieldAlert, Award } from "lucide-react";
import { SITE_CONFIG } from "@/config/site";

export function AboutSection() {
  return (
    <section id="about" className="py-16 md:py-24 bg-white border-t border-[#DCE5E1]">
      <div className="max-w-7xl mx-auto px-6 lg:px-12 space-y-12">
        {/* Header */}
        <div className="max-w-3xl space-y-4">
          <div className="inline-flex items-center gap-2 px-3 py-1 bg-[#087E78]/10 text-[#087E78] rounded-full text-xs font-bold uppercase tracking-wider">
            <GraduationCap className="w-3.5 h-3.5" />
            <span>Tentang Proyek Riset</span>
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-[#172626] font-sans">
            Inisiatif Daur Ulang Berbasis Kecerdasan Buatan
          </h2>
          <p className="text-sm sm:text-base text-[#5E6B68] leading-relaxed">
            Proyek <strong>DEEP SORTING</strong> dikembangkan oleh tim mahasiswa <strong>{SITE_CONFIG.team}</strong> pada mata kuliah <strong>{SITE_CONFIG.course}</strong>, {SITE_CONFIG.department}, <strong>{SITE_CONFIG.institution}</strong>.
          </p>
        </div>

        {/* Academic Profile & SDG Alignment Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="p-6 bg-[#F7F7F2] rounded-2xl border border-[#DCE5E1] space-y-3">
            <div className="w-10 h-10 rounded-xl bg-[#003B3A] text-[#F4B323] flex items-center justify-center font-bold">
              <Users className="w-5 h-5" />
            </div>
            <h4 className="font-bold text-base text-[#172626]">
              Tim Peneliti (Kelompok 7)
            </h4>
            <p className="text-xs text-[#5E6B68] leading-relaxed">
              Fokus pada eksplorasi arsitektur Convolutional Neural Networks (CNN) ringan untuk aplikasi web real-time yang dapat diakses dari peramban ponsel pintar di lapangan.
            </p>
          </div>

          <div className="p-6 bg-[#F7F7F2] rounded-2xl border border-[#DCE5E1] space-y-3">
            <div className="w-10 h-10 rounded-xl bg-[#087E78] text-white flex items-center justify-center font-bold">
              <HeartHandshake className="w-5 h-5" />
            </div>
            <h4 className="font-bold text-base text-[#172626]">
              Dukungan SDG 12 & 14
            </h4>
            <p className="text-xs text-[#5E6B68] leading-relaxed">
              Mendukung tujuan pembangunan berkelanjutan PBB: Pola Konsumsi dan Produksi yang Bertanggung Jawab (SDG 12) serta Perlindungan Ekosistem Lautan dari Sampah Plastik (SDG 14).
            </p>
          </div>

          <div className="p-6 bg-[#F7F7F2] rounded-2xl border border-[#DCE5E1] space-y-3">
            <div className="w-10 h-10 rounded-xl bg-[#F4B323] text-[#003B3A] flex items-center justify-center font-bold">
              <Award className="w-5 h-5" />
            </div>
            <h4 className="font-bold text-base text-[#172626]">
              Tujuan Edukasi & Publik
            </h4>
            <p className="text-xs text-[#5E6B68] leading-relaxed">
              Meningkatkan literasi masyarakat mengenai kode resin daur ulang (kode 1-7) dan tata cara pemilahan sampah plastik yang benar sebelum disalurkan ke bank sampah.
            </p>
          </div>
        </div>

        {/* Disclaimer Notice */}
        <div className="p-5 bg-[#003B3A] text-white rounded-2xl flex flex-col sm:flex-row items-start sm:items-center gap-4">
          <ShieldAlert className="w-7 h-7 text-[#F4B323] flex-shrink-0" />
          <div className="space-y-1 text-xs leading-relaxed text-white/90">
            <h5 className="font-bold text-sm text-[#F4B323]">Pernyataan Batasan Tanggung Jawab Akademik</h5>
            <p>
              Aplikasi ini adalah purwarupa penelitian komputer visi dan tidak dimaksudkan sebagai pengganti uji laboratorium spektroskopi inframerah dekat (NIR). Selalu periksa tanda segitiga daur ulang dan logo cetak resin pada fisik kemasan produk untuk kepastian daur ulang industri.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}
