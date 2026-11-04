"use client";

import React, { useState } from "react";
import { Camera, Sparkles, Loader2, AlertCircle, Info } from "lucide-react";
import { Dropzone } from "./Dropzone";
import { CameraModal } from "./CameraModal";
import { ResultPanel } from "./ResultPanel";
import { FeedbackModal } from "./FeedbackModal";
import { PredictionResult, ClassifierStatus } from "@/types/classifier";

export function ClassifierContainer() {
  const [status, setStatus] = useState<ClassifierStatus>("idle");
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [result, setResult] = useState<PredictionResult | null>(null);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [isCameraOpen, setIsCameraOpen] = useState(false);
  const [isFeedbackOpen, setIsFeedbackOpen] = useState(false);

  const handleFileSelected = (file: File) => {
    setSelectedFile(file);
    setStatus("ready");
    setErrorMsg(null);
  };

  const handleClear = () => {
    setSelectedFile(null);
    setResult(null);
    setStatus("idle");
    setErrorMsg(null);
  };

  const handleAnalyze = async () => {
    if (!selectedFile) return;

    setStatus("analyzing");
    setErrorMsg(null);

    const formData = new FormData();
    formData.append("file", selectedFile);

    try {
      const response = await fetch("/api/predict", {
        method: "POST",
        body: formData,
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || "Gagal mengklasifikasikan citra.");
      }

      const data: PredictionResult = await response.json();
      setResult(data);
      setStatus("success");
    } catch (err: unknown) {
      const e = err as Error;
      setErrorMsg(e.message || "Terjadi gangguan saat memproses prediksi.");
      setStatus("error");
    }
  };

  return (
    <section id="classifier" className="py-16 md:py-24 px-4 sm:px-6 lg:px-8 max-w-4xl mx-auto">
      {/* Header section */}
      <div className="text-center space-y-3 mb-10">
        <div className="inline-flex items-center gap-2 px-3 py-1 bg-[#087E78]/10 text-[#087E78] rounded-full text-xs font-bold uppercase tracking-wider">
          <Sparkles className="w-3.5 h-3.5" />
          <span>Interactive Model Testing</span>
        </div>
        <h2 className="text-3xl sm:text-4xl font-extrabold text-[#172626] font-sans">
          Uji Klasifikasi Sampah Plastik
        </h2>
        <p className="text-sm sm:text-base text-[#5E6B68] max-w-xl mx-auto leading-relaxed">
          Unggah foto atau gunakan kamera langsung untuk mendeteksi kategori polimer (PET, HDPE, PVC, LDPE, PP, PS, Other).
        </p>
      </div>

      {/* Main card */}
      <div className="bg-[#FFFFFF] rounded-3xl p-6 sm:p-8 border border-[#DCE5E1] shadow-xl space-y-6">
        {status !== "success" ? (
          <div className="space-y-6">
            <Dropzone
              onFileSelected={handleFileSelected}
              selectedFile={selectedFile}
              onClear={handleClear}
              disabled={status === "analyzing"}
            />

            {/* Quick action bar */}
            <div className="flex flex-wrap items-center justify-between gap-3 pt-2">
              <button
                type="button"
                onClick={() => setIsCameraOpen(true)}
                disabled={status === "analyzing"}
                className="px-4 py-2.5 bg-[#F7F7F2] hover:bg-[#EAEAE0] text-[#172626] border border-[#DCE5E1] rounded-xl text-xs font-semibold flex items-center gap-2 transition-colors disabled:opacity-50"
              >
                <Camera className="w-4 h-4 text-[#087E78]" />
                <span>Gunakan Kamera Langsung</span>
              </button>

              <button
                type="button"
                onClick={handleAnalyze}
                disabled={!selectedFile || status === "analyzing"}
                className="px-6 py-3 bg-[#087E78] hover:bg-[#004B49] text-white rounded-xl text-sm font-bold flex items-center gap-2 shadow-md hover:shadow-lg transition-all disabled:opacity-40 disabled:cursor-not-allowed"
              >
                {status === "analyzing" ? (
                  <>
                    <Loader2 className="w-4 h-4 animate-spin text-[#F4B323]" />
                    <span>Menganalisis Citra (224×224)...</span>
                  </>
                ) : (
                  <>
                    <Sparkles className="w-4 h-4 text-[#F4B323]" />
                    <span>Klasifikasi Sekarang</span>
                  </>
                )}
              </button>
            </div>

            {errorMsg && (
              <div className="p-4 bg-[#B42318]/10 border border-[#B42318]/30 rounded-xl text-xs text-[#B42318] flex items-center gap-2">
                <AlertCircle className="w-4 h-4 flex-shrink-0" />
                <span>{errorMsg}</span>
              </div>
            )}

            {/* Academic note */}
            <div className="p-3 bg-[#F7F7F2] rounded-xl border border-[#DCE5E1] flex items-start gap-2 text-xs text-[#5E6B68]">
              <Info className="w-4 h-4 text-[#087E78] flex-shrink-0 mt-0.5" />
              <span>
                Catatan: Model saat ini berada pada tahap pelatihan di Google Colab (~70% akurasi). Output klasifikasi disajikan dalam <strong>Mode Demo</strong> transparan untuk pengujian antarmuka.
              </span>
            </div>
          </div>
        ) : (
          result && (
            <ResultPanel
              result={result}
              selectedFile={selectedFile}
              onReset={handleClear}
              onOpenFeedback={() => setIsFeedbackOpen(true)}
            />
          )
        )}
      </div>

      <CameraModal
        isOpen={isCameraOpen}
        onClose={() => setIsCameraOpen(false)}
        onCapture={handleFileSelected}
      />

      {result && (
        <FeedbackModal
          isOpen={isFeedbackOpen}
          onClose={() => setIsFeedbackOpen(false)}
          predictionId={result.id}
          predictedLabel={result.label}
          confidence={result.confidence}
        />
      )}
    </section>
  );
}
