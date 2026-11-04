# Prompt Utama — Website Klasifikasi Sampah Plastik

Baca `agent.md`, `skill.md`, `design.md`, dan `tech.md` sebelum coding. Gunakan `KELOMPOK_7.pdf` sebagai acuan kebutuhan dan desain.

## Konteks
Proyek Visual Komputer Cerdas IPB University: klasifikasi jenis sampah plastik dengan CNN dan transfer learning. Model masih training di Google Colab; akurasi saat ini sekitar 70%. Target tim adalah **minimal 92% sebelum rilis**. Target tersebut adalah kriteria proyek, bukan hasil yang sudah dicapai atau jaminan akan tercapai.

Kelas: HDPE, LDPE, PET, PP, PS, PVC, Other. `Other` adalah kelas dataset, bukan detektor semua benda non-plastik.

Data dari PDF:
- Plastic Classification Dataset, 1.331 citra latih.
- Kelas minoritas: PS 96 citra dan Other 186 citra.
- Input 224×224.
- Model pembanding: CNN custom, VGG16, MobileNetV2.
- Teknik: class weights, augmentasi, early stopping, macro-F1.
- Evaluasi: confusion matrix, Grad-CAM, uji kamera.
- Angka sebelumnya (run lama): MobileNetV2 64,3%, VGG16 62,2%, CNN custom 40,3%. Jangan jadikan angka ini hasil final.

## Tujuan website
- Landing page proyek akademik.
- Upload foto dan capture kamera (bila browser mendukung).
- Preview, loading, hasil klasifikasi, confidence, dan optional Grad-CAM.
- Halaman metodologi, dataset, model, evaluasi, dan keterbatasan.
- Supabase digunakan untuk database dan kebutuhan data aplikasi yang memang diperlukan.
- Website tetap dapat dikembangkan saat model belum final menggunakan mock mode yang jelas bertanda Demo.

## Prinsip ML
- Jangan mengklaim akurasi 92% sudah tercapai.
- Jangan membuat hasil prediction, metrics, confusion matrix, atau Grad-CAM fiktif.
- Sebelum rilis, definisikan metrik acceptance: minimal 92% pada test set yang benar-benar terpisah dan tidak dipakai training/tuning; sertakan macro-F1, per-class precision/recall, confusion matrix, serta uji foto lapangan. Jelaskan jika target 92% berlaku untuk accuracy atau metrik lain.
- Jangan mengoptimalkan test set berulang kali. Gunakan validation set untuk tuning dan test set final untuk evaluasi.
- Hindari data leakage, duplicate/near-duplicate images across splits, dan preprocessing mismatch.
- Target akurasi tidak boleh mengalahkan evaluasi yang jujur atau menyembunyikan performa kelas minoritas.

## Pekerjaan awal
1. Inspect repository dan package manager.
2. Baca semua file panduan.
3. Buat ringkasan rencana dan asumsi.
4. Jangan mengarang schema Supabase atau ML endpoint. Bila belum ada, siapkan migration/schema draft dan API adapter dengan placeholder yang terdokumentasi.
5. Jangan overwrite pekerjaan existing tanpa alasan.

## Implementasi
- Next.js App Router + TypeScript + Supabase.
- Vite tidak perlu digabung ke Next.js; Next.js memakai tooling sendiri. Jika Vite wajib, pisahkan sebagai app/tool tersendiri.
- UI, data access, API adapter, types, config harus dipisah.
- ML inference via Python API terpisah; jangan menjalankan training/inference berat di browser atau Vercel Function.
- Supabase secrets hanya server-side. RLS aktif untuk tabel yang menyimpan data user.
- Jangan simpan gambar secara default; gunakan storage hanya bila diperlukan dan dengan kebijakan privasi yang jelas.
- Tambahkan README setup, environment variables, Supabase setup, mock/real ML API, dan deployment.

## Acceptance
- Lint/typecheck/build berjalan atau jelaskan jika belum dapat dijalankan.
- Mobile + desktop responsif.
- Upload file divalidasi.
- Handle API timeout, unavailable, malformed response, dan error.
- Demo/mock terlihat jelas.
- Prediksi nyata hanya setelah ML API benar-benar terhubung.
- Dokumentasikan semua TODO dan asumsi.
