# 01. Windows setup: end to end

## Architecture and prerequisites

Recommended starting environment: Windows 11, a working GPU driver, enough disk for model GGUF files, Git, Python 3.10+ for validation and PowerShell 5.1/7 for diagnostic scripts. Node.js is needed **only** when an MCP server specifically requires it. You do not need Node.js to use the skills in this repository.

On an 8 GB VRAM / 16 GB system RAM laptop, prefer a 4-bit Qwen3.5-9B quantization and a conservative context limit. This is a **starting hypothesis**, not a performance guarantee. Larger contexts, multiple concurrent sessions, multimodal features, and extra tools can exhaust RAM/VRAM.

## Installation

1. Download Bionic from https://lmstudio.ai/docs/bionic and use a vendor-approved installer.
2. Load a runtime-supported model sourced from the official Qwen project or a reputable quantization publisher. Verify the exact model card, format and license.
3. Create a project in Bionic. For coding tasks, enable **Allow coding** and choose a dedicated directory such as C:\AI\Workspace. Avoid granting access to the user profile root or sensitive business folders.
4. Select the model and issue a minimal diagnostic question without tools.
5. Open Settings > Skills and add one of the supplied SKILL.md files. In a new chat use @ to select the desired skill (see official Bionic Skills docs).
6. Add MCP servers **one at a time** after supply-chain review. Verify the actual tool list and permission scope.
7. Only if a separate LM Studio local API server is running, test it with scripts/Test-LocalModel.ps1.

## Optional local server

LM Studio's documented default server binds on localhost port 1234. Bionic is a separate app; do not assume that starting Bionic automatically starts that API server. In LM Studio use Developer > Start server, then inspect the bound address.

~~~powershell
# Replace 1234 if the server has been configured differently.
.\scripts\Test-LocalModel.ps1 -BaseUrl 'http://127.0.0.1:1234'
~~~

Expected output: a successful GET /v1/models response with at least one model, or a precise connection/HTTP error. A healthy endpoint does not prove model responses or tool calling work; run the regression prompts afterwards.

## Secure defaults

- Bind APIs to 127.0.0.1; disable LAN serving and CORS unless there is a documented need.
- Enable token authentication when exposing an API beyond loopback; never use port forwarding directly to the open internet.
- Never grant an agent administrator rights simply to make a skill work.
- Prefer read-only diagnostics before configuration changes.
- Use a non-admin local account for routine execution; elevate specific commands only when justified.
- Back up only sanitized settings and reviewed skills; do not publish internal app caches or .env files.

## Verify

Capture model name, quantization, runtime version, selected context, peak RAM/VRAM, latency, API host/port, skill list and MCP tool list. Store sensitive inventory locally, not in the public repository.
