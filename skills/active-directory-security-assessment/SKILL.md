---
name: active-directory-security-assessment
description: Audits authorized AD DS exposure, privilege pathways, password policy and authentication hardening.
---

# Active Directory security assessment

Designed for defensive domain reviews and authorized internal penetration testing; start with read-only collection.

## Procedure
1. Obtain permission and domain scope, privileged account constraints, DC maintenance rules and evidence storage.
2. Check AD replication and DNS health before attributing authentication failures to malicious activity.
3. Review tiered privilege, nested group memberships, service accounts, delegated permissions and stale accounts.
4. Assess Kerberos/NTLM policy, LDAP signing/channel binding, SMB signing, unconstrained delegation risk and secure channel configurations.
5. Examine local administrator exposure, credential protection, LAPS, Protected Users, privileged workstation policy and patch baselines.
6. Review AD CS template permissions and enrollment exposure with authorized read-only configuration collection.
7. Investigate GPO links, OU permissions, security filtering and high-impact ACLs.
8. Validate potential attack paths via permission graph reasoning; **do not** dump credential material or run live relay/coercion attacks without separately documented lab scope.

## Safe example
~~~powershell
Get-ADDomain
Get-ADGroupMember -Identity 'Domain Admins'
Get-ADDefaultDomainPasswordPolicy
~~~

Requires ActiveDirectory RSAT and appropriate privileges. Avoid publishing account/group membership outputs.

## Deliverables
Exposure matrix, least-privilege gaps, prioritized mitigations, operational risks, rollback and post-fix verification.
