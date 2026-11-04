# Deep Sorting ML Service (FastAPI & Google Colab)

Modul backend Python untuk melatih dan menyajikan inferensi Convolutional Neural Networks (CNN) klasifikasi jenis sampah plastik.

---

## 🚀 Alur Kerja Machine Learning

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
  - POST /predict (Input 224x224 RGB)
  - Softmax Probabilities (7 Kelas)
  - Grad-CAM Heatmap
       │
       ▼
[Next.js App Router (Vercel / Local)]
  - Disambungkan via ML_API_URL=http://localhost:8000
```

---

## 1. Menjalankan FastAPI Server Secara Lokal

### Instalasi Dependensi:
```bash
cd ml-service
pip install -r requirements.txt
```

### Menjalankan Server:
```bash
python main.py
```
Layanan akan aktif di `http://localhost:8000`. Dokumentasi Swagger OpenAPI tersedia di `http://localhost:8000/docs`.

### Uji Coba Endpoint:
```bash
curl -X POST "http://localhost:8000/predict" -F "file=@contoh_botol.jpg"
```

---

## 2. Pelatihan di Google Colab (`train_colab.py`)

1. Buka [Google Colab](https://colab.research.google.com).
2. Ubah runtime ke **GPU T4** (`Runtime` -> `Change runtime type` -> `T4 GPU`).
3. Unggah folder dataset yang berisi 7 sub-folder:
   `HDPE/`, `LDPE/`, `PET/`, `PP/`, `PS/`, `PVC/`, `Other/` ke `/content/dataset`.
4. Jalankan kode dari [`train_colab.py`](file:///d:/recycle/ml-service/train_colab.py).
5. Unduh berkas keluaran `deep_sorting_mobilenetv2.keras`.
6. Pindahkan berkas tersebut ke dalam folder `ml-service/` untuk disajikan oleh `main.py`.

---

## 3. Menghubungkan ke Next.js

Di berkas `.env.local` pada root proyek website, setel:
```env
ML_API_URL=http://localhost:8000
```
Website Next.js akan langsung mengalihkan inferensi dari Mode Demo ke model nyata secara otomatis.
