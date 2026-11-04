"use client";

import React from "react";
import { PLASTIC_CLASSES } from "@/config/plastics";
import { CONFUSION_MATRIX_DATA } from "@/config/evaluation";

export function ConfusionMatrixTable() {
  return (
    <div className="bg-white rounded-2xl p-5 border border-[#DCE5E1] space-y-4">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pb-2 border-b border-[#DCE5E1]">
        <div>
          <h4 className="text-sm font-bold text-[#172626]">
            Confusion Matrix (Evaluasi Baseline MobileNetV2)
          </h4>
          <p className="text-xs text-[#5E6B68]">
            Sumbu vertikal: Kelas Sebenarnya (Ground Truth) • Sumbu horizontal: Prediksi Model
          </p>
        </div>
        <span className="text-[11px] font-mono font-semibold bg-[#F7F7F2] px-2.5 py-1 rounded-md border border-[#DCE5E1] text-[#087E78]">
          Uji Evaluasi Validasi Awal
        </span>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full text-center border-collapse text-xs">
          <thead>
            <tr className="bg-[#003B3A] text-white">
              <th className="p-2 text-left font-semibold">Aktual \ Pred</th>
              {PLASTIC_CLASSES.map((cls) => (
                <th key={cls} className="p-2 font-bold font-mono">
                  {cls}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {CONFUSION_MATRIX_DATA.map((row) => {
              return (
                <tr key={row.actual} className="border-b border-[#DCE5E1] hover:bg-[#F7F7F2]">
                  <td className="p-2 text-left font-bold text-[#003B3A] bg-[#F7F7F2]/80">
                    {row.actual}
                  </td>
                  {PLASTIC_CLASSES.map((predCls) => {
                    const count = row.predicted[predCls] || 0;
                    const isDiagonal = row.actual === predCls;
                    return (
                      <td
                        key={predCls}
                        className={`p-2 font-mono ${
                          isDiagonal
                            ? "bg-[#087E78]/15 font-bold text-[#087E78]"
                            : count > 3
                            ? "bg-[#B42318]/10 text-[#B42318] font-semibold"
                            : "text-[#5E6B68]"
                        }`}
                      >
                        {count}
                      </td>
                    );
                  })}
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      <div className="flex flex-wrap items-center justify-between text-[11px] text-[#5E6B68] pt-1">
        <div className="flex items-center gap-3">
          <span className="flex items-center gap-1.5">
            <span className="w-3 h-3 bg-[#087E78]/20 border border-[#087E78] rounded-xs" />
            Diagonal Hijau: Prediksi Benar (True Positive)
          </span>
          <span className="flex items-center gap-1.5">
            <span className="w-3 h-3 bg-[#B42318]/20 border border-[#B42318] rounded-xs" />
            Merah: False Positive signifikan (misal PET vs LDPE bening)
          </span>
        </div>
      </div>
    </div>
  );
}
