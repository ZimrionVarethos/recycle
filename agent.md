# agent.md — Coding Rules

## Batas ukuran file
- Maksimal 250–300 baris kode per file; idealnya di bawah 250.
- Pecah file saat mulai mendekati batas berdasarkan tanggung jawab.
- Jangan memecah secara berlebihan.
- Jangan refactor file existing yang besar tanpa menilai risiko terlebih dahulu.

## Workflow
1. Inspect repository, stack, scripts, dan struktur.
2. Baca `PROMPT.md`, `skill.md`, `design.md`, `tech.md`.
3. Buat plan singkat dan daftar asumsi.
4. Implementasi bertahap, bukan rewrite besar sekaligus.
5. Jalankan lint, typecheck, tests, build sesuai scripts yang tersedia.
6. Laporkan fitur, file yang diubah, validasi, dan TODO.

## Coding
- TypeScript strict; hindari `any`.
- Next.js App Router; Server Components by default, Client Components hanya untuk interaksi.
- Pisahkan UI, features, lib/services, types, config.
- API request logic tidak ditaruh langsung di komponen UI.
- Jangan menambahkan dependency tanpa alasan.
- Gunakan error handling dan runtime validation untuk API response.
- Jangan membuat dead buttons, fake functionality, atau TODO tersembunyi.
- Jangan hardcode endpoint, keys, secrets, atau credentials.

## Supabase
- Gunakan Supabase client yang sesuai untuk browser/server.
- `SUPABASE_URL` dan anon/publishable key boleh digunakan sesuai konfigurasi; service-role key hanya server-side dan tidak boleh memakai prefix `NEXT_PUBLIC_`.
- Aktifkan RLS pada tabel yang berisi data user atau data yang terekspos ke client.
- Buat SQL migrations/schema terdokumentasi.
- Jangan mengarang policy RLS permissive seperti `using (true)` untuk data privat.
- Jangan simpan foto user secara default. Jika Supabase Storage dipakai, tentukan bucket, access policy, retention, dan consent.
- Jangan menyimpan API secrets ML di browser.

## ML correctness & privacy
- Model masih training; akurasi saat ini sekitar 70%, target release 92%.
- Jangan tampilkan target sebagai hasil aktual.
- Mock prediction wajib memiliki label Demo.
- Jangan mengklaim confidence sebagai calibrated probability tanpa calibration study.
- Validasi image MIME/type/size dan request payload.
- Jangan log image content, secrets, atau personal data.
- Hasil prediksi merupakan estimasi, bukan kepastian material/recyclability.

## UX
- Follow `design.md`.
- Responsive, keyboard accessible, semantic HTML, visible focus.
- Loading, empty, error, success, retry, and demo states.
- Camera permissions harus eksplisit; stop camera tracks saat ditutup/unmount.
- Revoke preview object URLs saat tidak dipakai.

## Git
- Jangan menghapus file/data yang tidak relevan.
- Jangan jalankan destructive commands tanpa persetujuan.
- Jangan menyatakan test berhasil jika belum menjalankannya.
