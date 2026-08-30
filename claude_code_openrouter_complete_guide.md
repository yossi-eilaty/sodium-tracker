# Complete Guide: Running Claude Code on Windows via OpenRouter

This comprehensive guide walks you through setting up **Claude Code** on Windows using **OpenRouter** as an external LLM provider. This setup enables multi-file code editing, execution, and deep context management using cost-effective models like **DeepSeek V3** and **Qwen 2.5 Coder** without requiring a local GPU or native Anthropic subscriptions.

---

## 1. Executive Summary & Cost Comparison

Claude Code relies heavily on structured tool-calling (via the Anthropic Messages API). Using OpenRouter lets you route requests through high-performance, cost-effective models without requiring complex local proxies.

### Model Cost Breakdown (per 1M tokens)

| Model | OpenRouter Model ID | Input Cost | Output Cost | Role in Claude Code |
| :--- | :--- | :--- | :--- | :--- |
| **DeepSeek V3** | `deepseek/deepseek-chat` | ~$0.26 | ~$1.03 | **Primary Brain** (`ANTHROPIC_MODEL`) |
| **Qwen 2.5 Coder 32B** | `qwen/qwen-2.5-coder-32b-instruct` | $0.66 | $1.00 | **Fast Background Worker** (`ANTHROPIC_SMALL_FAST_MODEL`) |
| **Claude 3.7 Sonnet** *(Native Anthropic)* | `anthropic/claude-3-7-sonnet` | $3.00 | $15.00 | *Direct Benchmark Reference* |

> **Real-World Impact:** A multi-hour, context-heavy terminal coding session with native Claude 3.7 Sonnet typically costs **$2.00–$5.00+**. The exact same session using DeepSeek V3 via OpenRouter costs roughly **$0.05–$0.20**.

---

## 2. Step-by-Step Setup: OpenRouter Account & API Key

### Step 1: Create an Account
1. Open your web browser and go to **[openrouter.ai](https://openrouter.ai)**.
2. Click **Sign In** or **Sign Up** in the top-right corner.
3. Authenticate using your Google account, GitHub profile, or email.

### Step 2: Add Credits (Purchase Tokens)
OpenRouter operates on a prepay pay-as-you-go credit system:
1. Click your profile icon in the top-right corner and select **Credits** (or navigate directly to `openrouter.ai/credits`).
2. Click **Add Credits**.
3. Select your preferred payment method and enter an initial amount (minimum is typically **$5.00**).
   * *Note:* Given DeepSeek V3's pricing (~$0.26 per 1M input tokens), a $5.00 deposit will easily cover dozens of extensive coding sessions.

### Step 3: Generate an API Key
1. Go directly to **[openrouter.ai/keys](https://openrouter.ai/keys)**.
2. Click **Create Key**.
3. Enter a descriptive name (e.g., `Claude-Code-Key`) and click **Create**.
4. **Copy the generated key immediately** (it starts with `sk-or-v1-...`). Save it securely, as it will not be displayed again.

---

## 3. Environment Variable Architecture

Claude Code requires two primary model tier designations:

* **`ANTHROPIC_MODEL` (Primary Brain):** Handles core logic, complex multi-file refactoring, code writing, and tool execution. Assigned to `deepseek/deepseek-chat`.
* **`ANTHROPIC_SMALL_FAST_MODEL` & `ANTHROPIC_DEFAULT_HAIKU_MODEL` (Background Worker):** Handles low-latency sub-tasks, shell command summaries, titles, and quick micro-checks. Assigned to `qwen/qwen-2.5-coder-32b-instruct`.
* **`ANTHROPIC_BASE_URL` & `ANTHROPIC_AUTH_TOKEN`:** Directs API calls to OpenRouter (`https://openrouter.ai/api`). `ANTHROPIC_API_KEY` is explicitly cleared (`""`) to bypass default Anthropic Cloud authentication.

---

## 4. Shell Script Setup (`run_claude.sh`)

Rather than permanently editing shell configuration files like `~/.bashrc`, use a standalone launch script.

### Creating the Launcher Script

1. Open **Git Bash**.
2. Create and edit `run_claude.sh`:
   ```bash
   nano run_claude.sh
   ```
3. Paste the following complete script:

```bash
#!/usr/bin/env bash

# ==============================================================================
# 1. OpenRouter Endpoint & Authentication
# ==============================================================================
# Point to OpenRouter's API endpoint
export ANTHROPIC_BASE_URL="https://openrouter.ai/api"

# Pass OpenRouter API Key as Bearer Auth Token
export ANTHROPIC_AUTH_TOKEN="sk-or-v1-YOUR-OPENROUTER-KEY-HERE"

# Explicitly clear ANTHROPIC_API_KEY so Claude Code uses ANTHROPIC_AUTH_TOKEN
export ANTHROPIC_API_KEY=""

# ==============================================================================
# 2. Model Routing Configuration
# ==============================================================================
# Primary brain for coding, refactoring, and tool execution
export ANTHROPIC_MODEL="deepseek/deepseek-chat"

# Fast background worker models for utility tasks, summaries, and micro-checks
export ANTHROPIC_SMALL_FAST_MODEL="qwen/qwen-2.5-coder-32b-instruct"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="qwen/qwen-2.5-coder-32b-instruct"

# Skip organization check for third-party fast models
export CLAUDE_CODE_SKIP_FAST_MODE_ORG_CHECK=1

# ==============================================================================
# 3. Execution
# ==============================================================================
# Launch Claude Code passing along any CLI flags/arguments
exec claude "$@"
```

4. Replace `sk-or-v1-YOUR-OPENROUTER-KEY-HERE` with your actual key from Step 3.
5. Save and exit Nano (`Ctrl + O`, `Enter`, `Ctrl + X`).

---

## 5. Running & Verifying

### Make Executable and Launch
1. In Git Bash, grant executable permissions:
   ```bash
   chmod +x run_claude.sh
   ```
2. Launch Claude Code using the script:
   ```bash
   ./run_claude.sh
   ```

### Important First-Run Prompts
* **Custom API Key Prompt:** If Claude Code asks:
  > *"Detected a custom API key... Do you want to use this API key?"*  
  Select **No**. Selecting "No" ensures it continues using the environment variables set by your script rather than default Anthropic OAuth.
* **Cached Session Logout:** If you previously signed in with an Anthropic account, type `/logout` inside the session to clear existing credentials.
* **Verification:** Type `/status` inside Claude Code to verify that the base URL points to `https://openrouter.ai/api` and `deepseek/deepseek-chat` is active.
