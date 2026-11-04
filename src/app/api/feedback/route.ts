import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServerClient } from "@/lib/supabase/server";
import { PLASTIC_CLASSES } from "@/config/plastics";

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { predictionId, predictedLabel, correctedLabel, confidence, notes } = body;

    if (!predictedLabel || !correctedLabel) {
      return NextResponse.json(
        { error: "Label prediksi dan koreksi wajib disertakan." },
        { status: 400 }
      );
    }

    if (!PLASTIC_CLASSES.includes(correctedLabel)) {
      return NextResponse.json(
        { error: "Label koreksi tidak valid." },
        { status: 400 }
      );
    }

    const supabase = getSupabaseServerClient();
    if (supabase) {
      const { error } = await supabase.from("classification_feedback").insert({
        prediction_id: predictionId || `anon_${Date.now()}`,
        predicted_label: predictedLabel,
        corrected_label: correctedLabel,
        confidence: typeof confidence === "number" ? confidence : null,
        notes: notes || null,
      });

      if (error) {
        console.warn("Supabase feedback insert error:", error.message);
        return NextResponse.json(
          { message: "Feedback diterima dalam mode lokal.", savedToDb: false },
          { status: 200 }
        );
      }

      return NextResponse.json(
        { message: "Terima kasih! Koreksi label berhasil dicatat untuk dataset retraining.", savedToDb: true },
        { status: 200 }
      );
    }

    // Jika Supabase belum dikonfigurasi, tetap return 200 ramah
    return NextResponse.json(
      { message: "Feedback diterima (Mode simulasi: Supabase belum terhubung).", savedToDb: false },
      { status: 200 }
    );
  } catch (error) {
    console.error("Feedback route error:", error);
    return NextResponse.json(
      { error: "Gagal memproses feedback pengguna." },
      { status: 500 }
    );
  }
}
