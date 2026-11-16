---
name: security-reporting-remediation
description: Creates professional actionable pentest reports, risk ratings, remediation and verification plans.
---

# Security assessment reporting and retesting

## Deliverables
1. Executive summary with business exposure, scope, dates and high-confidence themes.
2. Methodology and rules of engagement, plus limitations and explicitly untested systems.
3. Finding register: issue, affected asset, severity, evidence, exploit prerequisites, likelihood, business impact and root cause.
4. Concrete remediation steps with owner, priority, dependencies, maintenance window and rollback.
5. References to primary advisories, CVE/CWE and control frameworks with dates.
6. Remediation verification and retest results; differentiate fixed, partial, accepted risk, false positive and not retested.
7. Supporting appendices with safe, redacted evidence, tool versions, timing and command records.

## Evidence integrity
Do not fabricate test results, screenshots, impacted accounts, exploited records or vendor guidance. If a finding derives only from a scanner, label it unconfirmed until validated.

## Prioritization
Use severity plus exposure, business criticality, probability and remediation effort. Give highest priority to clear exploitable exposure with material business impact; do not rely solely on CVSS.

## Safety and confidentiality
Sanitize hostnames, user identities, credentials, private addresses and sensitive operational details before sharing externally. Never publish a client's assessment without their explicit authorization.
