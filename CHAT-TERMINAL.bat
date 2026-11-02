@echo off
chcp 65001 >nul
title IA en terminal
call "%~dp0herramientas\entorno.bat"
"%SystemRoot%\System32\curl.exe" -s http://%OLLAMA_HOST%/api/version >nul 2>&1
if errorlevel 1 (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%IA%\herramientas\lanzar-oculto.ps1" "%IA%\motor\ollama\ollama.exe" "%IA%\datos\logs\motor.log" serve
    "%SystemRoot%\System32\PING.EXE" -n 5 127.0.0.1 >nul
)
echo.
echo Modelos disponibles:
"%IA%\motor\ollama\ollama.exe" list
echo.
set "M=qwen3.5:4b"
set /p "M=Modelo a usar [Enter = qwen3.5:4b]: "
echo.
echo Escribe tu mensaje. Para salir escribe /bye
echo.
"%IA%\motor\ollama\ollama.exe" run %M%
