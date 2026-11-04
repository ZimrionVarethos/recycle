import { PlasticClass } from "@/types/plastic";
import { PredictionResult } from "@/types/classifier";
import { PLASTIC_CLASSES } from "@/config/plastics";

/**
 * Simulasi inferensi model untuk fase pengembangan (Mock Mode / Demo).
 * Menghasilkan probabilitas realistis dengan label Demo yang transparan.
 */
export async function simulateInference(
  fileName: string
): Promise<PredictionResult> {
  // Simulasi latency jaringan dan forward pass model di Colab/FastAPI
  const delayMs = 380 + Math.floor(Math.random() * 220);
  await new Promise((resolve) => setTimeout(resolve, delayMs));

  // Heuristik sederhana berdasarkan nama file atau acak tertimbang
  const lowerName = fileName.toLowerCase();
  let predictedClass: PlasticClass = "PET";

  if (lowerName.includes("hdpe") || lowerName.includes("jeriken") || lowerName.includes("shampoo")) {
    predictedClass = "HDPE";
  } else if (lowerName.includes("pvc") || lowerName.includes("pipa") || lowerName.includes("paralon")) {
    predictedClass = "PVC";
  } else if (lowerName.includes("ldpe") || lowerName.includes("kresek") || lowerName.includes("wrap")) {
    predictedClass = "LDPE";
  } else if (lowerName.includes("pp") || lowerName.includes("cup") || lowerName.includes("straw") || lowerName.includes("sedotan")) {
    predictedClass = "PP";
  } else if (lowerName.includes("ps") || lowerName.includes("styrofoam") || lowerName.includes("gabus")) {
    predictedClass = "PS";
  } else if (lowerName.includes("other") || lowerName.includes("sachet") || lowerName.includes("galon")) {
    predictedClass = "Other";
  } else {
    // Pilihan acak tertimbang (mencerminkan distribusi dataset)
    const weights: Record<PlasticClass, number> = {
      PET: 0.22,
      HDPE: 0.24,
      LDPE: 0.18,
      PP: 0.14,
      PVC: 0.10,
      Other: 0.08,
      PS: 0.04,
    };
    const r = Math.random();
    let cumulative = 0;
    for (const cls of PLASTIC_CLASSES) {
      cumulative += weights[cls];
      if (r <= cumulative) {
        predictedClass = cls;
        break;
      }
    }
  }

  // Generate probabilitas softmax realistis (~68% - 84% pada model ~70% saat ini)
  const topConfidence = 0.68 + Math.random() * 0.16;
  const remainingProb = 1 - topConfidence;

  const rawWeights: Record<string, number> = {};
  let totalRaw = 0;
  for (const cls of PLASTIC_CLASSES) {
    if (cls === predictedClass) continue;
    const w = 0.02 + Math.random() * 0.15;
    rawWeights[cls] = w;
    totalRaw += w;
  }

  const probabilities = {} as Record<PlasticClass, number>;
  probabilities[predictedClass] = Number(topConfidence.toFixed(4));

  for (const cls of PLASTIC_CLASSES) {
    if (cls === predictedClass) continue;
    const share = (rawWeights[cls] / totalRaw) * remainingProb;
    probabilities[cls] = Number(share.toFixed(4));
  }

  return {
    id: `pred_mock_${Date.now()}_${Math.random().toString(36).substring(2, 7)}`,
    label: predictedClass,
    confidence: Number(topConfidence.toFixed(4)),
    probabilities,
    inferenceTimeMs: 42 + Math.floor(Math.random() * 18),
    modelUsed: "MobileNetV2",
    isDemo: true,
    gradcamUrl: null,
    timestamp: new Date().toISOString(),
  };
}
