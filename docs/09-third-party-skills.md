# 09. Third-party skills: research and review queue

The following URLs are **references for optional human review**, except the four explicitly attributed Microsoft security SKILL.md files described below. Listing a project does NOT mean its current code has been installed, scanned completely, tested, endorsed or approved. Avoid directly running installer scripts from untrusted repositories.

| Project | Focus | Review status |
| --- | --- | --- |
| https://github.com/mukul975/Anthropic-Cybersecurity-Skills | Broad security Agent Skills collection | Candidate / manual code audit required |
| https://github.com/vinayaklatthe/microsoft-security-skills | Defender, Sentinel, Entra, Intune and Azure security | Candidate / manual code audit required |
| https://github.com/Masriyan/Claude-Code-CyberSecurity-Skill | Cybersecurity guidance | Candidate / manual code audit required |
| https://github.com/hmohamed01/powershell-expert | PowerShell development and references | Candidate / manual code audit required |
| https://github.com/alirezarezvani/claude-code-skill-factory/blob/dev/generated-skills/ms365-tenant-manager/SKILL.md | Microsoft 365 tenant administration | Candidate / manual code audit required |
| https://github.com/microsoftgraph/dev-skills | Microsoft Graph development guidance | Candidate / manual code audit required |

Upstream structure, license, dependencies and safety status can change over time. Review the **exact commit SHA**, do not rely on stars alone, and check the actual LICENSE for each reviewed revision. Do not wholesale copy third-party text to this repository.

## Required audit record (copy for each project)

~~~text
Project URL:
Reviewed commit SHA:
License and reuse permissions:
Reviewer / date:
Expected task and permissions:
Inventory of executable files:
Network destinations:
Install/build hooks:
Dependency lockfile and version pins:
Indicators of encoded or obfuscated payloads:
Secrets scanning results:
Sandbox tests performed:
Risks and mitigations:
Decision: APPROVE / REJECT / HOLD
~~~

## Safe evaluation workflow

1. Clone into a disposable, unprivileged test workspace.
2. Inspect all scripts, skill frontmatter, markdown command blocks, hooks and package lifecycle scripts.
3. Review the manifest and exact versions; do not install packages during a "read-only" audit.
4. Run static checks in a controlled environment. For dynamic testing, block outbound network access unless justified.
5. Grant only minimum temporary credentials if an integration cannot otherwise be tested. Prefer mock tokens.
6. Document findings with evidence before import into Bionic.

The original skills under skills/ are provided directly as text; they are independent of these references.


## Four upstream Microsoft security skills included in this repository

At the pinned revision `02e37e1977773e6897cc3d60710b6c766c233e90` of [vinayaklatthe/microsoft-security-skills](https://github.com/vinayaklatthe/microsoft-security-skills), the following **standalone SKILL.md text files** were inspected for common API-token patterns and obvious remote-code execution strings and then copied without changing their contents: `defender-for-endpoint`, `defender-xdr`, `entra-id-protection`, and `conditional-access-mfa`. Their upstream MIT license and commit/blob hashes are retained in [PROVENANCE](../third-party/microsoft-security-skills/PROVENANCE.md).

That limited static inspection does **not** prove that an upstream skill, external references, or its eventual tool usage is safe. These skills contain guidance rather than an installed Microsoft Graph connector. Readers must obtain their own credentials/permissions, review tool behavior, and test safely.
