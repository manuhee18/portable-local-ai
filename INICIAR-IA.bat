@echo off
chcp 65001 >nul
title Mi IA Portatil
call "%~dp0herramientas\entorno.bat"
set "LOGS=%IA%\datos\logs"
set "OCULTO=powershell -NoProfile -ExecutionPolicy Bypass -File "%IA%\herramientas\lanzar-oculto.ps1""

echo.
echo  =============================================
echo     MI IA PORTATIL  -  arrancando...
echo     Disco: %IA%
echo  =============================================
echo.

if not exist "%PY%" (
    echo  Falta la instalacion. Ejecuta primero herramientas\INSTALAR.bat
    pause
    exit /b 1
)

REM 1) Motor de IA (Ollama) - se ejecuta oculto, sin ventana
"%SystemRoot%\System32\curl.exe" -s -m 5 http://%OLLAMA_HOST%/api/version >nul 2>&1
if errorlevel 1 (
    echo  [1/2] Encendiendo el motor de IA ^(la primera vez en un PC puede tardar 1 minuto^)...
    %OCULTO% "%IA%\motor\ollama\ollama.exe" "%LOGS%\motor.log" serve
) else (
    echo  [1/2] El motor ya estaba encendido.
)
set /a N=0
:esperaMotor
"%SystemRoot%\System32\curl.exe" -s -m 5 http://%OLLAMA_HOST%/api/version >nul 2>&1
if not errorlevel 1 goto motorListo
set /a N+=1
if %N% GEQ 90 (
    echo  ERROR: el motor no arranca. Mira %LOGS%\motor.log
    pause
    exit /b 1
)
"%SystemRoot%\System32\PING.EXE" -n 3 127.0.0.1 >nul
goto esperaMotor
:motorListo
echo        Motor listo.

REM 2) Interfaz web (Open WebUI) - tambien oculta
"%SystemRoot%\System32\curl.exe" -s -m 5 http://127.0.0.1:%WEBUI_PORT%/health >nul 2>&1
if errorlevel 1 (
    echo  [2/2] Encendiendo la interfaz ^(1-3 minutos^)...
    %OCULTO% "%PY%" "%LOGS%\interfaz.log" "%IA%\herramientas\webui.py" serve --host 127.0.0.1 --port %WEBUI_PORT%
) else (
    echo  [2/2] La interfaz ya estaba encendida.
)
set /a N=0
:esperaWeb
"%SystemRoot%\System32\curl.exe" -s -m 5 http://127.0.0.1:%WEBUI_PORT%/health >nul 2>&1
if not errorlevel 1 goto webLista
set /a N+=1
if %N% GEQ 150 (
    echo  ERROR: la interfaz no arranca. Mira %LOGS%\interfaz.log
    pause
    exit /b 1
)
"%SystemRoot%\System32\PING.EXE" -n 3 127.0.0.1 >nul
goto esperaWeb
:webLista

echo.
echo  LISTO. Abriendo http://127.0.0.1:%WEBUI_PORT% en el navegador...
start "" http://127.0.0.1:%WEBUI_PORT%
echo.
echo  Ya puedes cerrar esta ventana: la IA sigue funcionando en segundo plano.
echo  Para apagarla: doble clic en PARAR-IA.bat
"%SystemRoot%\System32\timeout.exe" /t 10 >nul
