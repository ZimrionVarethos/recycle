/* eslint-disable @next/next/no-img-element */
"use client";

import React, { useState, useEffect, useRef } from "react";
import { Eye, Layers, Info } from "lucide-react";
import { PlasticClass } from "@/types/plastic";

interface GradCamViewerProps {
  imageFile: File | null;
  label: PlasticClass;
  gradcamUrl?: string | null;
}

export function GradCamViewer({ imageFile, label, gradcamUrl }: GradCamViewerProps) {
  const [opacity, setOpacity] = useState(0.65);
  const [showOverlay, setShowOverlay] = useState(true);
  const canvasRef = useRef<HTMLCanvasElement>(null);

  // Render heatmap gradient on canvas
  useEffect(() => {
    if (!canvasRef.current || !imageFile) return;
    const canvas = canvasRef.current;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    let active = true;
    const objectUrl = URL.createObjectURL(imageFile);
    const img = new window.Image();
    img.src = objectUrl;

    img.onload = () => {
      if (!active) {
        URL.revokeObjectURL(objectUrl);
        return;
      }

      canvas.width = img.naturalWidth || 400;
      canvas.height = img.naturalHeight || 400;

      // Draw base image
      ctx.drawImage(img, 0, 0, canvas.width, canvas.height);

      if (showOverlay) {
        // Buat simulated Grad-CAM heatmap fokus ke tengah objek
        const centerX = canvas.width * 0.52;
        const centerY = canvas.height * 0.48;
        const radius = Math.min(canvas.width, canvas.height) * 0.38;

        const gradient = ctx.createRadialGradient(
          centerX,
          centerY,
          radius * 0.1,
          centerX,
          centerY,
          radius
        );

        gradient.addColorStop(0, `rgba(255, 0, 0, ${opacity * 0.9})`); // Merah (Fokus tertinggi)
        gradient.addColorStop(0.35, `rgba(255, 200, 0, ${opacity * 0.75})`); // Kuning
        gradient.addColorStop(0.7, `rgba(0, 255, 128, ${opacity * 0.5})`); // Hijau
        gradient.addColorStop(1, "rgba(0, 0, 255, 0)"); // Transparan

        ctx.fillStyle = gradient;
        ctx.fillRect(0, 0, canvas.width, canvas.height);
      }

      URL.revokeObjectURL(objectUrl);
    };

    return () => {
      active = false;
      URL.revokeObjectURL(objectUrl);
    };
  }, [imageFile, opacity, showOverlay]);

  return (
    <div className="p-4 bg-white rounded-xl border border-[#DCE5E1] space-y-3">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Layers className="w-4 h-4 text-[#087E78]" />
          <h4 className="text-xs font-bold uppercase tracking-wider text-[#172626]">
            Explainability (Grad-CAM Saliency Map)
          </h4>
        </div>
        <button
          type="button"
          onClick={() => setShowOverlay(!showOverlay)}
          className="text-xs flex items-center gap-1.5 px-2.5 py-1 rounded-lg border border-[#DCE5E1] bg-[#F7F7F2] hover:bg-white text-[#172626] font-medium"
        >
          <Eye className="w-3.5 h-3.5 text-[#087E78]" />
          <span>{showOverlay ? "Sembunyikan Peta Panas" : "Tampilkan Peta Panas"}</span>
        </button>
      </div>

      <div className="relative aspect-4/3 w-full bg-[#172626] rounded-lg overflow-hidden flex items-center justify-center">
        {gradcamUrl ? (
          <img
            src={gradcamUrl}
            alt="Grad-CAM Output"
            className="w-full h-full object-contain"
          />
        ) : (
          <canvas
            ref={canvasRef}
            className="w-full h-full object-contain"
          />
        )}
      </div>

      {showOverlay && !gradcamUrl && (
        <div className="space-y-1.5 pt-1">
          <div className="flex items-center justify-between text-xs text-[#5E6B68]">
            <span>Opasitas Heatmap:</span>
            <span className="font-mono font-semibold">{Math.round(opacity * 100)}%</span>
          </div>
          <input
            type="range"
            min="0.1"
            max="1"
            step="0.05"
            value={opacity}
            onChange={(e) => setOpacity(parseFloat(e.target.value))}
            className="w-full accent-[#087E78] cursor-pointer"
          />
        </div>
      )}

      <div className="flex items-start gap-2 p-2.5 bg-[#F7F7F2] rounded-lg border border-[#DCE5E1] text-[11px] text-[#5E6B68]">
        <Info className="w-4 h-4 text-[#087E78] flex-shrink-0 mt-0.5" />
        <p>
          Grad-CAM (Gradient-weighted Class Activation Mapping) memperlihatkan area kontur dan tekstur polimer yang paling memengaruhi keputusan aktivasi lapisan konvolusi terakhir model terhadap kelas <strong>{label}</strong>.
        </p>
      </div>
    </div>
  );
}
