"use client";

import React from "react";
import { Database, AlertTriangle, Layers, Info } from "lucide-react";
import { PLASTIC_CLASSES, PLASTIC_DETAILS } from "@/config/plastics";
import { PlasticCard } from "./PlasticCard";

export function DatasetSection() {
  return (
    <section id="dataset" className="py-16 md:py-24 bg-[#F7F7F2] border-t border-[#DCE5E1]">
      <div className="max-w-7xl mx-auto px-6 lg:px-12 space-y-12">
        {/* Header */}
        <div className="max-w-3xl space-y-4">
          <div className="inline-flex items-center gap-2 px-3 py-1 bg-[#087E78]/10 text-[#087E78] rounded-full text-xs font-bold uppercase tracking-wider">
            <Database className="w-3.5 h-3.5" />
            <span>Dataset Overview</span>
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-[#172626] font-sans">
            Plastic Classification Dataset
          </h2>
          <p className="text-sm sm:text-base text-[#5E6B68] leading-relaxed">
            Data primer penelitian terdiri dari <strong>1.331 citra latih</strong> terbagi ke dalam 7 kelas polimer plastik standar internasional dengan dimensi input konvolusi <strong>224 × 224 piksel</strong>.
          </p>
        </div>

        {/* Dataset Stats Cards */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="p-5 bg-white rounded-2xl border border-[#DCE5E1] shadow-xs">
            <span className="text-xs text-[#5E6B68] block">Total Citra Latih</span>
            <span className="text-3xl font-extrabold text-[#003B3A] font-mono mt-1 block">
              1.331
            </span>
            <span className="text-[11px] text-[#087E78] font-medium mt-1 block">
              Format citra RGB
            </span>
          </div>

          <div className="p-5 bg-white rounded-2xl border border-[#DCE5E1] shadow-xs">
            <span className="text-xs text-[#5E6B68] block">Resolusi Input Model</span>
            <span className="text-3xl font-extrabold text-[#003B3A] font-mono mt-1 block">
              224×224
            </span>
            <span className="text-[11px] text-[#5E6B68] font-medium mt-1 block">
              Standard ImageNet input
            </span>
          </div>

          <div className="p-5 bg-white rounded-2xl border border-[#DCE5E1] shadow-xs">
            <span className="text-xs text-[#5E6B68] block">Jumlah Kategori</span>
            <span className="text-3xl font-extrabold text-[#087E78] font-mono mt-1 block">
              7 Kelas
            </span>
            <span className="text-[11px] text-[#5E6B68] font-medium mt-1 block">
              Resin code 1 s/d 7
            </span>
          </div>

          <div className="p-5 bg-white rounded-2xl border border-[#DCE5E1] shadow-xs">
            <span className="text-xs text-[#5E6B68] block">Kelas Minoritas</span>
            <span className="text-3xl font-extrabold text-[#F4B323] font-mono mt-1 block">
              PS & Other
            </span>
            <span className="text-[11px] text-[#D99A0B] font-medium mt-1 block">
              Memerlukan Class Weights
            </span>
          </div>
        </div>

        {/* Class Imbalance Warning & Mitigation Banner */}
        <div className="p-5 bg-[#F4B323]/10 border border-[#F4B323]/30 rounded-2xl flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
          <div className="flex items-start gap-3">
            <AlertTriangle className="w-5 h-5 text-[#D99A0B] flex-shrink-0 mt-0.5" />
            <div className="space-y-1">
              <h4 className="text-sm font-bold text-[#172626]">
                Penanganan Ketimpangan Kelas (Class Imbalance)
              </h4>
              <p className="text-xs text-[#5E6B68] leading-relaxed max-w-2xl">
                Kelas <strong>PS (96 citra)</strong> dan <strong>Other (186 citra)</strong> memiliki jumlah sampel jauh lebih sedikit dibandingkan HDPE (242) dan PET (228). Tim menerapkan pembobotan fungsi kerugian (<strong>Balanced Class Weights</strong>) dan augmentasi khusus agar model tidak bias terhadap kelas mayoritas.
              </p>
            </div>
          </div>
          <div className="px-3 py-1.5 bg-white border border-[#DCE5E1] rounded-xl text-xs font-mono font-semibold text-[#003B3A] whitespace-nowrap">
            Scikit-learn compute_class_weight
          </div>
        </div>

        {/* 7 Class Cards Grid */}
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-bold text-[#172626] flex items-center gap-2">
              <Layers className="w-5 h-5 text-[#087E78]" />
              <span>7 Kategori Resin Plastik dalam Dataset</span>
            </h3>
            <span className="text-xs text-[#5E6B68]">Klik kartu untuk rincian</span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            {PLASTIC_CLASSES.map((cls) => (
              <PlasticCard key={cls} detail={PLASTIC_DETAILS[cls]} />
            ))}
          </div>
        </div>

        {/* Note on 'Other' class */}
        <div className="p-4 bg-white rounded-xl border border-[#DCE5E1] text-xs text-[#5E6B68] flex items-start gap-2.5">
          <Info className="w-4 h-4 text-[#087E78] flex-shrink-0 mt-0.5" />
          <p>
            <strong>Peringatan Lingkup Penelitian:</strong> Label <code>Other</code> pada aplikasi ini merujuk secara spesifik pada kategori plastik kode 7 (seperti polikarbonat, multilayer sachet, atau bioplastik). Model tidak dirancang untuk membedakan material non-plastik umum (seperti kertas, kain, logam, atau kaca).
          </p>
        </div>
      </div>
    </section>
  );
}
