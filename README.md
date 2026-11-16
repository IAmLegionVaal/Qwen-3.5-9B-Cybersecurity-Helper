# Qwen 3.5 9B Cybersecurity Helper

**A reproducible local AI workstation for technical support, incident response and defensive security analysis.**

This community-maintained starter kit combines [Qwen3.5-9B](https://huggingface.co/Qwen/Qwen3.5-9B), [LM Studio Bionic](https://lmstudio.ai/docs/bionic), portable Agent Skills, practical PowerShell utilities and optional MCP integrations.

> **Implementation status:** This repository contains original reference implementations, checked-in skills and configuration **templates**. It is not a verified export of an individual's installed workstation, and it does not claim external skills or MCP servers have been installed or audited. See [Validation](docs/10-validation.md).

## Features

- Guided Windows 11 setup with a realistic 8 GB VRAM / 16 GB RAM starting point.
- Ten original, portable Agent Skills: PowerShell, Windows, Active Directory, Microsoft 365, networking, incident response, malware triage, web application review, model reliability and MCP safety.
- Reusable agent instructions: accurate diagnostics, no fabricated results, controlled tool use, no answer loops.
- Local OpenAI-compatible model API diagnostics and portable inventory export.
- Optional cloud escalation pattern with explicit user consent and data classification.
- Example MCP configuration, secret hygiene, CI secret scanning and skill validation.
- Restore and troubleshooting guides with a curated third-party skills review queue.

## Setup in 5 steps

1. Install [LM Studio Bionic](https://lmstudio.ai/docs/bionic) and download a supported Qwen3.5-9B quantization. Quantization size and runtime compatibility vary.
2. In Bionic, create a project. Enable coding only for a dedicated, trusted workspace. Select a compatible local model.
3. Review [Windows setup](docs/01-windows-setup.md), [Model tuning](docs/02-model-tuning.md) and [Agent prompt](agent/SYSTEM_PROMPT.md).
4. Open Bionic **Settings > Skills**, add the SKILL.md files in [skills](skills), or inspect the local-only [installer](scripts/Install-Skills.ps1). Skills are instructions, **not automatically extra tools**.
5. If the **separate LM Studio API server** is running, test its endpoint:

~~~powershell
.\scripts\Test-LocalModel.ps1 -BaseUrl 'http://127.0.0.1:1234'
~~~

The default LM Studio REST/API endpoint is 1234. Another configured Bionic/LM Studio instance may use port 1235. Always check the actual listening address; never expose an unauthenticated local inference API to the internet.

## Documentation

| Guide | Content |
| --- | --- |
| [01 Windows setup](docs/01-windows-setup.md) | Prerequisites, installation, first run |
| [02 Model tuning](docs/02-model-tuning.md) | Quantization, hardware, context, stability |
| [03 Agent Skills](docs/03-skills.md) | Installing and testing skills |
| [04 MCP integrations](docs/04-mcp-integrations.md) | Tools, least privilege, secrets |
| [05 Cloud fallback](docs/05-cloud-fallback.md) | Optional second-opinion escalation |
| [06 Security & secrets](docs/06-security-and-secrets.md) | Threat model, confidentiality, secret scanning |
| [07 Troubleshooting](docs/07-troubleshooting.md) | Common faults and checks |
| [08 Rebuild & maintenance](docs/08-rebuild-and-maintenance.md) | Backups, restoring and updates |
| [09 External skill references](docs/09-third-party-skills.md) | Upstream research, licenses and review gates |
| [10 Validation](docs/10-validation.md) | Reproducible acceptance tests |

## Structure

~~~text
agent/             System prompt and regression prompts
config/            Generic JSON and environment templates
docs/              End-to-end runbooks
scripts/           PowerShell diagnostics, inventory and skill installer
skills/            Ten original Agent Skills (SKILL.md)
tools/             Offline Python validation utilities
tests/             Standard-library unit tests
.github/workflows/ Automated safety and skill-format checks
~~~

## Privacy / permissions

- No real tokens, passwords, enterprise names, device inventories, user profiles or customer information are included.
- All example tokens are placeholders; never commit a populated .env or copied MCP credentials.
- External skills and MCP servers can execute commands and access data: review their code and dependencies before using them.
- Require authorization and human review for destructive or production changes.

## Primary sources

- [Bionic product and project model](https://lmstudio.ai/docs/bionic)
- [Bionic skills](https://lmstudio.ai/docs/bionic/agent/skills)
- [LM Studio local API](https://lmstudio.ai/docs/developer/core/server)
- [Qwen3.5-9B model card](https://huggingface.co/Qwen/Qwen3.5-9B)

Original repository content is licensed under [MIT](LICENSE). Third-party software has its own terms. Not endorsed by, sponsored by or affiliated with the named projects.
