# Qwen 3.5 9B Cybersecurity Helper

**A reproducible local AI workstation for technical support, incident response and defensive security analysis.**

> **START HERE: [Complete setup walkthrough](docs/00-START-HERE.md).** This guide includes the Lenovo LOQ reference hardware, model settings, a full system prompt, skill instructions, and practical MCP connection recipes.

> **HARDWARE & SECURITY WARNING:** Performance and resource usage vary with RAM, VRAM, GPU driver, quantization, model context and concurrent tools. Incorrect setup, elevated shell access, untrusted skills or excessive tuning can lead to instability, overheating, data loss, unauthorized changes or security compromise. Normal supported LLM inference should operate within hardware protections, but do not bypass cooling, firmware, voltage or safety mechanisms. Back up your files, use a restricted workspace, monitor temperatures and review commands before execution. **Follow this guide at your own risk.** Read [reference hardware and risks](docs/11-REFERENCE-HARDWARE.md).

> **EXACT SKILL STATUS:** The existing 10 skills in this repo are newly authored reference skills, **not** an export of the original workstation's complete installed skills. [Exact skill export and review](docs/13-EXACT-SKILL-EXPORT.md) explains how to publish the original supporting files and scripts lawfully and without exposing secrets. **Do not represent the current example skills as a verified identical installation.**

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

## Download / quick access

For a simple downloadable ZIP, click **Code → Download ZIP** on this repository. The public SKILL.md files can then be imported through **Bionic Settings → Skills**. A reviewed release containing the exact source-machine skills **does not yet exist**; don't confuse a starter ZIP with an identical workstation backup.

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
| [00 Full walkthrough](docs/00-START-HERE.md) | End-to-end setup and pass/fail gates |
| [11 Hardware and risks](docs/11-REFERENCE-HARDWARE.md) | Lenovo LOQ reference settings, performance variance and safety |
| [12 Skill catalog](docs/12-SKILL-CATALOG.md) | Original examples vs exact installed skills |
| [13 Exact skill export](docs/13-EXACT-SKILL-EXPORT.md) | Preserving real skills, scripts, references and checksums |
| [14 Connection recipes](docs/14-CONNECTION-RECIPES.md) | PowerShell, GitHub, WordPress and Gemini |
| [Complete system prompt](agent/SYSTEM_PROMPT-COMPLETE.md) | Public-safe, detailed Bionic agent instructions |
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

Original repository content is licensed under [MIT](LICENSE). Third-party software and imported skills retain their own terms; no blanket redistribution permission is implied. Not endorsed by, sponsored by or affiliated with the named projects.


## Offline MCP tool test: no account or API key required

Before connecting GitHub, WordPress or Gemini, test a **network-free MCP echo server** included in [mcp-servers/echo](mcp-servers/echo/README.md). It has one short-string tool, **echo**, and no filesystem, shell, internet or credential permissions. It helps distinguish Bionic/MCP protocol problems from third-party authentication problems.

~~~powershell
node --check .\mcp-servers\echo\server.mjs
node .\mcp-servers\echo\test.mjs
~~~

A successful test confirms the demo protocol responds correctly on the test machine, **not** that every external MCP server will work.
