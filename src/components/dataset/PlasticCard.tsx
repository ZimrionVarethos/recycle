"use client";

import React, { useState } from "react";
import { PlasticDetail } from "@/types/plastic";
import { ChevronDown, ChevronUp, CheckCircle, Shield } from "lucide-react";

interface PlasticCardProps {
  detail: PlasticDetail;
}

export function PlasticCard({ detail }: PlasticCardProps) {
  const [isExpanded, setIsExpanded] = useState(false);

  const levelColor = {
    high: "bg-[#247A53]/10 text-[#247A53] border-[#247A53]/30",
    medium: "bg-[#087E78]/10 text-[#087E78] border-[#087E78]/30",
    low: "bg-[#F4B323]/20 text-[#D99A0B] border-[#F4B323]/50",
    hazardous: "bg-[#B42318]/10 text-[#B42318] border-[#B42318]/30",
  }[detail.recyclabilityLevel];

  return (
    <div className="bg-white rounded-2xl border border-[#DCE5E1] p-5 shadow-xs hover:shadow-md transition-all flex flex-col justify-between">
      <div>
        <div className="flex items-start justify-between gap-3 mb-3">
          <div className="flex items-center gap-2.5">
            <span className="w-10 h-10 rounded-xl bg-[#003B3A] text-[#F4B323] flex items-center justify-center font-bold text-base shadow-xs">
              {detail.code}
            </span>
            <div>
              <h4 className="font-bold text-lg text-[#172626] font-sans">
                {detail.label}
              </h4>
              <p className="text-xs text-[#5E6B68] font-medium truncate max-w-[160px] sm:max-w-xs">
                {detail.fullName}
              </p>
            </div>
          </div>

          <span className={`px-2.5 py-1 rounded-full text-[11px] font-semibold border ${levelColor}`}>
            {detail.recyclability}
          </span>
        </div>

        <p className="text-xs text-[#172626]/80 leading-relaxed line-clamp-3 mb-3">
          {detail.description}
        </p>

        {/* Dataset Count Badge */}
        <div className="flex items-center justify-between text-xs py-2 px-3 bg-[#F7F7F2] rounded-xl border border-[#DCE5E1] mb-3">
          <span className="text-[#5E6B68]">Citra Latih Dataset:</span>
          <div className="flex items-center gap-1.5 font-bold font-mono text-[#087E78]">
            <span>{detail.datasetCount} citra</span>
            {detail.isMinorityClass && (
              <span className="px-1.5 py-0.5 bg-[#F4B323]/20 text-[#D99A0B] rounded text-[10px] font-sans font-bold">
                Kelas Minoritas
              </span>
            )}
          </div>
        </div>

        {/* Expanded Info */}
        {isExpanded && (
          <div className="space-y-3 pt-2 text-xs border-t border-[#DCE5E1] animate-in fade-in duration-200">
            <div>
              <span className="font-bold text-[#172626] block mb-1">Contoh Produk Umum:</span>
              <ul className="list-disc list-inside space-y-0.5 text-[#5E6B68]">
                {detail.commonProducts.map((p, idx) => (
                  <li key={idx}>{p}</li>
                ))}
              </ul>
            </div>

            <div className="p-2.5 bg-[#087E78]/5 rounded-lg border border-[#087E78]/20">
              <span className="font-bold text-[#087E78] flex items-center gap-1 mb-1">
                <CheckCircle className="w-3.5 h-3.5" /> Cara Daur Ulang:
              </span>
              <p className="text-[#172626]">{detail.recyclingInstructions}</p>
            </div>

            <div className="p-2.5 bg-[#F4B323]/10 rounded-lg border border-[#F4B323]/30">
              <span className="font-bold text-[#D99A0B] flex items-center gap-1 mb-1">
                <Shield className="w-3.5 h-3.5" /> Keamanan:
              </span>
              <p className="text-[#172626]">{detail.safetyNote}</p>
            </div>
          </div>
        )}
      </div>

      <button
        type="button"
        onClick={() => setIsExpanded(!isExpanded)}
        className="mt-3 pt-2 w-full text-center text-xs font-semibold text-[#087E78] hover:text-[#004B49] flex items-center justify-center gap-1 border-t border-[#DCE5E1]/60"
      >
        <span>{isExpanded ? "Sembunyikan Rincian" : "Lihat Rincian & Karakteristik"}</span>
        {isExpanded ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
      </button>
    </div>
  );
}
