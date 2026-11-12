# DEEP SORTING — Aplikasi Mobile Klasifikasi Sampah Plastik (CNN & Transfer Learning)

Aplikasi mobile Flutter untuk klasifikasi 7 kategori resin polimer plastik standar internasional ASTM D7611 (`PET`, `HDPE`, `PVC`, `LDPE`, `PP`, `PS`, `Other`), dikembangkan oleh **Kelompok 7**, mata kuliah **Visual Komputer Cerdas**, Departemen Ilmu Komputer, **IPB University**.

---

## Status Model & Integritas ML

- **Status Pelatihan Saat Ini**: Iterasi pelatihan aktif di Google Colab berada di kisaran akurasi **~70%** (benchmark run awal: `MobileNetV2` 64.3%, `VGG16` 62.2%, `CNN Custom` 40.3% pada 1.331 citra; kelas minoritas `PS` 96 & `Other` 186).
- **Target Acceptance Rilis**: Target minimal **≥ 92%** akurasi pada held-out test set independen (bebas data leakage) & macro F1 ≥ 0.85 per kelas minoritas.
- **Mode Dummy Saat Pengembangan**: Sambil menunggu backend Python di-host, aplikasi berjalan dengan **Dummy Backend (ML Ringan On-Device 224×224 + Supabase)** berlabel jelas **`MODE DEMO`**.
- **Privasi**: Foto pengguna tidak pernah diunggah ke database Supabase secara default — hanya log prediksi anonim & koreksi label opsional.

---

## Fitur Utama Aplikasi

1. **Beranda (`HomePage`)**: Hero Neo-Brutalist + preview tempat sampah interaktif dengan animasi laser sweep & pin resin + katalog 7 kelas ASTM D7611 dengan tombol uji cepat.
2. **Scan (`ScanPage`)**: Input via Kamera, Galeri, atau Uji Sampel Cepat dengan 4 UI state eksplisit (`Empty`, `Ready`, `Loading`, `Error + Retry`) serta pemilih arsitektur (`MobileNetV2`, `VGG16`, `CNN Custom`).
3. **Halaman Detail Hasil (`ScanResultDetailPage`)**: Terbuka otomatis sebagai halaman baru tepat setelah klasifikasi (atau saat mengetuk blok di Riwayat). Menampilkan pratinjau Grad-CAM interaktif, confidence score bar, grafik probabilitas Softmax 7 kelas, panduan daur ulang, Inspektor JSON API, dan form koreksi label.
4. **Riwayat (`HistoryPage`)**: Daftar blok hasil scan lokal dengan filter kelas, hapus per item/semua, dan sinkronisasi riwayat ke/dari Supabase.
5. **Pengaturan (`SettingsPage`)**: Switch instan antara **Dummy Backend (ML Ringan + Supabase)** dan **Python FastAPI Backend**, tes koneksi `/health` & Supabase, pilih backbone default, tema (`Mode Hutan Gelap` / `Mode Lab Putih`), dan modal metodologi riset.

> Catatan arsitektur kode: Seluruh berkas source code Dart dipisah secara modular dengan batas **maksimal 300 baris per berkas**.

---

## Menjalankan Aplikasi Flutter

### Prasyarat
- Flutter SDK `>= 3.4` (Dart `>= 3.10`)
- Android Emulator / Perangkat fisik / Chrome (Web)

### Langkah Menjalankan
```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Atau menyuntikkan URL konfigurasi sejak build:
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=PYTHON_ML_URL=http://10.0.2.2:8000
```

---

## Setup Dummy Database (Supabase)

Jalankan kedua berkas migrasi di **SQL Editor** proyek Supabase Anda secara berurutan:
1. `supabase/migrations/00001_initial_schema.sql` — Membuat tabel `classification_logs` dan `classification_feedback` beserta kebijakan RLS dasar.
2. `supabase/migrations/00002_mobile_app_support.sql` — Menambahkan kolom `device_id`, `item_title`, `probabilities`, `source_backend`, serta policy baca riwayat milik perangkat sendiri.

Setelah itu masukkan **Project URL** dan **Anon Key** di menu **Pengaturan -> Supabase Dummy Backend**.

---

## Menghubungkan Backend Python (`ml-service/`)

Ketika backend Python (`ml-service/main.py`) sudah siap atau sudah di-host (Railway, Cloud Run, VPS, dll.):
1. Buka tab **Pengaturan**.
2. Pilih **Mode Backend Aktif -> Python FastAPI Backend**.
3. Masukkan Base URL server Python (mis. `https://api-anda.com` atau `http://10.0.2.2:8000` di emulator Android).
4. Tekan **Simpan & Tes `/health`**.
