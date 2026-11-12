# Deep Sorting ML Service (FastAPI & Google Colab)

Modul backend Python opsional untuk melatih dan menyajikan inferensi Convolutional Neural Networks (CNN) klasifikasi jenis sampah plastik (`PET`, `HDPE`, `PVC`, `LDPE`, `PP`, `PS`, `Other`).

> **Mode Testing Dummy**: Selama layanan Python ini belum di-host, aplikasi mobile Flutter tetap dapat dijalankan penuh menggunakan **Dummy Backend (ML Ringan On-Device 224×224 + Supabase)** dari menu **Pengaturan**.

---

## Alur Kerja Machine Learning

```text
[Dataset 1.331 Citra]
       │
       ▼
[Google Colab: train_colab.py]
  - MobileNetV2 (ImageNet)
  - Balanced Class Weights (PS 96, Other 186)
  - Data Augmentation & Early Stopping
       │
       ▼
[Artifact Model: deep_sorting_mobilenetv2.keras]
       │
       ▼
[FastAPI Backend: main.py] (Port 8000)
  - GET  /health
  - POST /predict (Input 224x224 RGB)
  - Softmax Probabilities (7 Kelas) + Grad-CAM Heatmap
       │
       ▼
[Flutter Mobile App: Deep Sorting]
  - Disambungkan lewat Pengaturan -> Python FastAPI Backend (PYTHON_ML_URL)
```

---

## 1. Menjalankan FastAPI Server Secara Lokal

```bash
cd ml-service
pip install -r requirements.txt
python main.py
```

Server aktif di `http://localhost:8000` (Swagger docs: `http://localhost:8000/docs`).

Untuk menguji dari **Android Emulator**, masukkan `http://10.0.2.2:8000` pada menu **Pengaturan -> Endpoint Python FastAPI** di aplikasi Flutter lalu tekan **Simpan & Tes `/health`**.

---

## 2. Pelatihan di Google Colab (`train_colab.py`)

1. Buka Google Colab dengan runtime **GPU T4**.
2. Unggah folder dataset berisi 7 sub-folder: `HDPE/`, `LDPE/`, `PET/`, `PP/`, `PS/`, `PVC/`, `Other/` ke `/content/dataset`.
3. Jalankan skrip pada [`train_colab.py`](file:///d:/recycle/ml-service/train_colab.py).
4. Letakkan berkas `deep_sorting_mobilenetv2.keras` hasil pelatihan ke dalam `ml-service/`.
