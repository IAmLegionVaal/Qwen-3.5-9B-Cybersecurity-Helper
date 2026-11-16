---
name: active-directory-diagnostics
description: Diagnoses Active Directory DNS, replication, Kerberos, secure channel and Group Policy issues.
---

# Active Directory diagnostics

Use when investigating domain joins, domain controller health, AD DS replication, Kerberos, GPO, time skew, SYSVOL and DNS name resolution.

## Minimal-damage flow

1. Identify affected site, DCs, forests, clients, sites/subnets and time of failure.
2. Check DNS SRV records, client DNS assignment, domain controller reachability and time synchronization.
3. Inspect secure channel and Kerberos ticket behavior without resetting domain membership by default.
4. Evaluate replication and SYSVOL independently of generic network ping success.
5. Check recent GPO or DNS changes, account lockouts and authentication events.
6. Escalate directory repairs only with backups, replication health evidence and a change window.

## Examples

~~~powershell
nltest /dsgetdc:example.test
w32tm /query /status
dcdiag /test:dns
repadmin /replsummary
gpresult /r
~~~

These commands require appropriate permissions/tools and must be executed against a domain you are authorized to administer. Replace example.test with your actual internal domain locally. Do not publish domain names or replication output.

## Interpretation

A host responding to ICMP is not evidence that LDAP, Kerberos, DNS or trust paths work. Domain secure channel faults may involve machine account credentials, DC reachability or replication. A domain leave/rejoin can have side effects on profiles, certificates, applications and policy; avoid making it the first step.

## Guardrails

Never transfer NTDS.dit, credential dumps, krbtgt material or privileged session tickets to an LLM or public repository. Do not suggest disabling security controls to force domain trust repair.

## Result format

Observed checks, likely cause, confidence, next narrow test, proposed reversible remediation and rollback.
