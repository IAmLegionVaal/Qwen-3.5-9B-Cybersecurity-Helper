---
name: digital-forensics-windows
description: Guides authorized Windows host forensic collection, artifact interpretation and chain of custody.
---

# Windows forensic triage

## Priorities
Preserve evidence and minimize live-system changes. Choose collection order based on volatility, incident severity and organizational chain-of-custody policy.

## Procedure
1. Record asset authority, examiner, time, UTC offset, evidence IDs and current system state.
2. Decide between live triage and forensic imaging with the incident lead; do not assume the operator should power off a live endpoint.
3. Collect approved telemetry: Security/System logs, PowerShell logs, Task Scheduler, services, Autoruns entries, Prefetch, Amcache, Shimcache, SRUM, registry hives, $MFT/USN data and relevant EDR metadata.
4. Use a trusted, repeatable acquisition tool with known version and hashes; write output to a controlled evidence destination.
5. Compute SHA-256 for preserved artifacts and maintain acquisition and access records.
6. Normalize timestamps; correlate user/process/network events and note collection limitations.
7. Distinguish artifact existence from executable proof. A Prefetch entry or Run key alone may not establish malicious intent.

## Safe example
~~~powershell
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PowerShell/Operational';StartTime=(Get-Date).AddDays(-1)} -MaxEvents 100
~~~

## Guardrails
Do not extract user credentials, memory dumps or sensitive personal files into public prompts. Use isolated storage and approved tools. Report observed evidence, alternative explanations and confidence.
