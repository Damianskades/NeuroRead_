@echo off
chcp 65001 >nul
title NeuroRead
cd /d "%~dp0"

echo NeuroRead: instalador y lanzador
echo.

set "PY="
where python >nul 2>nul
if not errorlevel 1 (
    python --version >nul 2>nul
    if not errorlevel 1 set "PY=python"
)
if not defined PY (
    where py >nul 2>nul
    if not errorlevel 1 (
        py -3 --version >nul 2>nul
        if not errorlevel 1 set "PY=py -3"
    )
)
if not defined PY (
    echo ERROR: Python no está instalado en esta computadora.
    echo.
    echo 1. Descárgalo desde:  https://www.python.org/downloads/
    echo 2. IMPORTANTE: al instalar, marca la casilla "Add Python to PATH".
    echo 3. Vuelve a ejecutar este archivo.
    echo.
    pause
    exit /b 1
)

if not exist ".venv\Scripts\python.exe" (
    echo Preparando la aplicación por primera vez, espera un momento...
    %PY% -m venv .venv
    if errorlevel 1 (
        echo ERROR: No se pudo preparar el entorno de la aplicación.
        pause
        exit /b 1
    )
)

".venv\Scripts\python.exe" -c "import kivy" >nul 2>nul
if errorlevel 1 (
    echo Instalando dependencias, esto puede tardar unos minutos...
    echo (solo ocurre la primera vez^)
    ".venv\Scripts\python.exe" -m pip install --upgrade pip >nul 2>nul
    ".venv\Scripts\python.exe" -m pip install -r requirements.txt
    if errorlevel 1 (
        echo.
        echo ERROR: Falló la instalación de dependencias.
        echo Revisa tu conexión a internet y vuelve a ejecutar este archivo.
        pause
        exit /b 1
    )
)

echo.
echo Iniciando NeuroRead...
".venv\Scripts\python.exe" main.py
if errorlevel 1 (
    echo.
    echo La aplicación se cerró con un error.
    pause
)
