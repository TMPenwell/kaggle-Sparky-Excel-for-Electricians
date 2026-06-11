#!/bin/bash

# ============================================================
# Sparky — Excel for the Trades
# Mac Installer Script
# Run this once per machine to set up Sparky for offline use
# ============================================================

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   SPARKY — Excel for the Trades          ║"
echo "║   Offline Installer for macOS            ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── Step 1: Check for Homebrew (optional but helpful) ──
echo "► Step 1 of 4: Checking system..."
ARCH=$(uname -m)
OS=$(uname -s)
echo "  System: $OS ($ARCH)"
echo "  ✓ System check complete"
echo ""

# ── Step 2: Install Ollama ──
echo "► Step 2 of 4: Installing Ollama..."
if command -v ollama &> /dev/null; then
    echo "  ✓ Ollama already installed ($(ollama --version))"
else
    echo "  Downloading Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
    if command -v ollama &> /dev/null; then
        echo "  ✓ Ollama installed successfully"
    else
        echo ""
        echo "  ✗ Ollama installation failed."
        echo "  Please download manually from: https://ollama.com/download"
        echo "  Then re-run this script."
        exit 1
    fi
fi
echo ""

# ── Step 3: Start Ollama and set CORS ──
echo "► Step 3 of 4: Configuring Ollama..."

# Set ORIGINS env var so browser can talk to Ollama
launchctl setenv OLLAMA_ORIGINS "*"
echo "  ✓ Browser access enabled (OLLAMA_ORIGINS=*)"

# Start Ollama in background if not already running
if ! pgrep -x "ollama" > /dev/null; then
    echo "  Starting Ollama service..."
    ollama serve &> /dev/null &
    sleep 3
    echo "  ✓ Ollama started"
else
    echo "  ✓ Ollama already running"
fi
echo ""

# ── Step 4: Pull Gemma 4 ──
echo "► Step 4 of 4: Downloading Gemma 4 model..."
echo "  This is a ~9.6 GB download and may take 10–30 minutes"
echo "  depending on your internet connection."
echo "  You can keep working in other windows while this runs."
echo ""

if ollama list | grep -q "gemma4:e4b"; then
    echo "  ✓ Gemma 4 E4B already downloaded"
else
    echo "  Downloading gemma4:e4b..."
    ollama pull gemma4:e4b
    if [ $? -eq 0 ]; then
        echo "  ✓ Gemma 4 E4B downloaded successfully"
    else
        echo "  ✗ Model download failed. Check your internet connection and try again."
        exit 1
    fi
fi
echo ""

# ── Done ──
echo "╔══════════════════════════════════════════╗"
echo "║   ✓ INSTALLATION COMPLETE                ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "To use Sparky:"
echo "  1. Make sure Ollama is running (look for the llama icon in your menu bar)"
echo "  2. Open index.html in Chrome"
echo "  3. Students can ask Sparky about any blank cell"
echo ""
echo "NOTE: The first response after starting Ollama will be slow (15-60 seconds)"
echo "while the model loads into memory. Subsequent responses are much faster."
echo ""
echo "For troubleshooting, see: docs/SETUP.md"
echo ""
