# Setup Guide

This is the long version of "how to get Sparky running on your machine." If you're a judge or evaluator just trying to verify the project works, the README's Quick Start covers the happy path. This document is for the times the happy path doesn't work.

## What you need

- A computer with at least **16 GB of RAM** (Gemma 4 E4B is about 9.6 GB, and you need headroom)
- About **10 GB of free disk space** for the model
- Mac, Windows, or Linux

You do **not** need a GPU. Gemma 4 E4B runs on CPU. It's slower than on GPU but perfectly usable for tutoring (5–15 seconds per response).

You do **not** need an internet connection after the initial setup. Once Ollama and Gemma 4 are installed, Sparky runs entirely offline.

## Step-by-step install

### 1. Install Ollama

Download from [ollama.com/download](https://ollama.com/download) and run the installer for your operating system. Ollama runs as a background service that exposes a local HTTP API on `http://localhost:11434`.

To verify it installed correctly, open a terminal and run:

```bash
ollama --version
```

You should see a version number.

### 2. Pull Gemma 4 E4B

In a terminal:

```bash
ollama pull gemma4:e4b
```

This downloads the model (about 9.6 GB). Depending on your internet connection this may take 10–30 minutes. You can keep working in other windows while it downloads.

When it's done, verify the model is available:

```bash
ollama list
```

You should see `gemma4:e4b` in the list.

### 3. Allow browser access to Ollama (CORS)

By default, Ollama only accepts requests from `localhost`. The Sparky HTML file, when opened in a browser, runs from a `file://` URL — which counts as a different origin. You need to tell Ollama to accept requests from any origin so the browser can talk to it.

**On macOS:**
```bash
launchctl setenv OLLAMA_ORIGINS "*"
```

**On Linux:** add this line to your `~/.bashrc` or `~/.zshrc`:
```bash
export OLLAMA_ORIGINS="*"
```
Then restart your terminal.

**On Windows:**
1. Open System Properties → Environment Variables
2. Under "User variables," click New
3. Variable name: `OLLAMA_ORIGINS`
4. Variable value: `*`
5. Click OK and restart your computer (or sign out and back in)

### 4. Restart Ollama

The CORS env var only takes effect when Ollama starts up. After setting it, fully quit and reopen Ollama:

- **Mac:** Click the llama icon in the menu bar → Quit. Then open Ollama from Spotlight (Cmd+Space → "Ollama").
- **Windows:** Right-click the Ollama icon in the system tray → Quit. Then launch Ollama from the Start menu.
- **Linux:** Restart the Ollama service (`sudo systemctl restart ollama` if installed via systemd).

### 5. Open Sparky

Double-click `index.html` from this repo. It should open in your default browser.

You should see Sparky greet you on the right side, with the bid sheet on the left. The status indicator in the top right should say "Local · Gemma 4" with a green pulsing dot.

Try asking Sparky a question, like:
> *"how do I get the materials subtotal?"*

The first response will be slow (15–60 seconds) because Gemma 4 is loading into memory. Subsequent responses will be much faster (5–15 seconds).

---

## Troubleshooting

### "Can't reach the model" / "Failed to fetch"

This means the browser couldn't talk to Ollama. Three things to check:

**1. Is Ollama actually running?**
- Mac: look for the llama icon in your menu bar
- Windows: look for the icon in your system tray
- Linux: run `curl http://localhost:11434/api/tags` — if Ollama is running you'll get JSON back

**2. Did you set `OLLAMA_ORIGINS=*` AND restart Ollama?**
The env var has to be set _before_ Ollama starts. If you set it after Ollama was already running, you have to restart Ollama for it to take effect.

To verify the env var is set on Mac:
```bash
launchctl getenv OLLAMA_ORIGINS
```
Should print `*`. If it prints nothing, run the `launchctl setenv` command from step 3 again.

**3. Is the model actually available?**
```bash
ollama list
```
Should show `gemma4:e4b`. If not, run the `ollama pull` command from step 2 again.

### Responses are very slow

The first response after starting Ollama is slow because the model is being loaded into memory. After that, responses should be much faster. If they're still slow:

- Check Activity Monitor (Mac) or Task Manager (Windows). Ollama should be using significant CPU but not maxing it out.
- If your machine has less than 16 GB of RAM, performance will be poor. Consider closing other apps to free memory.
- The model loads faster if you have an Apple Silicon Mac (M1/M2/M3/M4) or a recent Intel/AMD chip.

### Browser blocks the page from loading

Some browsers (especially Brave, with shields up) may block the request to `localhost:11434`. Try Chrome, Edge, or Firefox with default settings.

### The page loads but the spreadsheet looks broken

Make sure you're loading the page directly from the repo, with the `index.html` file in the same folder as the `xlsx.full.min.js` library expects to load from CDN. If you're offline _during the initial page load_, SheetJS won't load and the download button won't work. Once loaded, both Ollama and the page itself work fully offline.

### .xlsx download doesn't work

The download uses [SheetJS](https://sheetjs.com/), which loads from a CDN. If you're behind a strict firewall that blocks CDN access, the library won't load and the download button won't work. Either:
- Whitelist `cdn.jsdelivr.net` in your firewall, OR
- Download the [SheetJS minified file](https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js) once, save it next to `index.html`, and change the script tag to point to the local file.

---

## Asking for help

Found a bug or got stuck somewhere this guide doesn't cover? [Open an issue]([https://github.com/TMPenwell/sparky-excel-for-electricians/issues)](https://github.com/TMPenwell/kaggle-Sparky-Excel-for-Electricians/issues) and I'll try to help.
