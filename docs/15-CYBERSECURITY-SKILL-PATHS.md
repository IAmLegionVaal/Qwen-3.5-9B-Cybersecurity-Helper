# 15. Cybersecurity and authorized pentesting skill paths

This repository is designed for **defensive security engineering, authorized security assessments and reproducible learning**. Download the complete repository ZIP through **Code > Download ZIP**, then import chosen SKILL.md directories into Bionic. Skills are instructions, not executable tool installations.

## What is included

- **10 original starter skills** covering PowerShell, Windows, AD, Microsoft 365, networking, incident response, malware triage, web security, model quality and MCP safety.
- **18 additional original security and pentest skills** in the table below.
- **4 verbatim third-party Microsoft security skills** with MIT-license attribution and an immutable upstream revision in [the provenance record](../third-party/microsoft-security-skills/PROVENANCE.md).

**Total: 32 SKILL.md directories.** The separate historical workstation bundle remains unverified; this is a newly curated public package.

| Skill | Focus |
| --- | --- |
| [pentest-engagement-planning](../skills/pentest-engagement-planning/SKILL.md) | Scope, Rules of Engagement, authorization |
| [attack-surface-recon](../skills/attack-surface-recon/SKILL.md) | Passive OSINT and asset inventory |
| [network-service-assessment](../skills/network-service-assessment/SKILL.md) | Low-impact ports and service exposure |
| [vulnerability-triage-validation](../skills/vulnerability-triage-validation/SKILL.md) | Scanner result evidence and patch validation |
| [web-app-pentest-methodology](../skills/web-app-pentest-methodology/SKILL.md) | OWASP web assessment |
| [api-auth-testing](../skills/api-auth-testing/SKILL.md) | API security and object-level authorization |
| [active-directory-security-assessment](../skills/active-directory-security-assessment/SKILL.md) | Domain permissions and hardening |
| [entra-m365-security-assessment](../skills/entra-m365-security-assessment/SKILL.md) | Tenant permissions, Conditional Access, M365 risks |
| [cloud-security-review](../skills/cloud-security-review/SKILL.md) | Cloud identity, storage and network exposure |
| [log-hunting-sigma-kql](../skills/log-hunting-sigma-kql/SKILL.md) | Hunting hypotheses, Sigma and KQL |
| [digital-forensics-windows](../skills/digital-forensics-windows/SKILL.md) | Windows event and artifact triage |
| [malware-static-reverse-engineering](../skills/malware-static-reverse-engineering/SKILL.md) | Static behavior analysis |
| [memory-forensics-triage](../skills/memory-forensics-triage/SKILL.md) | Defensive memory artifact inspection |
| [phishing-email-triage](../skills/phishing-email-triage/SKILL.md) | Email headers, impersonation, BEC |
| [container-supply-chain-security](../skills/container-supply-chain-security/SKILL.md) | Container, SBOM and CI supply chain |
| [purple-team-validation](../skills/purple-team-validation/SKILL.md) | Detection simulations using benign artifacts |
| [security-reporting-remediation](../skills/security-reporting-remediation/SKILL.md) | Findings, risk and retesting |
| [llm-mcp-security-assessment](../skills/llm-mcp-security-assessment/SKILL.md) | Agent tools, prompt injection and secret boundaries |
| [defender-for-endpoint](../skills/defender-for-endpoint/SKILL.md) | Original upstream MDE guidance; MIT |
| [defender-xdr](../skills/defender-xdr/SKILL.md) | Original upstream incident correlation; MIT |
| [entra-id-protection](../skills/entra-id-protection/SKILL.md) | Original upstream risk-based identity protection; MIT |
| [conditional-access-mfa](../skills/conditional-access-mfa/SKILL.md) | Original upstream MFA/CA controls; MIT |

## Which skill should I start with?

### Blue team / incident response
Use incident-response + phishing-email-triage for suspicious emails, digital-forensics-windows for endpoint evidence, log-hunting-sigma-kql for queries, malware-static-reverse-engineering for unknown files, then security-reporting-remediation. Choose **one or two** at a time on a 9B model to avoid context overload.

