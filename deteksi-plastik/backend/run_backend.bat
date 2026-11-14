@echo off
setlocal enabledelayedexpansion
title Backend Python - Klasifikasi Sampah Plastik
cd /d "%~dp0"

echo ========================================================
echo   BACKEND PYTHON FASTAPI - KLASIFIKASI SAMPAH PLASTIK
echo ========================================================
echo.

if not exist ".venv" (
    echo [1/3] Membuat Python Virtual Environment (.venv)...
    python -m venv .venv
    if errorlevel 1 (
        echo [ERROR] Gagal membuat virtual environment. Pastikan Python 3.10+ terpasang.
        pause
        exit /b 1
    )
)

echo [2/3] Mengaktifkan virtual environment dan memeriksa dependensi...
call .venv\Scripts\activate.bat

python -c "import fastapi, uvicorn, PIL, cv2" >nul 2>&1
if errorlevel 1 (
    echo Mengunduh dan memasang library FastAPI, Uvicorn, Pillow, OpenCV, TensorFlow...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [WARN] Instalasi penuh requirements.txt gagal. Mencoba instalasi minimal...
        pip install fastapi "uvicorn[standard]" python-multipart pillow opencv-python-headless
    )
)

echo.
echo ========================================================
echo   PANDUAN KONEKSI KE HP ANDROID (DALAM 1 WI-FI):
echo ========================================================
echo Alamat IP Laptop Anda saat ini:
for /f "tokens=4" %%a in ('route print ^| findstr 0.0.0.0 ^| findstr /v "0.0.0.0.*0.0.0.0"') do (
    echo   -> http://%%a:8000
)
echo.
echo Masukkan alamat di atas pada tab PENGATURAN di aplikasi HP.
echo Jika memakai Android Emulator di laptop, gunakan:
echo   -> http://10.0.2.2:8000
echo.
echo Dokumentasi API (Swagger) di browser:
echo   -> http://localhost:8000/docs
echo ========================================================
echo.
echo Menjalankan server FastAPI di port 8000...
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
pause

