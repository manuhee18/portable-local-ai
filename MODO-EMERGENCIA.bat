@echo off
chcp 65001 >nul
title IA modo emergencia (KoboldCpp)
REM Plan B: un solo programa, sin Python ni instalaciones.
REM Sirve en casi cualquier PC con Windows, aunque no tenga grafica NVIDIA.
set "K=%~dp0portable"
if exist "%K%\modelo.gguf" (
    "%K%\koboldcpp.exe" --model "%K%\modelo.gguf" --port 5001 --contextsize 8192 --gpulayers -1 --launch
) else (
    echo No hay modelo en portable\modelo.gguf - se abrira la ventana para elegir uno.
    "%K%\koboldcpp.exe"
)
