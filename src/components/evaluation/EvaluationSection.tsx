"use client";

import React from "react";
import { BarChart3, Target, AlertTriangle } from "lucide-react";
import { PROJECT_MILESTONES, HISTORICAL_CLASS_PERFORMANCE } from "@/config/evaluation";
import { ConfusionMatrixTable } from "./ConfusionMatrixTable";

export function EvaluationSection() {
  return (
    <section id="evaluasi" className="py-16 md:py-24 bg-[#F7F7F2] border-t border-[#DCE5E1]">
      <div className="max-w-7xl mx-auto px-6 lg:px-12 space-y-12">
        {/* Header */}
        <div className="max-w-3xl space-y-4">
          <div className="inline-flex items-center gap-2 px-3 py-1 bg-[#087E78]/10 text-[#087E78] rounded-full text-xs font-bold uppercase tracking-wider">
            <BarChart3 className="w-3.5 h-3.5" />
            <span>Evaluasi & Target Rilis</span>
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-[#172626] font-sans">
            Transparansi Metrik & Kriteria Acceptance
          </h2>
          <p className="text-sm sm:text-base text-[#5E6B68] leading-relaxed">
            Menjunjung prinsip evaluasi machine learning yang jujur: mendokumentasikan progres nyata dari eksperimen awal, iterasi Google Colab saat ini, dan kriteria ketat sebelum model dinyatakan layak rilis.
          </p>
        </div>

        {/* 3 Milestones Pipeline */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          {PROJECT_MILESTONES.map((m, idx) => (
            <div
              key={idx}
              className={`p-6 rounded-2xl border transition-all ${
                m.status === "target"
                  ? "bg-[#003B3A] text-white border-[#003B3A] shadow-lg"
                  : m.status === "in-progress"
                  ? "bg-white text-[#172626] border-[#087E78] ring-2 ring-[#087E78]/20 shadow-md"
                  : "bg-white text-[#172626] border-[#DCE5E1]"
              }`}
            >
              <div className="flex items-center justify-between mb-3">
                <span
                  className={`px-2.5 py-1 rounded-full text-[11px] font-bold tracking-wider uppercase ${
                    m.status === "target"
                      ? "bg-[#F4B323] text-[#003B3A]"
                      : m.status === "in-progress"
                      ? "bg-[#087E78]/15 text-[#087E78]"
                      : "bg-[#F7F7F2] text-[#5E6B68] border border-[#DCE5E1]"
                  }`}
                >
                  {m.badge}
                </span>
                <span className="font-mono text-xl font-extrabold">
                  {m.accuracy}
                </span>
              </div>
              <h4 className="font-bold text-base mb-2">{m.stage}</h4>
              <p
                className={`text-xs leading-relaxed ${
                  m.status === "target" ? "text-white/80" : "text-[#5E6B68]"
                }`}
              >
                {m.description}
              </p>
            </div>
          ))}
        </div>

        {/* Acceptance Criteria Callout */}
        <div className="p-6 bg-white rounded-3xl border border-[#087E78]/40 shadow-sm space-y-3">
          <div className="flex items-center gap-2.5 text-[#087E78]">
            <Target className="w-5 h-5 text-[#F4B323]" />
            <h3 className="text-base font-bold text-[#172626]">
              Syarat Kriteria Acceptance Sebelum Rilis Resmi (Target ≥92%)
            </h3>
          </div>
          <p className="text-xs text-[#5E6B68] leading-relaxed">
            Target 92% adalah <strong>sasaran mutu proyek</strong>, bukan klaim performa yang sudah diraih. Sebelum model dinyatakan lulus untuk produksi, pengujian harus memenuhi syarat:
          </p>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 text-xs pt-1">
            <div className="p-3 bg-[#F7F7F2] rounded-xl border border-[#DCE5E1]">
              <span className="font-bold text-[#087E78] block mb-1">1. Test Set Terpisah</span>
              <p className="text-[#5E6B68]">
                Minimal 92% akurasi pada held-out test set independen tanpa kebocoran data (no data leakage).
              </p>
            </div>
            <div className="p-3 bg-[#F7F7F2] rounded-xl border border-[#DCE5E1]">
              <span className="font-bold text-[#087E78] block mb-1">2. Keseimbangan Macro-F1</span>
              <p className="text-[#5E6B68]">
                Macro-F1 score ≥0.88 memastikan kelas minoritas (PS & Other) tidak terabaikan oleh model.
              </p>
            </div>
            <div className="p-3 bg-[#F7F7F2] rounded-xl border border-[#DCE5E1]">
              <span className="font-bold text-[#087E78] block mb-1">3. Uji Foto Lapangan</span>
              <p className="text-[#5E6B68]">
                Uji langsung menggunakan kamera gawai pada botol nyata yang kotor, terlipat, atau terkena bayangan.
              </p>
            </div>
            <div className="p-3 bg-[#F7F7F2] rounded-xl border border-[#DCE5E1]">
              <span className="font-bold text-[#087E78] block mb-1">4. Verifikasi Grad-CAM</span>
              <p className="text-[#5E6B68]">
                Memastikan aktivasi konvolusi fokus pada karakteristik badan plastik, bukan stiker label atau latar meja.
              </p>
            </div>
          </div>
        </div>

        {/* Confusion Matrix Table Component */}
        <ConfusionMatrixTable />

        {/* Per-Class Metrics Table & Limitations */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          {/* Per-Class Table */}
          <div className="lg:col-span-7 bg-white p-5 rounded-2xl border border-[#DCE5E1] space-y-3">
            <h4 className="text-sm font-bold text-[#172626]">
              Kinerja Awal per Kelas (Baseline MobileNetV2 Run)
            </h4>
            <div className="overflow-x-auto">
              <table className="w-full text-xs text-left border-collapse">
                <thead>
                  <tr className="border-b border-[#DCE5E1] text-[#5E6B68]">
                    <th className="py-2">Kelas</th>
                    <th className="py-2 text-right">Sampel Latih</th>
                    <th className="py-2 text-right">Precision</th>
                    <th className="py-2 text-right">Recall</th>
                    <th className="py-2 text-right">F1-Score</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-[#DCE5E1]/60 font-mono">
                  {HISTORICAL_CLASS_PERFORMANCE.map((row) => (
                    <tr key={row.label} className="hover:bg-[#F7F7F2]">
                      <td className="py-2 font-sans font-bold text-[#172626]">{row.label}</td>
                      <td className="py-2 text-right text-[#5E6B68]">{row.trainCount}</td>
                      <td className="py-2 text-right text-[#087E78]">{(row.precision * 100).toFixed(0)}%</td>
                      <td className="py-2 text-right text-[#087E78]">{(row.recall * 100).toFixed(0)}%</td>
                      <td className="py-2 text-right font-bold text-[#003B3A]">{(row.f1Score * 100).toFixed(0)}%</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <p className="text-[11px] text-[#5E6B68] italic pt-1">
              *Data eksperimen run awal sebelum diterapkannya fine-tuning Colab & class weights saat ini.
            </p>
          </div>

          {/* Research Limitations */}
          <div className="lg:col-span-5 bg-white p-5 rounded-2xl border border-[#DCE5E1] space-y-3">
            <div className="flex items-center gap-2 text-[#B42318]">
              <AlertTriangle className="w-4 h-4" />
              <h4 className="text-sm font-bold text-[#172626]">Keterbatasan Sistem Saat Ini</h4>
            </div>
            <ul className="space-y-2 text-xs text-[#5E6B68]">
              <li className="flex items-start gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-[#B42318] mt-1.5 flex-shrink-0" />
                <span><strong>Distorsi Fisik:</strong> Botol atau wadah plastik yang penyok parah dapat mengaburkan siluet kontur ciri khas polimer.</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-[#B42318] mt-1.5 flex-shrink-0" />
                <span><strong>Pencahayaan Ekstrem:</strong> Pantulan kilau cahaya (specular highlight) pada plastik bening kadang terbaca sebagai tekstur buram.</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-[#B42318] mt-1.5 flex-shrink-0" />
                <span><strong>Bias Label Kemasan:</strong> Model dapat salah fokus ke logo stiker kertas daripada badan botol plastik jika tidak memakai Grad-CAM verification.</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-[#B42318] mt-1.5 flex-shrink-0" />
                <span><strong>Objek Jamak:</strong> Model mengasumsikan satu objek dominan terpusat pada bidang pandang 224×224 piksel.</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>
  );
}
