# Klasifikasi Jenis Plastik — backend (Docker) + app Flutter

1. Taruh `plastic_best.keras` dan `class_names.json` (dari notebook) di `backend/model/`.
2. Backend:   cd backend ; docker build -t klasifikasi-plastik . ; docker run -p 8000:8000 klasifikasi-plastik
   Uji:       http://localhost:8000/health  dan  http://localhost:8000/docs  (POST /classify)
3. App:       flutter create sampah_app ; cd sampah_app ; flutter pub add http image_picker
              ganti lib/main.dart dengan flutter/main.dart
              AndroidManifest.xml: tambah <uses-permission android:name="android.permission.INTERNET"/>
              dan android:usesCleartextTraffic="true" di tag <application>
4. Emulator: alamat server http://10.0.2.2:8000 ; HP asli: http://<IP-laptop>:8000 (satu Wi-Fi)

Catatan: tensorflow-cpu dikunci ke 2.21.0 = versi di Colab tempat model dilatih.
plastik_core.py disalin persis dari sel 1 notebook (preprocessing training = preprocessing server).
