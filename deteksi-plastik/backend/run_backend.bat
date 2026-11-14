@echo off
title Backend Python - Klasifikasi Sampah Plastik
cd /d "%~dp0"

echo ========================================================
echo   BACKEND PYTHON FASTAPI - KLASIFIKASI SAMPAH PLASTIK
echo ========================================================
echo.

if exist .venv goto :ACTIVATE

echo [1/3] Membuat Python Virtual Environment...
python -m venv .venv
if errorlevel 1 goto :VENV_ERROR

:ACTIVATE
echo [2/3] Mengaktifkan virtual environment...
call .venv\Scripts\activate.bat

echo [3/3] Memeriksa dependensi library...
python -c "import fastapi, uvicorn, PIL, cv2" >nul 2>&1
if errorlevel 1 (
    echo Mengunduh dan memasang dependensi requirements.txt...
    python -m pip install -r requirements.txt
    if errorlevel 1 (
        echo [WARN] Instalasi requirements.txt gagal. Memasang paket inti...
        python -m pip install fastapi "uvicorn[standard]" python-multipart pillow opencv-python-headless
    )
)

echo.
echo ========================================================
echo   PANDUAN KONEKSI KE HP ANDROID:
echo ========================================================
python -c "import socket; s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect(('8.8.8.8', 80)); ip = s.getsockname()[0]; s.close(); print('Alamat IP Laptop Anda:'); print('  -> http://' + ip + ':8000')" 2>nul
echo.
echo Masukkan alamat IP di atas pada tab PENGATURAN di aplikasi HP.
echo Jika memakai Android Emulator di laptop:
echo   -> http://10.0.2.2:8000
echo.
echo Dokumentasi API (Swagger) di browser:
echo   -> http://localhost:8000/docs
echo ========================================================
echo.
echo Menjalankan server FastAPI di port 8000...
echo Tekan Ctrl+C untuk menghentikan server.
echo.
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
goto :END

:VENV_ERROR
echo.
echo [ERROR] Gagal membuat virtual environment.
echo Pastikan Python 3.10+ sudah terpasang di komputer Anda.
echo.
pause

:END
pause
