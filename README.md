# DEEP SORTING — Klasifikasi Sampah Plastik Berbasis CNN & Transfer Learning

Proyek penelitian akademik **Kelompok 7**, mata kuliah **Visual Komputer Cerdas**, Departemen Ilmu Komputer, **IPB University**.

Website ini menyediakan antarmuka interaktif untuk klasifikasi 7 kategori resin polimer plastik standar internasional (PET, HDPE, PVC, LDPE, PP, PS, dan Other) dengan arsitektur MobileNetV2 dan VGG16.

---

## 📌 Status Model & Prinsip Integritas ML

- **Status Pelatihan Saat Ini**: Model sedang dalam tahap iterasi pelatihan aktif di Google Colab dengan tingkat akurasi sekitar **70%**.
- **Kriteria Acceptance Rilis**: Target minimal akurasi **≥ 92%** pada held-out test set independen (tanpa data leakage) merupakan sasaran kelayakan rilis proyek, bukan hasil yang diklaim sudah tercapai.
- **Mode Demo (Mock)**: Bila `ML_API_URL` belum terhubung, antarmuka otomatis beroperasi dalam **Mode Demo (Simulasi)** dengan indikator visual yang jelas transparan.

---

## 🛠️ Tech Stack

- **Frontend**: Next.js 16 (App Router), React 19, TypeScript (Strict), Tailwind CSS v4, Lucide Icons.
- **Database & Data**: Supabase PostgreSQL dengan Row Level Security (RLS) untuk pencatatan log telemetri dan feedback ground-truth retraining.
- **ML Backbone**: MobileNetV2 & VGG16 (ImageNet pre-trained weights) dilatih pada Google Colab.
- **ML API Host**: Python FastAPI / Gradio (deploy terpisah dari Next.js).

---

## 🚀 Memulai (Quickstart)

### 1. Prasyarat
- Node.js versi 18+ (direkomendasikan v20 / v22)
- npm, pnpm, atau yarn

### 2. Instalasi Dependensi
```bash
npm install
```

### 3. Konfigurasi Environment Variables
Salin berkas contoh konfigurasi:
```bash
cp .env.example .env.local
```
Sesuaikan variabel berikut sesuai kebutuhan:
```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key # Server-side only
ML_API_URL=https://your-python-fastapi.com # Opsional, jika kosong website berjalan di Mode Demo
```

### 4. Menjalankan Server Pengembangan
```bash
npm run dev
```
Buka browser pada `http://localhost:3000`.

### 5. Typecheck & Build Produksi
```bash
npm run typecheck
npm run lint
npm run build
```

---

## 🗄️ Setup Supabase & Migrasi Database

Skema SQL dengan RLS telah disediakan di `supabase/migrations/00001_initial_schema.sql`.

1. Buka dashboard proyek Anda di [Supabase](https://supabase.com).
2. Masuk ke menu **SQL Editor**.
3. Jalankan isi berkas `supabase/migrations/00001_initial_schema.sql`.
4. RLS akan aktif secara otomatis:
   - Pengunjung publik dapat mengirim log klasifikasi anonim dan feedback koreksi label.
   - Hak baca log agregat dibatasi untuk service role.
   - Privasi terjaga: foto pengguna **tidak disimpan** ke database secara default.

---

## 🐍 Integrasi Backend Python ML API (FastAPI)

Untuk menghubungkan model hasil export Colab (`.keras` / `.h5`), siapkan endpoint FastAPI minimal berikut:

```python
from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
import numpy as np
from PIL import Image

app = FastAPI(title="Deep Sorting ML API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

CLASSES = ["PET", "HDPE", "PVC", "LDPE", "PP", "PS", "Other"]

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    img = Image.open(file.file).convert("RGB").resize((224, 224))
    # Preprocess & run model inference
    # ...
    return {
        "label": "PET",
        "confidence": 0.88,
        "probabilities": {"PET": 0.88, "HDPE": 0.04, "PVC": 0.01, "LDPE": 0.03, "PP": 0.02, "PS": 0.01, "Other": 0.01},
        "inference_time_ms": 38,
        "gradcam_url": None
    }
```

---

## 🌐 Deployment Vercel

1. Push repository ke GitHub.
2. Impor proyek di dashboard [Vercel](https://vercel.com).
3. Masukkan Environment Variables (`NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `ML_API_URL`).
4. Klik **Deploy**.
