"use client";

import React, { useRef, useState, useEffect, useCallback } from "react";
import { Camera, X, RefreshCw, AlertCircle } from "lucide-react";

interface CameraModalProps {
  isOpen: boolean;
  onClose: () => void;
  onCapture: (file: File) => void;
}

export function CameraModal({ isOpen, onClose, onCapture }: CameraModalProps) {
  const videoRef = useRef<HTMLVideoElement>(null);
  const [stream, setStream] = useState<MediaStream | null>(null);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [isInitializing, setIsInitializing] = useState(false);
  const [facingMode, setFacingMode] = useState<"environment" | "user">("environment");

  // Inisialisasi stream kamera asinkron saat modal dibuka
  useEffect(() => {
    if (!isOpen) return;

    let active = true;
    let localStream: MediaStream | null = null;

    async function initCamera() {
      setIsInitializing(true);
      setErrorMsg(null);

      try {
        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
          throw new Error("Perangkat peramban Anda tidak mendukung akses kamera langsung.");
        }

        const mediaStream = await navigator.mediaDevices.getUserMedia({
          video: {
            facingMode,
            width: { ideal: 1280 },
            height: { ideal: 720 },
          },
          audio: false,
        });

        if (!active) {
          mediaStream.getTracks().forEach((t) => t.stop());
          return;
        }

        localStream = mediaStream;
        setStream(mediaStream);

        if (videoRef.current) {
          videoRef.current.srcObject = mediaStream;
        }
      } catch (err: unknown) {
        if (!active) return;
        const e = err as Error;
        if (e.name === "NotAllowedError" || e.name === "PermissionDeniedError") {
          setErrorMsg("Izin kamera ditolak. Harap izinkan akses kamera pada peramban Anda.");
        } else if (e.name === "NotFoundError" || e.name === "DevicesNotFoundError") {
          setErrorMsg("Kamera tidak ditemukan pada perangkat Anda.");
        } else {
          setErrorMsg(e.message || "Gagal mengakses kamera perangkat.");
        }
      } finally {
        if (active) {
          setIsInitializing(false);
        }
      }
    }

    initCamera();

    return () => {
      active = false;
      if (localStream) {
        localStream.getTracks().forEach((track) => track.stop());
      }
      setStream((prev) => {
        if (prev) {
          prev.getTracks().forEach((t) => t.stop());
        }
        return null;
      });
    };
  }, [isOpen, facingMode]);

  // Hentikan semua track kamera manual
  const handleClose = useCallback(() => {
    if (stream) {
      stream.getTracks().forEach((t) => t.stop());
      setStream(null);
    }
    onClose();
  }, [stream, onClose]);

  // Tangkap gambar dari video feed
  const captureFrame = () => {
    if (!videoRef.current) return;
    const video = videoRef.current;

    const canvas = document.createElement("canvas");
    canvas.width = video.videoWidth || 640;
    canvas.height = video.videoHeight || 480;
    const ctx = canvas.getContext("2d");

    if (!ctx) return;
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

    canvas.toBlob((blob) => {
      if (!blob) return;
      const file = new File([blob], `capture_${Date.now()}.jpg`, {
        type: "image/jpeg",
      });
      handleClose();
      onCapture(file);
    }, "image/jpeg", 0.92);
  };

  const switchCamera = () => {
    setFacingMode((prev) => (prev === "environment" ? "user" : "environment"));
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4 animate-in fade-in duration-200">
      <div className="bg-[#003B3A] border border-white/20 rounded-2xl w-full max-w-lg overflow-hidden shadow-2xl flex flex-col">
        {/* Header */}
        <div className="p-4 border-b border-white/10 flex items-center justify-between text-white">
          <div className="flex items-center gap-2">
            <Camera className="w-5 h-5 text-[#F4B323]" />
            <h3 className="font-bold text-sm tracking-wide">Ambil Foto Sampah Plastik</h3>
          </div>
          <button
            onClick={handleClose}
            className="p-1.5 hover:bg-white/10 rounded-full transition-colors"
            aria-label="Tutup kamera"
          >
            <X className="w-5 h-5 text-white/80" />
          </button>
        </div>

        {/* Viewfinder */}
        <div className="relative aspect-4/3 bg-black flex items-center justify-center overflow-hidden">
          {errorMsg ? (
            <div className="p-6 text-center max-w-xs text-white space-y-3">
              <AlertCircle className="w-10 h-10 text-[#F4B323] mx-auto" />
              <p className="text-xs text-white/90 leading-relaxed">{errorMsg}</p>
              <button
                onClick={() => setFacingMode((prev) => (prev === "environment" ? "user" : "environment"))}
                className="px-4 py-2 bg-white/20 hover:bg-white/30 rounded-xl text-xs font-semibold"
              >
                Coba Lagi
              </button>
            </div>
          ) : (
            <>
              <video
                ref={videoRef}
                autoPlay
                playsInline
                muted
                className="w-full h-full object-cover"
              />
              {/* Overlay target box for 224x224 framing */}
              <div className="absolute inset-0 pointer-events-none flex items-center justify-center">
                <div className="w-56 h-56 border-2 border-dashed border-[#F4B323]/80 rounded-2xl flex flex-col justify-between p-2 shadow-[0_0_0_9999px_rgba(0,0,0,0.35)]">
                  <span className="text-[10px] text-[#F4B323] font-mono tracking-wider bg-black/60 px-1.5 py-0.5 rounded w-fit">
                    Target 224×224
                  </span>
                  <span className="text-[10px] text-white/80 font-mono text-right bg-black/60 px-1.5 py-0.5 rounded w-fit self-end">
                    Posisikan Objek
                  </span>
                </div>
              </div>
            </>
          )}
        </div>

        {/* Controls */}
        <div className="p-4 bg-[#002B2A] flex items-center justify-around">
          <button
            type="button"
            onClick={switchCamera}
            disabled={!!errorMsg || isInitializing}
            className="p-3 rounded-full bg-white/10 hover:bg-white/20 text-white transition-colors disabled:opacity-40"
            title="Balik Kamera"
            aria-label="Balik Kamera"
          >
            <RefreshCw className="w-5 h-5" />
          </button>

          <button
            type="button"
            onClick={captureFrame}
            disabled={!!errorMsg || isInitializing}
            className="w-16 h-16 rounded-full bg-[#F4B323] hover:bg-[#D99A0B] text-[#003B3A] flex items-center justify-center shadow-lg active:scale-95 transition-all disabled:opacity-40"
            title="Ambil Foto"
            aria-label="Ambil Foto"
          >
            <div className="w-12 h-12 rounded-full border-2 border-[#003B3A] flex items-center justify-center">
              <Camera className="w-6 h-6" />
            </div>
          </button>

          <div className="w-11" />
        </div>
      </div>
    </div>
  );
}
