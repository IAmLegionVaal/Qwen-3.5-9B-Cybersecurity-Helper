---
name: entra-m365-security-assessment
description: Audits Microsoft 365 and Entra cloud identity permissions, Conditional Access and application risk.
---

# Entra ID and Microsoft 365 security assessment

## Scope
Confirm tenant ownership, read-only Microsoft Graph permissions, authorized admin role, app registrations and data classification.

## Procedure
1. Establish tenant service-health context; identify high-privileged identities, workload identities and guest exposure.
2. Review MFA/Conditional Access coverage, break-glass accounts, sign-in logs, risky sign-ins and legacy authentication exposure.
3. Inventory enterprise applications, delegated/application Graph permissions, admin consent, application assignments and stale service principals.
4. Examine role assignments, PIM, token/session controls, device compliance and Intune enrollment baselines.
5. Review Exchange mailbox forwarding, transport configuration, SharePoint/OneDrive external sharing and audit coverage.
6. Correlate observed events with Microsoft Defender alerts and Microsoft Purview audit where licensed.
7. Provide least-privilege remediation and pilot/rollback to avoid tenant-wide user lockout.

## Safety
Do not grant broad Graph scopes merely to make a connector work. Do not disclose tenant identifiers, access tokens or user records. Never disable CA policies or rotate production secrets without an approved change process.

## Output
Control; observed configuration; evidence/time; affected scope; risk; owner; recommended change; rollback; validation.
