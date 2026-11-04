"use client";

import React, { useState } from "react";
import { X, Check, Send, AlertCircle } from "lucide-react";
import { PlasticClass } from "@/types/plastic";
import { PLASTIC_CLASSES } from "@/config/plastics";

interface FeedbackModalProps {
  isOpen: boolean;
  onClose: () => void;
  predictionId: string;
  predictedLabel: PlasticClass;
  confidence: number;
}

export function FeedbackModal({
  isOpen,
  onClose,
  predictionId,
  predictedLabel,
  confidence,
}: FeedbackModalProps) {
  const [selectedLabel, setSelectedLabel] = useState<PlasticClass>(predictedLabel);
  const [notes, setNotes] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [successMsg, setSuccessMsg] = useState<string | null>(null);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  if (!isOpen) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setErrorMsg(null);
    setSuccessMsg(null);

    try {
      const res = await fetch("/api/feedback", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          predictionId,
          predictedLabel,
          correctedLabel: selectedLabel,
          confidence,
          notes,
        }),
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data.error || "Gagal mengirimkan koreksi.");

      setSuccessMsg(data.message || "Koreksi berhasil dikirim!");
      setTimeout(() => {
        onClose();
      }, 1600);
    } catch (err: unknown) {
      const e = err as Error;
      setErrorMsg(e.message || "Terjadi kesalahan koneksi.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-xs flex items-center justify-center p-4 animate-in fade-in duration-200">
      <div className="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl border border-[#DCE5E1] space-y-4">
        <div className="flex items-center justify-between pb-3 border-b border-[#DCE5E1]">
          <h3 className="font-bold text-base text-[#172626]">
            Koreksi Label Sampah Plastik
          </h3>
          <button
            onClick={onClose}
            className="p-1 hover:bg-[#F7F7F2] rounded-full text-[#5E6B68]"
            aria-label="Tutup"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        <p className="text-xs text-[#5E6B68] leading-relaxed">
          Bantu tim peneliti IPB University menyempurnakan dataset dengan memberikan koreksi label sebenarnya (Ground Truth) untuk retraining model CNN.
        </p>

        {successMsg ? (
          <div className="p-4 bg-[#247A53]/10 border border-[#247A53]/30 rounded-xl text-center text-xs text-[#247A53] font-semibold flex items-center justify-center gap-2">
            <Check className="w-4 h-4" />
            <span>{successMsg}</span>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-xs font-semibold text-[#172626] mb-1.5">
                Pilih Jenis Plastik yang Benar:
              </label>
              <div className="grid grid-cols-4 gap-2">
                {PLASTIC_CLASSES.map((cls) => (
                  <button
                    key={cls}
                    type="button"
                    onClick={() => setSelectedLabel(cls)}
                    className={`py-2 px-1 text-xs font-bold rounded-lg border transition-all ${
                      selectedLabel === cls
                        ? "bg-[#087E78] text-white border-[#087E78] shadow-xs"
                        : "bg-[#F7F7F2] text-[#172626] border-[#DCE5E1] hover:bg-white"
                    }`}
                  >
                    {cls}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <label className="block text-xs font-semibold text-[#172626] mb-1">
                Catatan Tambahan (Opsional):
              </label>
              <textarea
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                placeholder="Misal: Botol kemasan minyak goreng merk X, kondisi agak kusam/terlipat..."
                rows={3}
                className="w-full p-2.5 text-xs bg-[#F7F7F2] border border-[#DCE5E1] rounded-xl focus:outline-none focus:ring-1 focus:ring-[#087E78]"
              />
            </div>

            {errorMsg && (
              <div className="flex items-center gap-2 p-2 bg-[#B42318]/10 text-[#B42318] text-xs rounded-lg">
                <AlertCircle className="w-4 h-4" />
                <span>{errorMsg}</span>
              </div>
            )}

            <div className="flex items-center justify-end gap-2 pt-2">
              <button
                type="button"
                onClick={onClose}
                className="px-4 py-2 text-xs font-semibold text-[#5E6B68] hover:bg-[#F7F7F2] rounded-xl"
              >
                Batal
              </button>
              <button
                type="submit"
                disabled={isSubmitting}
                className="px-5 py-2 bg-[#087E78] hover:bg-[#004B49] text-white text-xs font-bold rounded-xl flex items-center gap-1.5 shadow disabled:opacity-50"
              >
                <Send className="w-3.5 h-3.5" />
                <span>{isSubmitting ? "Mengirim..." : "Kirim Koreksi"}</span>
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}
