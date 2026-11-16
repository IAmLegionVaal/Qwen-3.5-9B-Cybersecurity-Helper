---
name: purple-team-validation
description: Plans controlled purple-team exercises that measure detection and response without destructive payloads.
---

# Purple-team validation

## Workflow
1. Obtain owner authorization, authorized lab assets, emulation range, detection owner, stop conditions and change window.
2. State a single ATT&CK-aligned behavior and the exact telemetry expected to observe it.
3. Prefer benign test artifacts, vendor simulation tools and mock data over real malicious payloads.
4. Write a simulation plan that describes expected process/network/event shape without making persistent, destructive or stealthy changes.
5. Coordinate with blue team; define detector, query, alert workflow and response evidence before testing.
6. Execute only the approved lab simulation with time-limited permissions.
7. Capture observed events and detections, false positives, blind spots and operational impact.
8. Improve telemetry or analytic rules, then retest and record measurable coverage.

## Exercise record
Scenario ID; authorized host; behavior; event sources; expected events; actual observed events; alert latency; analyst response; gaps; remediation; result.

## Boundaries
Do not deploy real C2, credential theft, ransomware, destructive exploits or persistence across production to prove detection. Lab realism must not override legal scope or system safety.
