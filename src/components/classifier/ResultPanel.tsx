"use client";

import React, { useState } from "react";
import {
  CheckCircle2,
  RotateCcw,
  Layers,
  MessageSquarePlus,
  ShieldAlert,
  Clock,
} from "lucide-react";
import { PredictionResult } from "@/types/classifier";
import { PLASTIC_DETAILS } from "@/config/plastics";
import { ProbabilityDistribution } from "./ProbabilityDistribution";
import { GradCamViewer } from "./GradCamViewer";

interface ResultPanelProps {
  result: PredictionResult;
  selectedFile: File | null;
  onReset: () => void;
  onOpenFeedback: () => void;
}

export function ResultPanel({
  result,
  selectedFile,
  onReset,
  onOpenFeedback,
}: ResultPanelProps) {
  const [showGradCam, setShowGradCam] = useState(false);
  const details = PLASTIC_DETAILS[result.label];
  const confidencePercent = (result.confidence * 100).toFixed(1);

  return (
    <div className="space-y-4 animate-in fade-in duration-300">
      {/* Kartu Hasil Utama */}
      <div className="bg-white rounded-2xl p-6 border-2 border-[#087E78]/30 shadow-lg relative overflow-hidden">
        {/* Top bar dengan Status Demo jika mode mock */}
        <div className="flex flex-wrap items-center justify-between gap-2 pb-4 border-b border-[#DCE5E1]">
          <div className="flex items-center gap-2">
            <span className="w-8 h-8 rounded-full bg-[#087E78] text-white flex items-center justify-center font-bold text-sm">
              {details.code}
            </span>
            <div>
              <span className="text-xs text-[#5E6B68] block">Kategori Polimer Terdeteksi</span>
              <h3 className="text-2xl font-bold text-[#172626] font-sans">
                Plastik {result.label}
              </h3>
            </div>
          </div>

          <div className="flex items-center gap-2">
            {result.isDemo && (
              <span className="px-2.5 py-1 rounded-full bg-[#F4B323]/20 border border-[#F4B323] text-[#D99A0B] text-xs font-bold uppercase tracking-wider">
                Mode Demo (Simulasi)
              </span>
            )}
            <div className="text-right">
              <span className="text-xs text-[#5E6B68] block">Tingkat Keyakinan</span>
              <span className="text-lg font-bold text-[#087E78] font-mono">
                {confidencePercent}%
              </span>
            </div>
          </div>
        </div>

        {/* Detail Kimia & Karakteristik */}
        <div className="py-4 space-y-3">
          <p className="text-sm text-[#172626] font-medium leading-relaxed">
            {details.description}
          </p>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs pt-1">
            <div className="p-3 bg-[#F7F7F2] rounded-xl border border-[#DCE5E1]">
              <span className="text-[#5E6B68] font-medium block">Nama Ilmiah:</span>
              <span className="font-semibold text-[#172626]">{details.fullName}</span>
            </div>
            <div className="p-3 bg-[#F7F7F2] rounded-xl border border-[#DCE5E1]">
              <span className="text-[#5E6B68] font-medium block">Status Daur Ulang:</span>
              <span className="font-semibold text-[#087E78]">{details.recyclability}</span>
            </div>
          </div>

          {/* Panduan Pemilahan */}
          <div className="p-3.5 bg-[#087E78]/5 border border-[#087E78]/20 rounded-xl space-y-1.5 text-xs">
            <div className="flex items-center gap-1.5 text-[#087E78] font-bold">
              <CheckCircle2 className="w-4 h-4" />
              <span>Instruksi Penanganan & Pemilahan:</span>
            </div>
            <p className="text-[#172626] leading-relaxed">
              {details.recyclingInstructions}
            </p>
          </div>

          {/* Catatan Keselamatan */}
          <div className="p-3.5 bg-[#F4B323]/10 border border-[#F4B323]/30 rounded-xl space-y-1 text-xs">
            <div className="flex items-center gap-1.5 text-[#D99A0B] font-bold">
              <ShieldAlert className="w-4 h-4" />
              <span>Catatan Keamanan Penggunaan:</span>
            </div>
            <p className="text-[#172626] leading-relaxed">
              {details.safetyNote}
            </p>
          </div>
        </div>

        {/* Metadata Inferensi */}
        <div className="pt-3 border-t border-[#DCE5E1] flex flex-wrap items-center justify-between text-[11px] text-[#5E6B68] gap-2">
          <div className="flex items-center gap-3">
            <span className="flex items-center gap-1">
              <Clock className="w-3.5 h-3.5" />
              Waktu Inferensi: {result.inferenceTimeMs} ms
            </span>
            <span>•</span>
            <span>Arsitektur: {result.modelUsed}</span>
          </div>
          <button
            type="button"
            onClick={onOpenFeedback}
            className="flex items-center gap-1 text-[#087E78] hover:text-[#004B49] font-medium underline"
          >
            <MessageSquarePlus className="w-3.5 h-3.5" />
            <span>Koreksi Hasil Prediksi</span>
          </button>
        </div>
      </div>

      {/* Probabilitas Semua 7 Kelas */}
      <ProbabilityDistribution
        probabilities={result.probabilities}
        predictedLabel={result.label}
      />

      {/* Toggle Grad-CAM */}
      <div className="space-y-3">
        <button
          type="button"
          onClick={() => setShowGradCam(!showGradCam)}
          className="w-full py-2.5 px-4 bg-white hover:bg-[#F7F7F2] text-[#087E78] border border-[#087E78]/30 rounded-xl font-semibold text-xs flex items-center justify-center gap-2 transition-colors shadow-xs"
        >
          <Layers className="w-4 h-4" />
          <span>{showGradCam ? "Tutup Visualisasi Grad-CAM" : "Lihat Analisis Grad-CAM (Area Fokus CNN)"}</span>
        </button>

        {showGradCam && (
          <GradCamViewer
            imageFile={selectedFile}
            label={result.label}
            gradcamUrl={result.gradcamUrl}
          />
        )}
      </div>

      {/* Tombol Klasifikasi Ulang */}
      <button
        type="button"
        onClick={onReset}
        className="w-full py-3 bg-[#087E78] hover:bg-[#004B49] text-white rounded-xl font-bold text-sm flex items-center justify-center gap-2 shadow-md active:scale-98 transition-all"
      >
        <RotateCcw className="w-4 h-4" />
        <span>Uji Foto Sampah Plastik Lain</span>
      </button>
    </div>
  );
}
