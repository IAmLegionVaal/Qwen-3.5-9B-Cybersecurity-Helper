---
name: attack-surface-recon
description: Collects passive authorized recon and OSINT for domains, services, certificate transparency and asset inventories.
---

# Scoped reconnaissance and attack surface inventory

## Procedure
1. Confirm the Rules of Engagement and whether active probes are permitted.
2. Gather passive DNS, certificate transparency, published service records, owner-provided cloud assets and public repository metadata.
3. Note source URL, collection timestamp, ownership confidence and whether information may be stale.
4. Differentiate first-party infrastructure, CDN addresses, SaaS providers and unrelated shared IP addresses.
5. Prioritize stale DNS, unexpected admin portals, exposed storage references and certificate anomalies for manual owner validation.
6. Escalate to carefully scoped active checks only when separately authorized.

## Read-only examples
~~~powershell
Resolve-DnsName app.example.test -Type A -ErrorAction Stop
Resolve-DnsName example.test -Type MX -ErrorAction Stop
~~~

## Report
Asset; owner; source; observed technology; data freshness; evidence; hypothesis; confidence; safe follow-up.

## Safety
Do not access private data from indexed URLs. Do not treat search engine listings, certificate SANs or DNS wildcard hits as proof of current exposure. Never target a third party only because its IP is linked to the organization.
