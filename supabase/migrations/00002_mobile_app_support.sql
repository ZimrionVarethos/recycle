-- Migration: 00002_mobile_app_support.sql
-- Penambahan kolom untuk dukungan riwayat aplikasi mobile Flutter Deep Sorting

ALTER TABLE public.classification_logs
    ADD COLUMN IF NOT EXISTS device_id VARCHAR(100),
    ADD COLUMN IF NOT EXISTS item_title VARCHAR(150),
    ADD COLUMN IF NOT EXISTS probabilities JSONB,
    ADD COLUMN IF NOT EXISTS source_backend VARCHAR(40) NOT NULL DEFAULT 'lightweight_ml';

CREATE INDEX IF NOT EXISTS idx_logs_device_id ON public.classification_logs(device_id);

-- Policy: Aplikasi mobile (anon) dapat membaca riwayat miliknya sendiri berdasarkan device_id yang dikirim
-- Untuk keamanan sederhana pada mode prototipe anonim, device_id wajib tidak kosong saat select
DROP POLICY IF EXISTS "Mobile app read own device logs" ON public.classification_logs;
CREATE POLICY "Mobile app read own device logs"
ON public.classification_logs
FOR SELECT
TO anon, authenticated
USING (device_id IS NOT NULL AND length(device_id) >= 8);
