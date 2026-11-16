---
name: memory-forensics-triage
description: Analyzes authorized memory acquisition and volatility-based artifacts for defensive investigations.
---

# Defensive memory forensics

## Workflow
1. Establish evidence authority and chain-of-custody requirements. Memory captures can contain passwords, tokens and private user data.
2. Document acquisition tool, OS/kernel version, memory image size, collection time and hash.
3. Work from an isolated evidence copy; never upload a dump to public repositories or online model providers.
4. Use a reputable forensic framework such as Volatility 3 (installed separately) and a matching symbol/profile strategy.
5. Examine process trees, process command lines, suspicious mappings, network connections and loaded modules; correlate with host/EDR logs.
6. Validate anomalies against legitimate OS behaviors and acquisition limitations.
7. Write findings as evidence-backed hypotheses, with IOC candidates and recommended containment approvals.

## Safe sample command structure
~~~text
python vol.py -f /path/to/approved-memory-image windows.info
~~~

The path is illustrative, not a bundled sample. Do not execute unknown memory-resident code.

## Stop conditions
Unapproved access to personal data, privileged tokens, confidential documents or production memory must trigger restricted evidence handling, not publication.
