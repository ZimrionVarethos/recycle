import { NextRequest, NextResponse } from "next/server";
import { simulateInference } from "@/lib/ml/mock-engine";
import { getSupabaseServerClient } from "@/lib/supabase/server";
import { PLASTIC_CLASSES } from "@/config/plastics";
import { PlasticClass } from "@/types/plastic";

export async function POST(req: NextRequest) {
  try {
    const formData = await req.formData();
    const file = formData.get("file") as File | null;

    if (!file) {
      return NextResponse.json(
        { error: "File gambar tidak ditemukan dalam request." },
        { status: 400 }
      );
    }

    // Validasi tipe file
    const validTypes = ["image/jpeg", "image/png", "image/webp", "image/jpg"];
    if (!validTypes.includes(file.type)) {
      return NextResponse.json(
        { error: "Format gambar tidak didukung. Harap gunakan JPEG, PNG, atau WebP." },
        { status: 400 }
      );
    }

    // Validasi ukuran file (maks 10MB)
    const MAX_SIZE = 10 * 1024 * 1024;
    if (file.size > MAX_SIZE) {
      return NextResponse.json(
        { error: "Ukuran gambar terlalu besar. Maksimum 10MB." },
        { status: 400 }
      );
    }

    const mlApiUrl = process.env.ML_API_URL || process.env.NEXT_PUBLIC_ML_API_URL;
    let predictionResult;

    if (mlApiUrl && mlApiUrl.trim() !== "") {
      try {
        const externalFormData = new FormData();
        externalFormData.append("file", file);

        const response = await fetch(`${mlApiUrl.replace(/\/$/, "")}/predict`, {
          method: "POST",
          body: externalFormData,
          signal: AbortSignal.timeout(15000),
        });

        if (response.ok) {
          const data = await response.json();
          const matchedLabel = PLASTIC_CLASSES.find(
            (c) => c.toUpperCase() === (data.label || "").toUpperCase()
          ) as PlasticClass || "Other";

          predictionResult = {
            id: `pred_${Date.now()}`,
            label: matchedLabel,
            confidence: Number(data.confidence || 0.8),
            probabilities: data.probabilities || { [matchedLabel]: 1 },
            inferenceTimeMs: data.inference_time_ms || 45,
            modelUsed: "MobileNetV2" as const,
            isDemo: false,
            gradcamUrl: data.gradcam_url || null,
            timestamp: new Date().toISOString(),
          };
        }
      } catch (err) {
        console.warn("ML API backend error, beralih ke mode demo:", err);
      }
    }

    // Jika ML API tidak diset atau gagal, gunakan simulateInference (Demo Mode)
    if (!predictionResult) {
      predictionResult = await simulateInference(file.name);
    }

    // Asynchronously log ke Supabase jika terkonfigurasi (tanpa menyimpan file gambar)
    const supabase = getSupabaseServerClient();
    if (supabase) {
      supabase
        .from("classification_logs")
        .insert({
          predicted_label: predictionResult.label,
          confidence: predictionResult.confidence,
          model_name: predictionResult.modelUsed,
          is_demo: predictionResult.isDemo,
          inference_time_ms: predictionResult.inferenceTimeMs,
          user_consent_logged: true,
        })
        .then(({ error }) => {
          if (error) console.warn("Supabase logging warning:", error.message);
        });
    }

    return NextResponse.json(predictionResult);
  } catch (error) {
    console.error("Predict route error:", error);
    return NextResponse.json(
      { error: "Terjadi kesalahan internal saat memproses citra." },
      { status: 500 }
    );
  }
}
