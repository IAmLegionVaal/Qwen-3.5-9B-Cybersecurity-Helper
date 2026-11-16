# Skills: included examples and exact installed-skill status

## The two categories must not be confused

**Included today:** Ten original, portable public skill examples under [skills/](../skills/). These are newly written reference instructions, not a verified export from the source Bionic workstation.

**Exact installed skills:** Publication pending a reviewed export from the Windows workstation. The currently known PowerShell Expert installation was under a user-profile-local path:

~~~text
%USERPROFILE%\.lmstudio\skills\powershell-expert\
  SKILL.md
  references\CATALOG.md
  references\powershell-expert.md
  scripts\Search-Gallery.ps1
~~~

The supporting files matter: an independently written one-page PowerShell skill is not equivalent to that installation. Other skills visible in Bionic might originate from other apps rather than the .lmstudio skills folder.

## Starter skill catalog

| Skill | Purpose |
| --- | --- |
| powershell-engineering | Version-correct PowerShell and error handling |
| windows-troubleshooting | Windows OS, service, event and performance problems |
| active-directory-diagnostics | AD DS, DNS, replication, trust, GPO |
| m365-entra-intune | Microsoft identity, M365 and endpoint administration |
| network-diagnostics | DNS, routing, VPN, TCP/UDP and latency |
| incident-response | Evidence preservation and containment |
| malware-triage | Defensive analysis and Windows persistence |
| web-app-security | WordPress and web application security review |
| model-quality-control | Accuracy, anti-repetition and tool use |
| mcp-tool-safety | MCP schemas, permissions and supply chain |

## Download and install the current examples

Use GitHub **Code → Download ZIP**, then inspect a selected SKILL.md and import it using Bionic **Settings → Skills**. Bionic can also install reviewed skills via URL. In chat type **@** to select a skill. Official details: https://lmstudio.ai/docs/bionic/agent/skills.

A skill supplies agent instructions; it does NOT create a shell executor, internet connection, Gemini API, or Microsoft Graph authorization.

## Acceptance criteria for the future exact bundle

The planned **verified-installed-skills/** directory must contain original file trees, checksums, immutable source references, licenses/attribution, security reviews and a Bionic import test.

If a file must be changed to remove private details, it becomes a **sanitized derivative**, never a byte-for-byte exact copy. Every change must be disclosed.

See [Exact skill export](13-EXACT-SKILL-EXPORT.md) and [third-party review queue](09-third-party-skills.md).
