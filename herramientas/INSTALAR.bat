@echo off
chcp 65001 >nul
title Instalador de la IA portatil
call "%~dp0entorno.bat"
set "CURL=%SystemRoot%\System32\curl.exe"
set "TAR=%SystemRoot%\System32\tar.exe"
set "UV=%IA%\herramientas\uv\uv.exe"
set "UV_CACHE_DIR=%IA%\datos\uv-cache"
set "UV_PYTHON_INSTALL_DIR=%IA%\interfaz\_pyinstall"
set "UV_LINK_MODE=copy"
set "UV_HTTP_TIMEOUT=300"
set "UV_HTTP_RETRIES=5"
set "UV_CONCURRENT_DOWNLOADS=4"

REM Versiones probadas (cambialas aqui para actualizar)
set "OLLAMA_VER=v0.40.13"
set "UV_VER=0.13.6"
set "KOBOLD_VER=v1.124.1"
set "GH=https://github.com"

for %%D in (motor\ollama modelos interfaz datos\logs portable instaladores documentos herramientas\uv) do if not exist "%IA%\%%D" mkdir "%IA%\%%D"

echo === 1/5  Motor de IA (Ollama %OLLAMA_VER%, ~1,6 GB) ===
if exist "%IA%\motor\ollama\ollama.exe" (
    echo Ya instalado.
) else (
    "%CURL%" -L --fail -o "%IA%\instaladores\ollama-windows-amd64.zip" "%GH%/ollama/ollama/releases/download/%OLLAMA_VER%/ollama-windows-amd64.zip" || goto error
    "%TAR%" -xf "%IA%\instaladores\ollama-windows-amd64.zip" -C "%IA%\motor\ollama" || goto error
)

echo.
echo === 2/5  Herramientas (uv %UV_VER%) y modo emergencia (KoboldCpp %KOBOLD_VER%) ===
if not exist "%UV%" (
    "%CURL%" -L --fail -o "%IA%\instaladores\uv.zip" "%GH%/astral-sh/uv/releases/download/%UV_VER%/uv-x86_64-pc-windows-msvc.zip" || goto error
    "%TAR%" -xf "%IA%\instaladores\uv.zip" -C "%IA%\herramientas\uv" || goto error
)
if not exist "%IA%\portable\koboldcpp.exe" (
    "%CURL%" -L --fail -o "%IA%\portable\koboldcpp.exe" "%GH%/LostRuins/koboldcpp/releases/download/%KOBOLD_VER%/koboldcpp.exe" || goto error
)
echo Listo.

echo.
echo === 3/5  Python portatil ===
if exist "%PY%" (
    echo Ya instalado.
) else (
    "%UV%" python install 3.11 --no-bin || goto error
    for /d %%D in ("%UV_PYTHON_INSTALL_DIR%\cpython-3.11.*") do move "%%D" "%IA%\interfaz\python" >nul
    rmdir /s /q "%UV_PYTHON_INSTALL_DIR%" 2>nul
)
"%PY%" --version || goto error

echo.
echo === 4/5  Open WebUI (interfaz tipo ChatGPT) - puede tardar 10-20 minutos ===
"%UV%" pip install --python "%PY%" --break-system-packages open-webui || goto error

echo.
echo === 5/5  Modelos de IA (~10 GB) ===
"%CURL%" -s -m 5 http://%OLLAMA_HOST%/api/version >nul 2>&1
if errorlevel 1 powershell -NoProfile -ExecutionPolicy Bypass -File "%IA%\herramientas\lanzar-oculto.ps1" "%IA%\motor\ollama\ollama.exe" "%IA%\datos\logs\motor.log" serve
set /a N=0
:esperaMotor
"%CURL%" -s -m 5 http://%OLLAMA_HOST%/api/version >nul 2>&1
if not errorlevel 1 goto motorListo
set /a N+=1
if %N% GEQ 90 goto error
"%SystemRoot%\System32\PING.EXE" -n 3 127.0.0.1 >nul
goto esperaMotor
:motorListo
"%IA%\motor\ollama\ollama.exe" pull qwen3.5:4b || goto error
"%IA%\motor\ollama\ollama.exe" pull qwen3.5:9b || goto error
"%IA%\motor\ollama\ollama.exe" pull nomic-embed-text || goto error
"%IA%\motor\ollama\ollama.exe" list

echo.
echo Preparando la lectura de documentos (modelo de embeddings para Open WebUI)...
set "HF_HUB_OFFLINE=0"
"%PY%" -c "from huggingface_hub import snapshot_download; snapshot_download('sentence-transformers/all-MiniLM-L6-v2')" || goto error
set "HF_HUB_OFFLINE=1"

rmdir /s /q "%UV_CACHE_DIR%" 2>nul
echo.
echo ===  INSTALACION COMPLETADA. Ahora usa INICIAR-IA.bat  ===
pause
exit /b 0

:error
echo.
echo *** Algo ha fallado. Revisa el mensaje de arriba y los registros en datos\logs ***
pause
exit /b 1
