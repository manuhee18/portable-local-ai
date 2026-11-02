# 🧠💾 Portable Local AI

**A private, offline ChatGPT-style AI that lives on a USB drive.**
Plug it into any Windows PC, double-click one file, and chat with your own AI. No subscription, no internet, no installation on the host PC.

> 🇪🇸 Spanish user guide: [LEEME.md](LEEME.md)

<!-- Add a screenshot or GIF here: ![demo](docs/demo.gif) -->

---

## ✨ Features

- **100% private.** Everything runs on `127.0.0.1`, and nothing leaves your computer.
- **Works offline.** After the first install, no internet is needed.
- **Free forever.** It uses open-source models, so there are no monthly fees.
- **Truly portable.** Everything lives on the drive. It works even if Windows gives the drive a different letter (`D:`, `E:`…).
- **Leaves no trace on the host PC.** It uses its own Python, its own ports and its own data folder.
- **Chat with your documents.** Upload PDFs and ask questions about them (RAG).
- **Uses the GPU when available** (NVIDIA CUDA) and falls back to CPU when not.
- **Emergency mode.** A single `.exe` backup (KoboldCpp) for restricted PCs.
- **Conversations travel with you.** Chat at home, continue at school.

## 🚀 Quick start

1. Copy this folder to a USB drive (an external SSD is recommended).
2. Double-click `herramientas\INSTALAR.bat`. It needs internet once and downloads about 15 GB.
3. Double-click **`INICIAR-IA.bat`**. Your browser opens at `http://127.0.0.1:8090`.
4. Pick a model and start chatting.
5. Double-click **`PARAR-IA.bat`** before unplugging the drive.

| Script | What it does |
|---|---|
| `INICIAR-IA.bat` | Starts the engine and web UI in the background and opens the browser |
| `PARAR-IA.bat` | Stops everything running from the drive (safe to unplug) |
| `CHAT-TERMINAL.bat` | Quick chat in the terminal, without a browser |
| `MODO-EMERGENCIA.bat` | Backup mode: one `.exe`, no Python or PowerShell needed |
| `herramientas\DESCARGAR-MODELO.bat` | Download more models from [ollama.com/library](https://ollama.com/library) |

## ⚙️ How it works

```
 Browser ──► Open WebUI ──► Ollama ──► Model (GGUF)
 :8090       the "face"     the "engine"  the "brain"
             (Python)       (GPU/CPU)
```

| Part | Role | Tool |
|---|---|---|
| 🧠 Model | The AI "brain": what it knows | Qwen 3.5 (4B / 9B) |
| ⚙️ Engine | Loads the model on the GPU and generates text | [Ollama](https://github.com/ollama/ollama) |
| 💬 Interface | ChatGPT-style web UI, history, documents | [Open WebUI](https://github.com/open-webui/open-webui) |
| 🐍 Runtime | Portable Python, installed on the drive | [uv](https://github.com/astral-sh/uv) |
| 🆘 Backup | Single-file engine and UI | [KoboldCpp](https://github.com/LostRuins/koboldcpp) |

## 📊 Performance

Tested on a laptop with a **Ryzen 7 3750H, 16 GB RAM and RTX 2060 (6 GB VRAM)**, running from a USB hard drive:

| Model | Size | Speed | Notes |
|---|---|---|---|
| `qwen3.5:4b` | 3.3 GB | **~40 tokens/s** | Fits 100% in the GPU, so it's the daily driver |
| `qwen3.5:9b` | 6.6 GB | slower | Smarter, partly offloaded to RAM |

Rule of thumb: **GPU memory (VRAM) decides which models you can run.** 6 GB is enough for models of about 4 to 8 billion parameters.

## 🛠️ Portability: problems I had to solve

Making it *really* portable was the hardest part:

- **Drive letter changes.** Every script works out its paths from its own location (`%~dp0`), so nothing is hard-coded.
- **Python venvs aren't portable** because they store absolute paths. I used a standalone Python with packages installed directly into it, and started Open WebUI with a small launcher instead of `.exe` shims.
- **Port conflicts.** The host PC may already run Ollama, so this project uses its own ports (`11435` and `8090`).
- **Accidentally closing windows killed the AI.** The services now run hidden in the background, with logs in `datos/logs/`.
- **Offline first start.** The embedding model for documents is downloaded once during install, then the app runs in offline mode.
- **Developer PCs have conflicting tools.** Scripts call Windows tools by their full path (`%SystemRoot%\System32\curl.exe`).

## 📁 Folder structure

```
INICIAR-IA.bat / PARAR-IA.bat / ...   ← what you click
herramientas/   install + launcher scripts
motor/          Ollama            (downloaded, git-ignored)
modelos/        AI models          (downloaded, git-ignored)
interfaz/       portable Python + Open WebUI (downloaded, git-ignored)
portable/       KoboldCpp          (downloaded, git-ignored)
datos/          YOUR chats, documents, settings, logs (private, git-ignored)
```

## 💻 Requirements

- Windows 10/11 (64-bit).
- 8 GB RAM minimum (16 GB recommended).
- About 20 GB of free space on the drive.
- NVIDIA GPU optional, but much faster with one.

## ⚠️ Limitations

- Local models are **not as smart as the best paid models**, but they're very good for everyday tasks.
- Windows only, for now.
- Some school or company PCs block programs from USB drives. Always ask for permission first.

## 🗺️ Roadmap

- [ ] Emergency mode with a pre-configured model
- [ ] Small model for PCs without a GPU
- [ ] Automatic backup of conversations
- [ ] Personal assistant: custom personality, knowledge base and web search
- [ ] Voice input and output

## 🤝 Credits

Built by [@manuhee18](https://github.com/manuhee18), with [Claude Code](https://claude.com/claude-code) as my AI pair-programmer.

This project only contains scripts. Ollama, Open WebUI, uv, KoboldCpp and the Qwen models are downloaded from their official sources and keep their own licenses.

## 📄 License

[MIT](LICENSE)
