/* eslint-disable @next/next/no-img-element */
"use client";

import React, { useRef, useState, useCallback, useEffect } from "react";
import { UploadCloud, Image as ImageIcon, X, AlertCircle } from "lucide-react";

interface DropzoneProps {
  onFileSelected: (file: File) => void;
  selectedFile: File | null;
  onClear: () => void;
  disabled?: boolean;
}

const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10 MB
const ACCEPTED_TYPES = ["image/jpeg", "image/png", "image/webp", "image/jpg"];

export function Dropzone({
  onFileSelected,
  selectedFile,
  onClear,
  disabled = false,
}: DropzoneProps) {
  const [isDragOver, setIsDragOver] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // Bersihkan preview URL saat unmount
  useEffect(() => {
    return () => {
      if (previewUrl) {
        URL.revokeObjectURL(previewUrl);
      }
    };
  }, [previewUrl]);

  const validateAndHandleFile = useCallback(
    (file: File) => {
      setErrorMsg(null);

      if (!ACCEPTED_TYPES.includes(file.type)) {
        setErrorMsg("Format berkas tidak didukung. Harap unggah citra format JPEG, PNG, atau WebP.");
        return;
      }

      if (file.size > MAX_FILE_SIZE) {
        setErrorMsg("Ukuran berkas melebihi batas 10MB. Harap gunakan foto dengan resolusi lebih kecil.");
        return;
      }

      if (previewUrl) {
        URL.revokeObjectURL(previewUrl);
      }
      const url = URL.createObjectURL(file);
      setPreviewUrl(url);
      onFileSelected(file);
    },
    [onFileSelected, previewUrl]
  );

  const handleClear = useCallback(() => {
    if (previewUrl) {
      URL.revokeObjectURL(previewUrl);
      setPreviewUrl(null);
    }
    setErrorMsg(null);
    onClear();
  }, [previewUrl, onClear]);

  const handleDrop = useCallback(
    (e: React.DragEvent<HTMLDivElement>) => {
      e.preventDefault();
      setIsDragOver(false);
      if (disabled) return;

      if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
        validateAndHandleFile(e.dataTransfer.files[0]);
      }
    },
    [disabled, validateAndHandleFile]
  );

  const handleDragOver = useCallback((e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    setIsDragOver(true);
  }, []);

  const handleDragLeave = useCallback((e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    setIsDragOver(false);
  }, []);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      validateAndHandleFile(e.target.files[0]);
    }
  };

  return (
    <div className="w-full space-y-3">
      {/* Container Dropzone / Preview */}
      <div
        onDrop={handleDrop}
        onDragOver={handleDragOver}
        onDragLeave={handleDragLeave}
        className={`relative rounded-2xl border-2 border-dashed transition-all p-6 flex flex-col items-center justify-center text-center cursor-pointer min-h-[260px] ${
          isDragOver
            ? "border-[#087E78] bg-[#087E78]/10 scale-[1.01]"
            : "border-[#DCE5E1] bg-white hover:border-[#087E78]/60 hover:bg-[#F7F7F2]"
        } ${disabled ? "opacity-60 cursor-not-allowed" : ""}`}
        onClick={() => {
          if (!disabled && !selectedFile && fileInputRef.current) {
            fileInputRef.current.click();
          }
        }}
      >
        <input
          ref={fileInputRef}
          type="file"
          accept="image/jpeg,image/png,image/webp"
          className="hidden"
          onChange={handleInputChange}
          disabled={disabled}
        />

        {selectedFile && previewUrl ? (
          <div className="relative w-full flex flex-col items-center">
            <div className="relative max-h-64 max-w-full rounded-xl overflow-hidden shadow-md border border-[#DCE5E1]">
              <img
                src={previewUrl}
                alt="Preview Sampah Plastik"
                className="max-h-64 w-auto object-contain"
              />
              <button
                type="button"
                onClick={(e) => {
                  e.stopPropagation();
                  handleClear();
                }}
                disabled={disabled}
                className="absolute top-2 right-2 p-1.5 bg-[#172626]/80 hover:bg-[#B42318] text-white rounded-full transition-colors shadow-lg"
                title="Hapus foto"
                aria-label="Hapus foto"
              >
                <X className="w-4 h-4" />
              </button>
            </div>
            <p className="mt-3 text-xs text-[#5E6B68] font-medium">
              {selectedFile.name} ({(selectedFile.size / 1024).toFixed(0)} KB)
            </p>
          </div>
        ) : (
          <div className="flex flex-col items-center space-y-3 py-4">
            <div className="w-14 h-14 rounded-full bg-[#087E78]/10 flex items-center justify-center text-[#087E78]">
              <UploadCloud className="w-7 h-7" />
            </div>
            <div>
              <p className="text-sm font-semibold text-[#172626]">
                Tarik & letakkan foto sampah plastik ke sini
              </p>
              <p className="text-xs text-[#5E6B68] mt-1">
                atau klik untuk memilih dari perangkat (JPEG, PNG, WebP hingga 10MB)
              </p>
            </div>
            <div className="inline-flex items-center gap-1.5 px-3 py-1 bg-[#F7F7F2] rounded-full border border-[#DCE5E1] text-[11px] text-[#5E6B68]">
              <ImageIcon className="w-3.5 h-3.5" />
              <span>Input model: 224 × 224 RGB</span>
            </div>
          </div>
        )}
      </div>

      {/* Pesan Kesalahan */}
      {errorMsg && (
        <div className="flex items-center gap-2 p-3 bg-[#B42318]/10 border border-[#B42318]/30 text-[#B42318] rounded-xl text-xs">
          <AlertCircle className="w-4 h-4 flex-shrink-0" />
          <span>{errorMsg}</span>
        </div>
      )}
    </div>
  );
}
