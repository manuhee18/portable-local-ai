@echo off
chcp 65001 >nul
title Descargar modelo de IA
call "%~dp0entorno.bat"
"%SystemRoot%\System32\curl.exe" -s http://%OLLAMA_HOST%/api/version >nul 2>&1
if errorlevel 1 (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%IA%\herramientas\lanzar-oculto.ps1" "%IA%\motor\ollama\ollama.exe" "%IA%\datos\logs\motor.log" serve
    "%SystemRoot%\System32\PING.EXE" -n 5 127.0.0.1 >nul
)
echo.
echo Busca modelos en https://ollama.com/library
echo Con tu RTX 2060 (6 GB) lo ideal son modelos de menos de ~6 GB.
echo.
set /p "M=Nombre del modelo (ej: gemma4:e2b): "
"%IA%\motor\ollama\ollama.exe" pull %M%
echo.
"%IA%\motor\ollama\ollama.exe" list
pause
