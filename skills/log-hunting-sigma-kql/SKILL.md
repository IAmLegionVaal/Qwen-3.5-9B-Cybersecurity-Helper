---
name: log-hunting-sigma-kql
description: Develops and validates defensive event queries, Sigma rules and Microsoft KQL hunting hypotheses.
---

# Detection engineering with Sigma and KQL

## Procedure
1. State threat behavior and expected telemetry source before writing a detection.
2. Identify events and available fields, audit policy, host versions, time zones, clock skew and retention.
3. Map observable behavior to ATT&CK cautiously; avoid relying solely on filenames or a single string IOC.
4. Build a readable query or rule with field typing, source filters and a bounded lookback window.
5. Validate syntactic correctness using the actual SIEM/schema. Do not claim a query ran without tool output.
6. Test with sanitized positive/negative examples; measure false positives and resource cost.
7. Document thresholds, suppression, triage enrichment and response escalation.

## KQL example (Microsoft Defender Advanced Hunting)
~~~kusto
DeviceProcessEvents
| where Timestamp > ago(24h)
| where FileName =~ "powershell.exe"
| summarize Events=count() by DeviceName
| order by Events desc
~~~
This counts process events; it does **not** on its own detect compromise. Table availability depends on licensing and product. Do not publish real device names.

## Output
Detection hypothesis, data prerequisites, rule/query, test results (if executed), limitations, false-positive strategy, ATT&CK context and triage playbook.
