"use client";

import React, { useState } from "react";
import { Cpu, Sliders, CheckCircle2 } from "lucide-react";
import { MODEL_METRICS } from "@/config/evaluation";

export function MethodologySection() {
  const [selectedArch, setSelectedArch] = useState<string>("MobileNetV2");

  const activeModel = MODEL_METRICS.find(
    (m) => m.architecture === selectedArch
  ) || MODEL_METRICS[0];

  return (
    <section id="method" className="py-16 md:py-24 bg-white border-t border-[#DCE5E1]">
      <div className="max-w-7xl mx-auto px-6 lg:px-12 space-y-12">
        {/* Header */}
        <div className="max-w-3xl space-y-4">
          <div className="inline-flex items-center gap-2 px-3 py-1 bg-[#087E78]/10 text-[#087E78] rounded-full text-xs font-bold uppercase tracking-wider">
            <Cpu className="w-3.5 h-3.5" />
            <span>Metodologi Deep Learning</span>
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-[#172626] font-sans">
            Arsitektur Model & Pipeline Pelatihan
          </h2>
          <p className="text-sm sm:text-base text-[#5E6B68] leading-relaxed">
            Eksperimen membandingkan 3 arsitektur konvolusi dengan paradigma Transfer Learning berbasis bobot pra-latih ImageNet untuk mengoptimalkan generalisasi fitur visual polimer.
          </p>
        </div>

        {/* 4 Steps Pipeline Overview */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="p-5 rounded-2xl bg-[#F7F7F2] border border-[#DCE5E1] space-y-2">
            <div className="w-8 h-8 rounded-lg bg-[#003B3A] text-white flex items-center justify-center font-bold text-xs">
              01
            </div>
            <h4 className="font-bold text-sm text-[#172626]">Input Preprocessing</h4>
            <p className="text-xs text-[#5E6B68] leading-relaxed">
              Citra di-resize ke dimensi 224×224 piksel, normalisasi kanal RGB [0, 1] atau rescale rentang [-1, 1] sesuai arsitektur backbone.
            </p>
          </div>

          <div className="p-5 rounded-2xl bg-[#F7F7F2] border border-[#DCE5E1] space-y-2">
            <div className="w-8 h-8 rounded-lg bg-[#087E78] text-white flex items-center justify-center font-bold text-xs">
              02
            </div>
            <h4 className="font-bold text-sm text-[#172626]">Data Augmentation</h4>
            <p className="text-xs text-[#5E6B68] leading-relaxed">
              Random horizontal flip, rotasi ±20°, zoom range 0.2, dan shift untuk mencegah model menghafal latar belakang citra lab.
            </p>
          </div>

          <div className="p-5 rounded-2xl bg-[#F7F7F2] border border-[#DCE5E1] space-y-2">
            <div className="w-8 h-8 rounded-lg bg-[#F4B323] text-[#003B3A] flex items-center justify-center font-bold text-xs">
              03
            </div>
            <h4 className="font-bold text-sm text-[#172626]">Class Weighting</h4>
            <p className="text-xs text-[#5E6B68] leading-relaxed">
              Penalti kerugian lebih tinggi pada kesalahan prediksi kelas minoritas (PS & Other) untuk mendongkrak metrik Macro-F1.
            </p>
          </div>

          <div className="p-5 rounded-2xl bg-[#F7F7F2] border border-[#DCE5E1] space-y-2">
            <div className="w-8 h-8 rounded-lg bg-[#247A53] text-white flex items-center justify-center font-bold text-xs">
              04
            </div>
            <h4 className="font-bold text-sm text-[#172626]">Early Stopping</h4>
            <p className="text-xs text-[#5E6B68] leading-relaxed">
              Callback pemantauan <code>val_loss</code> dengan patience 10 epoch untuk memotong proses training sebelum terjadi overfitting.
            </p>
          </div>
        </div>

        {/* Model Comparator Card */}
        <div className="bg-[#F7F7F2] rounded-3xl p-6 md:p-8 border border-[#DCE5E1] space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-[#DCE5E1]">
            <div>
              <h3 className="text-xl font-bold text-[#172626]">
                Komparasi 3 Arsitektur Model
              </h3>
              <p className="text-xs text-[#5E6B68] mt-0.5">
                Pilih model untuk melihat karakteristik dan alasan pemilihannya
              </p>
            </div>

            {/* Architecture Selector Tabs */}
            <div className="flex items-center gap-2 p-1 bg-white rounded-xl border border-[#DCE5E1]">
              {MODEL_METRICS.map((m) => (
                <button
                  key={m.architecture}
                  onClick={() => setSelectedArch(m.architecture)}
                  className={`px-3 py-1.5 text-xs font-bold rounded-lg transition-all ${
                    selectedArch === m.architecture
                      ? "bg-[#087E78] text-white shadow-xs"
                      : "text-[#5E6B68] hover:text-[#172626]"
                  }`}
                >
                  {m.architecture}
                </button>
              ))}
            </div>
          </div>

          {/* Active Model Details */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
            <div className="lg:col-span-5 space-y-4">
              <div className="p-4 bg-white rounded-2xl border border-[#DCE5E1]">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-semibold text-[#5E6B68]">Nama Model</span>
                  {activeModel.isRecommended && (
                    <span className="px-2 py-0.5 bg-[#247A53]/10 text-[#247A53] rounded-md text-[10px] font-bold">
                      Rekomendasi Utama
                    </span>
                  )}
                </div>
                <h4 className="text-lg font-bold text-[#003B3A] mt-1">{activeModel.name}</h4>
                <div className="mt-3 pt-3 border-t border-[#DCE5E1] grid grid-cols-2 gap-2 text-xs">
                  <div>
                    <span className="text-[#5E6B68] block">Akurasi Run Lama:</span>
                    <span className="font-mono font-bold text-base text-[#172626]">
                      {(activeModel.historicalAccuracy * 100).toFixed(1)}%
                    </span>
                  </div>
                  <div>
                    <span className="text-[#5E6B68] block">Macro-F1 Awal:</span>
                    <span className="font-mono font-bold text-base text-[#087E78]">
                      {(activeModel.macroF1 * 100).toFixed(1)}%
                    </span>
                  </div>
                </div>
                <div className="mt-2 text-[11px] text-[#5E6B68]">
                  Jumlah Parameter: <span className="font-mono font-semibold">{activeModel.parameters}</span>
                </div>
              </div>
            </div>

            <div className="lg:col-span-7 grid grid-cols-1 sm:grid-cols-2 gap-4 text-xs">
              <div className="p-4 bg-white rounded-2xl border border-[#DCE5E1] space-y-2">
                <span className="font-bold text-[#247A53] flex items-center gap-1.5">
                  <CheckCircle2 className="w-4 h-4" /> Keunggulan Arsitektur:
                </span>
                <ul className="space-y-1.5 text-[#172626] list-disc list-inside">
                  {activeModel.strengths.map((str, idx) => (
                    <li key={idx} className="leading-relaxed">{str}</li>
                  ))}
                </ul>
              </div>

              <div className="p-4 bg-white rounded-2xl border border-[#DCE5E1] space-y-2">
                <span className="font-bold text-[#B42318] flex items-center gap-1.5">
                  <Sliders className="w-4 h-4" /> Keterbatasan / Perhatian:
                </span>
                <ul className="space-y-1.5 text-[#172626] list-disc list-inside">
                  {activeModel.weaknesses.map((w, idx) => (
                    <li key={idx} className="leading-relaxed">{w}</li>
                  ))}
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
