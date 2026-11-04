"use client";

import React from "react";
import { PlasticClass } from "@/types/plastic";
import { PLASTIC_CLASSES, PLASTIC_DETAILS } from "@/config/plastics";

interface ProbabilityDistributionProps {
  probabilities: Record<PlasticClass, number>;
  predictedLabel: PlasticClass;
}

export function ProbabilityDistribution({
  probabilities,
  predictedLabel,
}: ProbabilityDistributionProps) {
  // Sort classes by probability descending
  const sortedClasses = [...PLASTIC_CLASSES].sort(
    (a, b) => (probabilities[b] || 0) - (probabilities[a] || 0)
  );

  return (
    <div className="space-y-3 p-4 bg-white rounded-xl border border-[#DCE5E1] shadow-xs">
      <div className="flex items-center justify-between">
        <h4 className="text-xs font-bold uppercase tracking-wider text-[#172626]">
          Distribusi Probabilitas Kelas (Softmax)
        </h4>
        <span className="text-[11px] text-[#5E6B68]">7 Kategori Polimer</span>
      </div>

      <div className="space-y-2 pt-1">
        {sortedClasses.map((cls) => {
          const prob = probabilities[cls] || 0;
          const percentage = (prob * 100).toFixed(1);
          const isWinner = cls === predictedLabel;
          const details = PLASTIC_DETAILS[cls];

          return (
            <div key={cls} className="space-y-1">
              <div className="flex items-center justify-between text-xs">
                <div className="flex items-center gap-1.5">
                  <span
                    className={`w-5 h-5 rounded-full flex items-center justify-center font-bold text-[10px] ${
                      isWinner
                        ? "bg-[#087E78] text-white"
                        : "bg-[#F7F7F2] text-[#5E6B68] border border-[#DCE5E1]"
                    }`}
                  >
                    {details.code}
                  </span>
                  <span
                    className={`font-semibold ${
                      isWinner ? "text-[#087E78]" : "text-[#172626]"
                    }`}
                  >
                    {cls}
                  </span>
                  <span className="text-[11px] text-[#5E6B68] hidden sm:inline">
                    ({details.fullName.split(" ")[0]})
                  </span>
                </div>
                <span
                  className={`font-mono text-xs ${
                    isWinner ? "font-bold text-[#087E78]" : "text-[#5E6B68]"
                  }`}
                >
                  {percentage}%
                </span>
              </div>

              {/* Progress bar */}
              <div className="h-2 w-full bg-[#F7F7F2] rounded-full overflow-hidden border border-[#DCE5E1]/60">
                <div
                  className={`h-full rounded-full transition-all duration-500 ${
                    isWinner
                      ? "bg-gradient-to-r from-[#087E78] to-[#2A9D8F]"
                      : "bg-[#087E78]/30"
                  }`}
                  style={{ width: `${Math.max(prob * 100, 1.5)}%` }}
                />
              </div>
            </div>
          );
        })}
      </div>
      <p className="text-[10px] text-[#5E6B68] italic pt-1 text-right">
        *Estimasi komparasi fitur citra, bukan calibrated statistical probability.
      </p>
    </div>
  );
}
