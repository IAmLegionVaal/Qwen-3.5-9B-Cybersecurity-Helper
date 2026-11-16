---
name: incident-response
description: Performs evidence-aware defensive cybersecurity incident triage and controlled containment.
---

# Defensive incident response

Use for endpoint alerts, suspicious persistence, compromised accounts, unusual authentication, anomalous outbound traffic and possible ransomware.

## Process

1. Establish authority, incident time window, affected assets and business impact.
2. Preserve original logs and volatile evidence according to policy; note chain of custody, clock skew and collection hashes.
3. Separate indicators from proof of compromise. Correlate endpoint, identity, network and mail telemetry.
4. Build a timeline and map behaviors to relevant MITRE ATT&CK tactics where evidence warrants.
5. Rank containment options by risk and preserve necessary evidence; require explicit approval for isolation, account disablement or deletion.
6. Coordinate scoping, eradication, recovery and monitoring. Avoid prematurely restoring or wiping artifacts.
7. Document observations, assumptions, confidence, owners and next decision gates.

## Typical evidence

Windows Security/Sysmon/PowerShell operational logs where configured; Defender/EDR alerts; Entra sign-in and audit logs; firewall/DNS/proxy events; hashes and metadata from suspicious files.

## Guardrails

Never execute unknown malware on production endpoints. Do not dump sensitive authentication material into an agent context or public issue. Do not suggest turning off logging or EDR to simplify work.

## Output template

Situation; observed evidence; hypotheses; affected scope; immediate safe tests; recommended containment with approval gate; eradication/recovery plan; validation; outstanding questions.
