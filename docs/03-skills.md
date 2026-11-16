# 03. Skills: install, select, validate

Bionic follows the Agent Skills convention. A skill is a directory containing SKILL.md and optional supporting files. Skills give **instructions**, not extra runtime privileges. A prompt claiming to use a tool cannot create a tool that the host has not actually registered.

Official reference: https://lmstudio.ai/docs/bionic/agent/skills

## Install from this repository

**Preferred:** In Bionic open Settings > Skills, select the relevant local SKILL.md, then reference it from chat using @. Menu labels may change by release.

**Alternate local staging:** After cloning and reviewing this repository, use:

~~~powershell
.\scripts\Install-Skills.ps1 -Destination "$HOME\AgentSkills" -WhatIf
.\scripts\Install-Skills.ps1 -Destination "$HOME\AgentSkills"
~~~

The destination is a user-selected staging folder. It is NOT automatically Bionic's private skills directory. Import from this staging folder using Bionic, or configure visibility through the official UI. The script refuses to overwrite existing skill folders.

## Included original skills

| Folder | When to use |
| --- | --- |
| powershell-engineering | Reliable, testable Windows automation |
| windows-troubleshooting | OS, service, event, update triage |
| active-directory-diagnostics | AD DS, DNS, replication, GPO |
| m365-entra-intune | Microsoft cloud identity/endpoint workflows |
| network-diagnostics | DNS, TCP, VPN, routing, latency |
| incident-response | Evidence preservation and containment |
| malware-triage | Defensive behavior, indicators and detection |
| web-app-security | Authorized code and WordPress security checks |
| model-quality-control | Verification, short outputs and no loops |
| mcp-tool-safety | Permission review and untrusted tool results |

## Skill verification checklist

1. Inspect every SKILL.md and accompanying executable.
2. Confirm author, license, commit hash, permissions and dependency tree.
3. Check references to shell commands, external URLs, hooks, auto-installers and remote network access.
4. Install a **single skill** in a restricted project, with no credentials.
5. Validate simple prompts, then expand scope only after review.
6. Record an explicit source and revision for any third-party component.

## Important distinction

- Agent skill: guidance the model reads and follows.
- MCP server: a separate process/service offering tools. It may read files, run commands or reach external APIs.
- Model: inference engine that generates text/tool requests.
- Harness: Bionic or another host that mediates access.
- Internet access: requires a configured tool, approved web/browser access or provider feature; a model is not automatically browsing.

See docs/09-third-party-skills.md for external projects intentionally **not** vendor-copied into this repo.
