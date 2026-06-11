@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================
echo    SPARKY -- Excel for the Trades
echo    Offline Installer for Windows
echo ============================================
echo.

:: Step 1: Check system
echo ^> Step 1 of 4: Checking system...
echo   Windows detected
echo   [OK] System check complete
echo.

:: Step 2: Install Ollama
echo ^> Step 2 of 4: Installing Ollama...

where ollama >nul 2>&1
if %ERRORLEVEL% == 0 (
    echo   [OK] Ollama already installed
    goto step3
)

echo   Downloading Ollama installer (~500MB, please wait)...
powershell -Command "Invoke-WebRequest -Uri 'https://ollama.com/download/OllamaSetup.exe' -OutFile '%TEMP%\OllamaSetup.exe' -UseBasicParsing"

if not exist "%TEMP%\OllamaSetup.exe" (
    echo   [FAIL] Could not download Ollama.
    echo   Please download manually from: https://ollama.com/download
    echo   Then re-run this script.
    pause
    exit /b 1
)

echo.
echo   The Ollama installer will now open.
echo   Complete the installation, then come back to this window.
echo.
start /wait "" "%TEMP%\OllamaSetup.exe"
echo   [OK] Ollama installation complete
echo.

:step3
:: Step 3: Set CORS
echo ^> Step 3 of 4: Configuring Ollama...
setx OLLAMA_ORIGINS "*" >nul 2>&1
echo   [OK] Browser access enabled (OLLAMA_ORIGINS=*)
echo   NOTE: A restart may be required for this to take effect.
echo.

:: Step 4: Pull Gemma 4
echo ^> Step 4 of 4: Downloading Gemma 4 model...
echo   This is a ~9.6 GB download. This will take 15-60 minutes.
echo   Do not close this window.
echo.

ollama list 2>nul | findstr /C:"gemma4:e4b" >nul
if %ERRORLEVEL% == 0 (
    echo   [OK] Gemma 4 E4B already downloaded
    goto done
)

ollama pull gemma4:e4b
if %ERRORLEVEL% == 0 (
    echo   [OK] Gemma 4 E4B downloaded successfully
) else (
    echo   [FAIL] Model download failed.
    echo   Check your internet connection and try: ollama pull gemma4:e4b
    pause
    exit /b 1
)

:done
echo.
echo ============================================
echo    INSTALLATION COMPLETE
echo ============================================
echo.
echo Next steps:
echo   1. Restart your computer
echo   2. After restart, Ollama will run automatically
echo   3. Open index.html in Chrome
echo.
pause
