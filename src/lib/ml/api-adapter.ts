import { PredictionResult } from "@/types/classifier";
import { PlasticClass } from "@/types/plastic";
import { simulateInference } from "./mock-engine";
import { PLASTIC_CLASSES } from "@/config/plastics";

interface MLServerResponse {
  label: string;
  confidence: number;
  probabilities?: Record<string, number>;
  inference_time_ms?: number;
  gradcam_url?: string | null;
}

export async function executeClassification(
  file: File,
  signal?: AbortSignal
): Promise<PredictionResult> {
  const mlApiUrl = process.env.NEXT_PUBLIC_ML_API_URL;

  // Jika URL ML API tidak dikonfigurasi, gunakan Mode Demo / Mock
  if (!mlApiUrl || mlApiUrl.trim() === "") {
    return simulateInference(file.name);
  }

  const formData = new FormData();
  formData.append("file", file);

  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 12000);

    const mergedSignal = signal || controller.signal;

    const response = await fetch(`${mlApiUrl.replace(/\/$/, "")}/predict`, {
      method: "POST",
      body: formData,
      signal: mergedSignal,
    });

    clearTimeout(timeoutId);

    if (!response.ok) {
      console.warn(`ML API error status: ${response.status}. Fallback ke mode demo.`);
      return simulateInference(file.name);
    }

    const data: MLServerResponse = await response.json();

    // Validasi runtime apakah label dikenali
    const rawLabel = (data.label || "").toUpperCase();
    const matchedClass = PLASTIC_CLASSES.find(
      (c) => c.toUpperCase() === rawLabel
    ) as PlasticClass || "Other";

    // Siapkan probabilities mapping
    const probs: Record<PlasticClass, number> = {
      PET: 0, HDPE: 0, PVC: 0, LDPE: 0, PP: 0, PS: 0, Other: 0,
    };

    if (data.probabilities) {
      for (const cls of PLASTIC_CLASSES) {
        if (typeof data.probabilities[cls] === "number") {
          probs[cls] = data.probabilities[cls];
        }
      }
    } else {
      probs[matchedClass] = data.confidence;
    }

    return {
      id: `pred_real_${Date.now()}`,
      label: matchedClass,
      confidence: Math.min(Math.max(data.confidence, 0), 1),
      probabilities: probs,
      inferenceTimeMs: data.inference_time_ms || 45,
      modelUsed: "MobileNetV2",
      isDemo: false,
      gradcamUrl: data.gradcam_url || null,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    console.warn("Koneksi ML API gagal atau timeout. Mengalihkan ke mode demo:", error);
    return simulateInference(file.name);
  }
}