### Authorized internal pentesting
Start with pentest-engagement-planning to establish exact permission and scope. Follow with attack-surface-recon, network-service-assessment, active-directory-security-assessment or entra-m365-security-assessment as appropriate, vulnerability-triage-validation for results, then security-reporting-remediation.

### Web/API pentesting
Use pentest-engagement-planning, web-app-pentest-methodology, api-auth-testing and vulnerability-triage-validation. Use staging/test accounts, safe sample records and a scoped proxy. Avoid introducing destructive fuzzing or actual customer data into an LLM context.

### Purple team / detection validation
Use purple-team-validation with a named benign exercise, log-hunting-sigma-kql, defender-xdr and incident-response. Create a measurable observation plan: expected events, alerts, latency, containment decision and retest.

### Cloud / identity
Use cloud-security-review, entra-m365-security-assessment, conditional-access-mfa, entra-id-protection and defender-for-endpoint. Read-only inventory first; privileged policy changes require staged rollout and a recovery plan.

### Local LLM attack surface
Use llm-mcp-security-assessment and mcp-tool-safety to check whether a skill, tool response or connected provider could cause unauthorized file reads, credential disclosure or outbound transfer. Use **synthetic tokens and dummy files** for negative testing.

## Tools worth learning separately

None of these binaries is automatically installed or bundled with a SKILL.md. Obtain them from official sources and verify the license and version before use.

| Tool | Purpose | Cautions |
| --- | --- | --- |
| Nmap | Network service inventory | Scope, rate limits and safe scan profiles |
| Wireshark | Protocol inspection | Captures may contain sensitive data |
| OWASP ZAP | Web testing | Use passive mode/staging before active scanners |
| Ghidra | Static reverse engineering | Isolate unknown samples |
| Volatility 3 | Memory forensics | Memory dumps can contain credentials |
| YARA / Sigma | Detection and artifact classification | Verify rules and telemetry |
| Microsoft Defender / Sentinel | Enterprise detection and hunting | Tenant permissions, licensing, sensitive logs |
| Burp Suite | Web proxy/test workflow | Respect scope and licensing |
| Greenbone / Nessus | Vulnerability inventory | Validate scanner findings, avoid disruptive checks |

Each tool requires an **actual installation** and may require an MCP integration or supported host shell to be used by a local model. A skill does not grant access to these programs.

## Pentesting safety and verification

- **Written owner authorization and fixed target allowlist** are prerequisites to active testing. Shared hosting, cloud platforms and third-party systems often require separate permission.
- No denial of service, credential harvesting, unapproved persistence, data exfiltration or destructive actions under a generic assessment authorization.
- Prefer staging, read-only checks and test records. Even apparently harmless scans can stress fragile services; set stop conditions and keep contacts available.
- Use least privilege and review all agent-generated tool calls. Never hand a local model an unrestricted privileged terminal or access to real secrets.
- Do not publish raw pentest output containing internal names, credentials or personally identifying data.

## Hardware and reliability

The Lenovo LOQ example uses **16 GB RAM, RTX 5060 Laptop GPU with 8 GB VRAM and Qwen3.5-9B**. Adding more skills to GitHub does not mean they all should be loaded at once. Larger prompts, tool schemas and output may increase context/memory pressure and cause slowdowns or incorrect tool choices. Performance varies by machine and quantization. Review [hardware and risk guidance](11-REFERENCE-HARDWARE.md).

## Trust labels

- **Original:** written for this repository; a public starting point, not production-certified.
- **Third-party copied:** original upstream SKILL.md copied with license and immutable revision; static inspection performed, but no universal malware-free claim.
- **External candidate:** linked to an upstream project, NOT bundled or installed; requires independent review.

See [third-party source checklist](09-third-party-skills.md) for additional larger collections. Any tool claims or security test results must be independently verified in the user's authorized environment.
