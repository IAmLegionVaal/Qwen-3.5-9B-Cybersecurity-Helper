---
name: network-service-assessment
description: Evaluates authorized TCP and UDP services, exposure, TLS and segmentation using low-impact tests.
---

# Network service assessment

## Preflight
Check target allowlist, source subnet, written scope, maximum packet rate, service owner, scan window and escalation contact. Prefer a read-only configuration review when it answers the question.

## Procedure
1. Identify exact service and transport expected on each asset.
2. Compare owner inventory with observed DNS, host routes, firewall policy and known listeners.
3. Test specific ports rather than broad unauthenticated sweeps.
4. If allowed, use a low-rate service probe and save tool version, flags, timestamp and network origin.
5. Verify service banners against configuration and installed patch state. Banner alone does not prove vulnerability.
6. Assess protocol security, TLS, weak authentication paths and exposed management services.
7. Validate segmentation by examining policy and narrow, approved source-to-destination checks.

## Safe lab examples
~~~powershell
Test-NetConnection 192.0.2.10 -Port 443 -InformationLevel Detailed
~~~
If installed and in scope, Nmap can be used with narrow flags such as:
~~~text
nmap -sT -sV --version-light -Pn -p 80,443 192.0.2.10
~~~

Nmap is not bundled and must be installed from a trusted source. A UDP response is not evidence that the related TCP port works.

## Stop conditions
Unexpected availability issues, out-of-scope IPs, provider restrictions, rate limits or noisy findings. Record changes and remediation proposals separately; do not disable firewalls as a diagnostic shortcut.
