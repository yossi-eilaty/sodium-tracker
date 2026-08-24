# Ollama Usage & Management Guide

A summary of essential commands, environment configurations, and model references for managing Ollama on Windows.

---

## 1. Core Ollama CLI Commands

| Command | Description | Example / Syntax |
| :--- | :--- | :--- |
| `ollama list` | Lists all installed models, sizes, and modifications. | `ollama list` |
| `ollama run <model>` | Pulls (if missing) and launches an interactive chat session. | `ollama run qwen2.5-coder:1.5b` |
| `ollama pull <model>` | Downloads a model to local disk without launching a session. | `ollama pull deepseek-coder-v2` |
| `ollama rm <model>` | Permanently deletes a downloaded model and reclaims disk space. | `ollama rm qwen2.5-coder:32b` |

---

## 2. Interactive Session Commands

Commands executed inside an active `ollama run` session:

* `/show config` — Displays the current model's architecture, system prompt, and parameters.
* `/set parameter num_ctx <size>` — Adjusts context window length for the active session (e.g., `/set parameter num_ctx 16384`).
* `/clear` — Flushes active conversation history from memory without exiting.
* `/bye` — Exits the interactive prompt and unloads model weights from memory.

---

## 3. Tool & CLI Integrations

### Claude Code Integration
To route a local **Claude Code** session through a locally hosted Ollama model:

```powershell
ollama launch claude --model deepseek-coder-v2
```

---

## 4. Bulk Model Cleanup Scripts

### PowerShell (Windows)
Delete all installed local models at once:
```powershell
ollama list | Select-Object -Skip 1 | ForEach-Object { $name = $_.Split(' ')[0]; if ($name) { ollama rm $name } }
```

### Bash / WSL / macOS
```bash
ollama list | awk 'NR>1 {print $1}' | xargs -n1 ollama rm
```

---

## 5. Troubleshooting & Environment Overrides

### Forcing CPU Mode (Bypassing CUDA/GPU Crashes)
When facing GPU driver mismatch errors (`0xc0000409` or `PTX toolchain` errors), disable CUDA device visibility before launching Ollama:

```powershell
# In PowerShell (Ensure background tray process is closed first)
$env:CUDA_VISIBLE_DEVICES="-1"
ollama run qwen2.5-coder:1.5b
```

---

## 6. Model Sizing & VRAM Reference

| Model Tag | Parameters | Approx. Download Size | Recommended VRAM |
| :--- | :--- | :--- | :--- |
| `qwen2.5-coder:1.5b` | 1.5 Billion | ~1.0 GB | 2 GB – 4 GB |
| `qwen2.5-coder:3b` | 3.0 Billion | ~1.9 GB | 4 GB |
| `qwen2.5-coder:7b` | 7.0 Billion | ~4.7 GB | 6 GB – 8 GB |
| `qwen2.5-coder:14b` | 14.0 Billion | ~9.0 GB | 12 GB |
| `deepseek-coder-v2` | 16 Billion (Lite MoE) | ~8.9 GB | 12 GB – 16 GB |
| `qwen2.5-coder:32b` | 32.0 Billion | ~20.0 GB | 20 GB – 24 GB |
