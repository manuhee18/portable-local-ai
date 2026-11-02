@echo off
chcp 65001 >nul
title Parar IA
call "%~dp0herramientas\entorno.bat"
echo Apagando la IA portatil...
REM Cierra solo los procesos que se ejecutan desde ESTE disco
powershell -NoProfile -Command "$r='%IA%'; Get-Process | Where-Object { $_.Path -and $_.Path.StartsWith($r, 'OrdinalIgnoreCase') } | ForEach-Object { Write-Host ('  cerrando ' + $_.ProcessName); Stop-Process -Id $_.Id -Force }"
echo.
echo Hecho. Ya puedes expulsar el disco de forma segura.
"%SystemRoot%\System32\timeout.exe" /t 5 >nul
