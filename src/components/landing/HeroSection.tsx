"use client";

import React from "react";
import Image from "next/image";
import { Camera, ArrowDown, Sparkles, BookOpen } from "lucide-react";
import { SITE_CONFIG } from "@/config/site";

export function HeroSection() {
  return (
    <section
      id="home"
      className="relative min-h-screen bg-[#003B3A] text-white pt-28 md:pt-36 pb-20 md:pb-32 overflow-hidden flex flex-col justify-between"
    >
      {/* Background ambient lighting */}
      <div className="absolute inset-0 bg-gradient-to-br from-[#004B49]/40 via-transparent to-[#002B2A] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-6 lg:px-12 w-full grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-center relative z-10 flex-grow">
        {/* Left Column: Typography & CTAs matching land.png */}
        <div className="lg:col-span-7 flex flex-col justify-center space-y-6 pt-4 lg:pt-0">
          {/* Academic badge */}
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white/10 backdrop-blur-sm border border-white/20 text-[#D2F7CB] text-xs font-medium w-fit">
            <span className="w-2 h-2 rounded-full bg-[#F4B323] animate-pulse" />
            <span>{SITE_CONFIG.institution} • {SITE_CONFIG.course}</span>
          </div>

          {/* Main Title matching land.png */}
          <h1 className="text-5xl sm:text-6xl md:text-7xl font-extrabold tracking-tight text-white leading-none font-sans drop-shadow-md">
            DEEP SORTING
          </h1>

          {/* Subtitle with the iconic white "L" bracket mark from land.png */}
          <div className="flex items-start gap-3 sm:gap-4 max-w-xl">
            {/* White L-shape graphic */}
            <div className="flex-shrink-0 pt-1" aria-hidden="true">
              <svg width="28" height="48" viewBox="0 0 28 48" fill="none" className="text-white">
                <path
                  d="M4 2 V38 H26"
                  stroke="currentColor"
                  strokeWidth="6"
                  strokeLinecap="square"
                />
              </svg>
            </div>
            <div>
              <p className="text-xl sm:text-2xl md:text-3xl font-semibold text-white/95 leading-snug tracking-normal">
                Klasifikasi Jenis Sampah Plastik dengan{" "}
                <span className="text-[#D2F7CB]">CNN dan Transfer Learning</span>
              </p>
              <p className="text-xs sm:text-sm text-[#DCE5E1]/80 mt-2 font-normal">
                Mengidentifikasi 7 kategori resin polimer (PET, HDPE, PVC, LDPE, PP, PS, Other) berbasis MobileNetV2 dan VGG16.
              </p>
            </div>
          </div>

          {/* Training status indicator */}
          <div className="p-3.5 rounded-xl bg-white/5 border border-white/15 max-w-lg backdrop-blur-xs flex items-center justify-between text-xs sm:text-sm">
            <div className="flex items-center gap-2">
              <span className="text-[#F4B323] font-bold">Fase Proyek:</span>
              <span className="text-white/80">Training Colab (~70%)</span>
            </div>
            <div className="flex items-center gap-1.5 text-[#D2F7CB] font-semibold">
              <span>Target Rilis: ≥92%</span>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex flex-wrap items-center gap-4 pt-2">
            <a
              href="#classifier"
              className="px-6 py-3.5 bg-[#F4B323] hover:bg-[#D99A0B] text-[#003B3A] font-bold rounded-xl shadow-lg hover:shadow-xl transition-all flex items-center gap-2.5 text-sm sm:text-base active:scale-95"
            >
              <Camera className="w-5 h-5" />
              <span>Mulai Uji Klasifikasi</span>
            </a>
            <a
              href="#method"
              className="px-5 py-3.5 bg-white/10 hover:bg-white/20 text-white font-semibold rounded-xl border border-white/30 backdrop-blur-sm transition-all flex items-center gap-2 text-sm sm:text-base"
            >
              <BookOpen className="w-4 h-4 text-[#D2F7CB]" />
              <span>Pelajari Metodologi</span>
            </a>
          </div>

          {/* Quick research metadata */}
          <div className="pt-2 flex items-center gap-6 text-xs text-white/70">
            <div>
              <span className="font-bold text-white text-sm">1.331</span> Citra Latih
            </div>
            <div className="h-4 w-px bg-white/20" />
            <div>
              <span className="font-bold text-white text-sm">7</span> Kategori Polimer
            </div>
            <div className="h-4 w-px bg-white/20" />
            <div>
              <span className="font-bold text-white text-sm">224×224</span> Input RGB
            </div>
          </div>
        </div>

        {/* Right Column: Hero composition matching land.png */}
        <div className="lg:col-span-5 relative flex justify-center items-center">
          <div className="relative w-full max-w-lg rounded-2xl overflow-hidden shadow-2xl border-2 border-white/20 group">
            <div className="relative aspect-4/3 w-full bg-[#004B49]">
              <Image
                src="/land.png"
                alt="DEEP SORTING - Sampah Plastik dalam Tempat Sampah Daur Ulang"
                fill
                priority
                className="object-cover object-right group-hover:scale-105 transition-transform duration-700"
                sizes="(max-width: 768px) 100vw, 50vw"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-[#003B3A]/80 via-transparent to-transparent pointer-events-none" />
            </div>

            {/* Floating Info Badges */}
            <div className="absolute bottom-3 left-3 right-3 p-3 bg-[#003B3A]/90 backdrop-blur-md rounded-xl border border-white/20 flex items-center justify-between text-xs">
              <div className="flex items-center gap-2">
                <Sparkles className="w-4 h-4 text-[#F4B323]" />
                <span className="text-white font-medium">Dataset Plastik 7 Kelas</span>
              </div>
              <span className="text-[#D2F7CB] font-mono text-[11px]">Resin Code 1 - 7</span>
            </div>
          </div>
        </div>
      </div>

      {/* Dynamic bottom swoosh wave matching land.png */}
      <div className="absolute bottom-0 left-0 right-0 w-full overflow-hidden leading-none z-20 pointer-events-none">
        <svg
          viewBox="0 0 1440 120"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          className="relative block w-full h-14 sm:h-20 md:h-28"
          preserveAspectRatio="none"
        >
          {/* White accent curve line from land.png */}
          <path
            d="M600 120 C 850 60, 1150 10, 1440 30 L 1440 120 Z"
            fill="#FFFFFF"
          />
          {/* Golden Yellow / Amber swoosh wave from land.png */}
          <path
            d="M650 120 C 900 80, 1200 25, 1440 45 L 1440 120 Z"
            fill="#F4B323"
          />
        </svg>
      </div>

      {/* Down indicator */}
      <div className="absolute bottom-4 left-1/2 -translate-x-1/2 hidden md:flex items-center gap-1.5 text-xs text-white/50 animate-bounce z-30">
        <span>Gulir ke bawah</span>
        <ArrowDown className="w-3.5 h-3.5" />
      </div>
    </section>
  );
}
