@echo off
REM ============================================================
REM  Configuracion comun de la IA portatil.
REM  Todas las rutas se calculan a partir de donde esta el disco,
REM  asi funciona aunque Windows le asigne otra letra (D:, E:, ...).
REM ============================================================
for %%I in ("%~dp0..") do set "IA=%%~fI"

REM --- Motor (Ollama) ---
set "OLLAMA_MODELS=%IA%\modelos"
REM Puerto propio (11435) para no chocar si el PC ya tiene Ollama instalado
set "OLLAMA_HOST=127.0.0.1:11435"
set "OLLAMA_KEEP_ALIVE=10m"

REM --- Interfaz (Open WebUI) ---
set "PY=%IA%\interfaz\python\python.exe"
set "DATA_DIR=%IA%\datos\openwebui"
set "HF_HOME=%IA%\datos\huggingface"
set "OLLAMA_BASE_URL=http://127.0.0.1:11435"
set "WEBUI_PORT=8090"
set "WEBUI_AUTH=False"
set "ENABLE_OPENAI_API=False"
set "ANONYMIZED_TELEMETRY=False"
set "DO_NOT_TRACK=True"
set "SCARF_NO_ANALYTICS=True"
REM Todo lo necesario ya esta en el USB: no buscar actualizaciones ni descargar nada al arrancar
set "OFFLINE_MODE=True"
set "HF_HUB_OFFLINE=1"
set "PYTHONUTF8=1"
set "PYTHONNOUSERSITE=1"
