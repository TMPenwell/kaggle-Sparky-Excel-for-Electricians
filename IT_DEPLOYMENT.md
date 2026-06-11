# Sparky Offline — IT Deployment Guide

This guide is for IT staff deploying Sparky to classroom computers or shared drives at a trade school or apprenticeship program.

---

## What Sparky needs to run

| Requirement | Detail |
|---|---|
| RAM | 16 GB minimum (Gemma 4 E4B is ~9.6 GB) |
| Disk space | ~11 GB free |
| Internet | Required for initial setup only — fully offline after that |
| Browser | Chrome (recommended), Edge, or Firefox |
| OS | macOS 11+, Windows 10/11, Ubuntu 20.04+ |
| GPU | Not required — runs on CPU |

---

## Quickest deployment: shared folder or USB drive

1. **Download this repo** as a ZIP from GitHub → extract it
2. **Run the installer once** on each machine (see below)
3. **Put the extracted folder** on a shared network drive or USB drive
4. Students open `index.html` from the shared folder in Chrome — no installation needed on their end

The installer only needs to run once per machine. After that, students can use Sparky from any copy of `index.html` — on a USB, shared drive, or local copy.

---

## Running the installer

### macOS
1. Open Terminal
2. Navigate to the install folder:
   ```bash
   cd /path/to/sparky-offline/install
   ```
3. Make the script executable and run it:
   ```bash
   chmod +x install-mac.sh
   ./install-mac.sh
   ```
4. The script will install Ollama, configure browser access, and download Gemma 4 (~9.6 GB)

### Windows
1. Right-click `install/install-windows.bat`
2. Select **Run as administrator**
3. Follow the prompts
4. Restart the computer after installation completes

### Linux
Use the Mac script — it works on Ubuntu/Debian:
```bash
chmod +x install/install-mac.sh
./install/install-mac.sh
```

---

## What the installer does

1. **Installs Ollama** — the local model runtime (if not already installed)
2. **Sets `OLLAMA_ORIGINS=*`** — allows the browser to talk to the local Ollama service
3. **Downloads Gemma 4 E4B** — the AI model (~9.6 GB, one-time download)

After installation, no internet connection is required to use Sparky.

---

## Starting Sparky each session

**Students do not need to do anything special.** Just open `index.html` in Chrome.

**One thing IT needs to ensure:** Ollama must be running before students open Sparky.

- **Mac:** Ollama runs automatically on login if installed correctly. Look for the llama icon in the menu bar.
- **Windows:** Ollama runs automatically on login. Look for the icon in the system tray.
- **If Ollama is not running:** Students will see a "Can't reach the model" error. Open Ollama from the Applications folder (Mac) or Start menu (Windows).

---

## First response is slow — this is normal

The first time a student asks Sparky a question after Ollama starts, the response will take 15–60 seconds while the model loads into memory. After that, responses are 5–15 seconds. This is expected behavior.

---

## Deploying to multiple machines

**Option 1 — Run installer on each machine individually**
Best for small deployments (under 10 machines). Takes ~30 minutes per machine (mostly waiting for the model download).

**Option 2 — Image-based deployment**
Install Ollama + Gemma 4 on one machine, then create a disk image and deploy to other machines using your existing imaging tools (Ghost, Clonezilla, SCCM, etc.). This is the fastest approach for large labs.

**Option 3 — Shared Ollama server**
For schools with a server room: install Ollama on a central server, update `index.html` to point at the server IP instead of `localhost:11434`. Students run `index.html` locally but the AI runs on the server. Contact your instructor for help with this configuration.

---

## Updating Sparky

To update the app:
1. Download the new `index.html` from GitHub
2. Replace the existing `index.html` in the shared folder
3. No reinstallation needed — the model stays on each machine

To update the Gemma model:
```bash
ollama pull gemma4:e4b
```

---

## Troubleshooting

| Problem | Solution |
|---|---|
| "Can't reach the model" error | Make sure Ollama is running. Check for the llama/tray icon. |
| First response never comes | Wait 60 seconds. If still nothing, restart Ollama. |
| Very slow responses | Close other applications to free RAM. 16 GB minimum required. |
| "Model not found" error | Run `ollama pull gemma4:e4b` in Terminal/Command Prompt |
| Browser blocks the page | Use Chrome with default settings. Brave may block localhost requests. |
| CORS error after Windows install | Restart the computer after running the installer |

For additional help, see [docs/SETUP.md](../docs/SETUP.md) or open an issue at the GitHub repository.

---

## Security and privacy

- **No data leaves the machine.** All AI processing happens locally via Ollama.
- **No API keys required** for the offline version.
- **No student data is stored** — Sparky has no database or logging.
- Bid pricing and estimating practice data stays on the student's machine.
