# tech.md — Stack, Supabase, ML and Hosting

## Stack
- Next.js App Router + TypeScript
- Supabase (Postgres database; Auth/Storage only if needed)
- Vercel hosting for website
- Python FastAPI or Gradio for ML inference API
- Google Colab for model training

## Next.js vs Vite
Next.js and Vite are not normally used together as the same frontend app. Next.js has its own build/dev tooling. Recommended: Next.js + TypeScript + Tailwind on Vercel. If Vite is a strict requirement, use it in a separate app/tool, not as the bundler of Next.js.

## Architecture
```text
Browser
  └─ Next.js frontend (Vercel)
       ├─ Supabase (Postgres/Auth/Storage if needed)
       └─ HTTPS request to Python ML API
            └─ Load trained model → preprocess → inference → JSON response
```

## Supabase
- Database: Supabase Postgres.
- Use Supabase Auth only if account/login/history needs authentication.
- Use Storage only if images need persistence. Default: process image and discard it.
- RLS for tables accessible from browser.
- Service-role key must stay server-side; never use `NEXT_PUBLIC_` prefix.
- Use migrations and typed schema.
- Keep prediction history optional. Do not store images or personal data without purpose/consent.

Suggested env:
```env
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
ML_API_URL=
```
The service-role key and ML API secrets are server-only. Public anon/publishable key is safe only when RLS/policies are configured correctly.

## Colab model handoff
When training is finalized:
1. Export model artifact (`.keras`, `.h5`, SavedModel, or suitable format for chosen framework).
2. Export exact class order/label mapping.
3. Record preprocessing: resize 224x224, RGB/BGR, normalization, architecture-specific preprocessing.
4. Record model framework/version and dependencies.
5. Test loading artifact in a clean Python runtime.
6. Keep training notebook separate from inference service.
7. Never assume a model file alone is enough; inference code and preprocessing must match training.

## ML hosting options
A. Hugging Face Spaces (Gradio/FastAPI): good prototype; may sleep/cold start or have limits. Check current plan/runtime limits.
B. VPS: more control and persistent service; requires maintenance, HTTPS, security updates, monitoring. Benchmark CPU first; GPU VPS only if actual performance requires it.
C. Python/serverless ML host: check cold start, runtime, memory, payload, GPU availability, pricing.
D. Browser inference (TF.js/ONNX): advanced, model conversion and client performance validation needed.

## Recommendation
For student prototype: Colab training → export model → FastAPI/Gradio API on a Python-compatible host → Next.js on Vercel. Supabase handles relational app data, not model inference.

Do not use Vercel as persistent model server for a large TensorFlow/PyTorch model. Vercel is excellent for Next.js web hosting; inference should be separate.

## ML API contract (illustrative, not actual)
POST `/predict`, multipart field `file`.
```json
{
  "label": "PET",
  "confidence": 0.91,
  "probabilities": {
    "HDPE": 0.01, "LDPE": 0.02, "PET": 0.91,
    "PP": 0.03, "PS": 0.01, "PVC": 0.01, "Other": 0.01
  },
  "gradcam_url": null
}
```
This is a sample only. Confirm actual backend response format. Never fabricate real predictions.

## Accuracy target
- Current training accuracy/model result: around 70% as user reported.
- Release goal: >=92% (not achieved yet).
- Clarify if 92% means validation accuracy, held-out test accuracy, or another metric.
- Recommended release evaluation: test accuracy + macro-F1 + per-class precision/recall + confusion matrix + field photos.
- Split by source/object where possible to prevent similar images crossing train/validation/test.
- Tune using validation data, not repeatedly against test set.
- Do not promise 92% is achievable. If model misses target, report transparently and improve dataset/model/evaluation.

## Deployment
1. Deploy ML API separately with HTTPS.
2. Test API independently.
3. Deploy Next.js to Vercel.
4. Set Supabase and ML env vars.
5. Verify CORS, payload limit, timeout, and error handling.
6. Test on mobile and desktop.
