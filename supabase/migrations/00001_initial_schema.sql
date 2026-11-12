-- Migration: 00001_initial_schema.sql
-- Skema Database Proyek Deep Sorting (IPB University - Visual Komputer Cerdas Kelompok 7)
-- Fokus: Penyimpanan log klasifikasi anonim dan koreksi label (feedback) untuk retraining model

-- 1. Tabel Log Klasifikasi (Anonim)
CREATE TABLE IF NOT EXISTS public.classification_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    predicted_label VARCHAR(10) NOT NULL CHECK (predicted_label IN ('PET', 'HDPE', 'PVC', 'LDPE', 'PP', 'PS', 'Other')),
    confidence NUMERIC(5, 4) NOT NULL CHECK (confidence >= 0 AND confidence <= 1),
    model_name VARCHAR(50) NOT NULL DEFAULT 'MobileNetV2',
    is_demo BOOLEAN NOT NULL DEFAULT true,
    inference_time_ms INTEGER CHECK (inference_time_ms >= 0),
    user_consent_logged BOOLEAN NOT NULL DEFAULT true
);

-- Index untuk mempermudah analitik agregasi
CREATE INDEX IF NOT EXISTS idx_logs_created_at ON public.classification_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_logs_predicted_label ON public.classification_logs(predicted_label);

-- 2. Tabel Koreksi Ground Truth (Feedback Pengguna)
CREATE TABLE IF NOT EXISTS public.classification_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    prediction_id VARCHAR(100) NOT NULL,
    predicted_label VARCHAR(10) NOT NULL,
    corrected_label VARCHAR(10) NOT NULL CHECK (corrected_label IN ('PET', 'HDPE', 'PVC', 'LDPE', 'PP', 'PS', 'Other')),
    confidence NUMERIC(5, 4),
    notes TEXT,
    reviewed_for_dataset BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_feedback_created_at ON public.classification_feedback(created_at DESC);

-- 3. Row Level Security (RLS)
ALTER TABLE public.classification_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.classification_feedback ENABLE ROW LEVEL SECURITY;

-- Policy: Publik hanya diizinkan INSERT log anonim (telemetri)
CREATE POLICY "Public anonymous insert for classification logs"
ON public.classification_logs
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- Policy: Publik hanya diizinkan INSERT feedback / koreksi
CREATE POLICY "Public insert feedback"
ON public.classification_feedback
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- Policy: Pembacaan data log agregat hanya untuk service role (Server-side API / Dashboard tim peneliti)
CREATE POLICY "Service role full access logs"
ON public.classification_logs
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

CREATE POLICY "Service role full access feedback"
ON public.classification_feedback
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

