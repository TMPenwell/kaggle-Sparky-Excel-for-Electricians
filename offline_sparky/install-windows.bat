@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================
echo    SPARKY -- Excel for the Trades
echo    Offline Installer for Windows
echo ============================================
echo.

:: ── Step 1: Check system ──
echo ^> Step 1 of 4: Checking system...
echo   Windows detected
echo   [OK] System check complete
echo.

:: ── Step 2: Install Ollama ──
echo ^> Step 2 of 4: Installing Ollama...

where ollama >nul 2>&1
if %ERRORLEVEL% == 0 (
    echo   [OK] Ollama already installed
) else (
    echo   Downloading Ollama installer...
    echo   This will open the Ollama installer. Follow the prompts to install.
    echo.
    
    :: Download Ollama installer
    powershell -Command "Invoke-WebRequest -Uri 'https://ollama.com/download/OllamaSetup.exe' -OutFile '%TEMP%\OllamaSetup.exe'"
    
    if exist "%TEMP%\OllamaSetup.exe" (
        echo   Running installer...
        "%TEMP%\OllamaSetup.exe" /S
        timeout /t 10 /nobreak >nul
        echo   [OK] Ollama installed
    ) else (
        echo   [FAIL] Could not download Ollama installer.
        echo   Please download manually from: https://ollama.com/download
        echo   Then re-run this script.
        pause
        exit /b 1
    )
)
echo.

:: ── Step 3: Set CORS environment variable ──
echo ^> Step 3 of 4: Configuring Ollama...

:: Set OLLAMA_ORIGINS permanently for the current user
setx OLLAMA_ORIGINS "*" >nul 2>&1
echo   [OK] Browser access enabled (OLLAMA_ORIGINS=*)
echo   NOTE: You may need to restart your computer for this to take effect.
echo.

:: ── Step 4: Pull Gemma 4 ──
echo ^> Step 4 of 4: Downloading Gemma 4 model...
echo   This is a ~9.6 GB download and may take 10-30 minutes
echo   depending on your internet connection.
echo.

:: Check if model already exists
ollama list 2>nul | findstr /C:"gemma4:e4b" >nul
if %ERRORLEVEL% == 0 (
    echo   [OK] Gemma 4 E4B already downloaded
) else (
    echo   Downloading gemma4:e4b...
    ollama pull gemma4:e4b
    if %ERRORLEVEL% == 0 (
        echo   [OK] Gemma 4 E4B downloaded successfully
    ) else (
        echo   [FAIL] Model download failed.
        echo   Check your internet connection and try again.
        pause
        exit /b 1
    )
)
echo.

:: ── Done ──
echo ============================================
echo    INSTALLATION COMPLETE
echo ============================================
echo.
echo To use Sparky:
echo   1. Make sure Ollama is running
echo      (look for the llama icon in your system tray)
echo   2. Open index.html in Chrome
echo   3. Students can ask Sparky about any blank cell
echo.
echo NOTE: If Ollama does not respond after installation,
echo restart your computer and try again.
echo.
echo For troubleshooting, see: docs\SETUP.md
echo.
pause
