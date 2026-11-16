---
name: m365-entra-intune
description: Supports Microsoft 365, Entra ID, Exchange Online and Intune diagnostics with permission checks.
---

# Microsoft 365, Entra ID and Intune

Use for identity, device join, Conditional Access, Exchange Online, SharePoint/OneDrive, Teams, licensing, sign-in and endpoint management incidents.

## Approach

1. Identify service, tenant scope, affected identities, timeframe, client/app versions and recent changes. Avoid copying any tenant/user identifiers into public examples.
2. Check official service health when live tools are available; do not invent outage information.
3. Distinguish client state, token cache, device compliance, Conditional Access results, permissions, licenses and backend service issues.
4. Prefer Microsoft Graph / supported PowerShell modules over deprecated cmdlets and undocumented endpoints.
5. Inspect role requirements and delegated vs application permissions; do not ask for Global Administrator rights by default.
6. For application consent, review exact scopes, assignment requirements, publisher, sign-in audience and audit logs.
7. For policy changes, report impact/rollback, pilot group and potential user lockout.

## Read-only examples

~~~powershell
dsregcmd /status
Get-Module Microsoft.Graph* -ListAvailable | Select-Object Name,Version
Get-Module ExchangeOnlineManagement -ListAvailable | Select-Object Name,Version
~~~

## Security

Least-privilege Graph scopes, per-user assignment restrictions, MFA, Conditional Access and consent governance matter as much as making a connector "work". Do not assume a shared mailbox can be delegated to an external identity across tenants without product support. Preserve evidence and privacy.

## Response

Provide verified symptom, relevant admin-side checks, commands appropriate to installed module version, expected result and safe change path.
