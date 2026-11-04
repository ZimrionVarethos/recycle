# skill.md — AI Agent Skill Set

Bertindak sebagai senior full-stack developer, product designer, Supabase engineer, dan ML integration engineer.

## Product & UX
- Rancang alur: landing → upload/camera → preview → analyze → result → retry.
- Upload drag/drop + browse; clear/change image.
- UI transparan, mudah dipresentasikan sebagai proyek akademik.
- Sertakan class description dan disclaimer, bukan klaim daur ulang definitif.

## Next.js
- App Router + TypeScript.
- Server Components by default.
- Client Components untuk upload, camera, state, dan browser APIs.
- Route handlers hanya sebagai BFF/proxy bila dibutuhkan.
- Jangan menjalankan ML inference berat di Vercel.

## Supabase
- Database untuk metadata/riwayat hanya bila requirement membutuhkan.
- Authentication hanya jika ada fitur user/account yang benar-benar perlu.
- RLS, migrations, schema types, secure server/client separation.
- Supabase Storage untuk image uploads hanya jika ada alasan; privacy-first default tidak menyimpan gambar.
- Avoid storing unnecessary user data.

## API integration
- Frontend → Python FastAPI/Gradio ML API.
- Timeout, abort, error mapping, limited retry.
- API response runtime validation.
- API URL via env.
- Mock mode clearly marked Demo.
- Do not assume response schema until backend contract is confirmed.

## ML awareness
- Classes: HDPE, LDPE, PET, PP, PS, PVC, Other.
- Input target 224×224; exact preprocessing must match training.
- Output class order must match training label encoder.
- Training current accuracy ~70%; desired release threshold >=92%, still a target.
- Evaluate held-out test accuracy, macro-F1, per-class metrics, confusion matrix, real-world image performance.
- Beware class imbalance, data leakage, duplicates, background bias, overfitting, and train/inference preprocessing mismatch.
- Grad-CAM only if the backend actually generates it.

## Testing
- File validation, camera, prediction states, API adapter, Supabase access policies.
- Test success, 4xx/5xx, timeout, invalid JSON, offline.
- Run available lint/typecheck/test/build commands.
- Report actual validation results.

## Documentation
README: install, env, Supabase setup, migrations, mock mode, ML API integration, deploy Vercel, troubleshooting.
