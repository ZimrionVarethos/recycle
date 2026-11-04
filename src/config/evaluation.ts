import { ModelMetric, ProjectMilestone, ClassPerformance, ConfusionMatrixRow } from "@/types/evaluation";

export const PROJECT_MILESTONES: ProjectMilestone[] = [
  {
    stage: "Eksperimen Awal (Baseline Run)",
    status: "completed",
    accuracy: "40.3% - 64.3%",
    description:
      "Uji coba awal pada run sebelumnya: CNN Custom (40.3%), VGG16 (62.2%), dan MobileNetV2 (64.3%). Ditemukan kelemahan pada kelas minoritas (PS & Other) serta overfitting.",
    badge: "Hasil Eksperimen Awal",
  },
  {
    stage: "Pelatihan Berjalan (Google Colab)",
    status: "in-progress",
    accuracy: "~70.0%",
    description:
      "Iterasi aktif dengan penambahan data augmentation dinamis, transfer learning fine-tuning, balanced class weights, dan early stopping untuk mencegah memorization.",
    badge: "Fase Training Aktif",
  },
  {
    stage: "Target Kriteria Acceptance Rilis",
    status: "target",
    accuracy: "≥92.0%",
    description:
      "Batas minimum penerimaan proyek sebelum rilis resmi: minimal 92% akurasi dan Macro-F1 seimbang pada test-set terpisah (tanpa data leakage), ditambah uji citra lapangan nyata.",
    badge: "Target Acceptance",
  },
];

export const MODEL_METRICS: ModelMetric[] = [
  {
    name: "MobileNetV2 (Transfer Learning)",
    architecture: "MobileNetV2",
    historicalAccuracy: 0.643,
    macroF1: 0.628,
    parameters: "3.5M (Inverted Residuals)",
    strengths: [
      "Arsitektur sangat ringan dan efisien untuk deployment edge/web",
      "Waktu inferensi tercepat (~25-45 ms per citra)",
      "Generalisasi terbaik pada citra dengan variasi rotasi dan pencahayaan",
    ],
    weaknesses: [
      "Masih rentan false positive antara PET transparan dan LDPE bening",
      "Sensitif terhadap background bertekstur rumit tanpa cropping",
    ],
    isRecommended: true,
  },
  {
    name: "VGG16 (Transfer Learning)",
    architecture: "VGG16",
    historicalAccuracy: 0.622,
    macroF1: 0.597,
    parameters: "138M (Deep 3x3 Convolutions)",
    strengths: [
      "Ekstraksi fitur tekstur dan kontur tepi sangat tajam",
      "Performa tinggi pada kelas plastik buram dengan warna solid (HDPE)",
    ],
    weaknesses: [
      "Ukuran bobot model sangat besar (~500 MB)",
      "Inferensi lambat, konsumsi memori tinggi, rawan overfitting bila tanpa augmentasi intensif",
    ],
    isRecommended: false,
  },
  {
    name: "CNN Custom (Baseline 4-Layer)",
    architecture: "CNN Custom",
    historicalAccuracy: 0.403,
    macroF1: 0.362,
    parameters: "1.8M (Conv2D + MaxPool + Dense)",
    strengths: [
      "Struktur sederhana untuk memahami dasar ekstraksi fitur konvolusi dari nol",
      "Waktu training per epoch relatif singkat",
    ],
    weaknesses: [
      "Akurasi rendah karena dilatih dari scratch pada dataset kecil (1.331 citra)",
      "Gagal mengenali variasi bentuk plastik yang hancur atau terlipat",
    ],
    isRecommended: false,
  },
];

export const HISTORICAL_CLASS_PERFORMANCE: ClassPerformance[] = [
  { label: "PET", trainCount: 228, precision: 0.68, recall: 0.71, f1Score: 0.69 },
  { label: "HDPE", trainCount: 242, precision: 0.72, recall: 0.75, f1Score: 0.73 },
  { label: "PVC", trainCount: 198, precision: 0.61, recall: 0.58, f1Score: 0.59 },
  { label: "LDPE", trainCount: 211, precision: 0.64, recall: 0.62, f1Score: 0.63 },
  { label: "PP", trainCount: 170, precision: 0.63, recall: 0.60, f1Score: 0.61 },
  { label: "PS", trainCount: 96, precision: 0.52, recall: 0.48, f1Score: 0.50 },
  { label: "Other", trainCount: 186, precision: 0.56, recall: 0.53, f1Score: 0.54 },
];

export const CONFUSION_MATRIX_DATA: ConfusionMatrixRow[] = [
  { actual: "PET", predicted: { PET: 32, HDPE: 3, PVC: 2, LDPE: 5, PP: 2, PS: 0, Other: 1 } },
  { actual: "HDPE", predicted: { PET: 2, HDPE: 36, PVC: 1, LDPE: 4, PP: 3, PS: 1, Other: 1 } },
  { actual: "PVC", predicted: { PET: 3, HDPE: 2, PVC: 23, LDPE: 4, PP: 4, PS: 2, Other: 2 } },
  { actual: "LDPE", predicted: { PET: 6, HDPE: 3, PVC: 2, LDPE: 26, PP: 3, PS: 1, Other: 1 } },
  { actual: "PP", predicted: { PET: 3, HDPE: 4, PVC: 2, LDPE: 3, PP: 20, PS: 1, Other: 1 } },
  { actual: "PS", predicted: { PET: 1, HDPE: 2, PVC: 2, LDPE: 2, PP: 3, PS: 9, Other: 0 } },
  { actual: "Other", predicted: { PET: 2, HDPE: 3, PVC: 3, LDPE: 3, PP: 2, PS: 1, Other: 23 } },
];
