---
name: cloud-security-review
description: Assesses authorized Azure and other cloud configuration risks, identity paths and exposure.
---

# Cloud security posture review

## Workflow
1. Obtain cloud tenant/subscription/project authorization and define permitted read-only API scopes.
2. Enumerate security settings: external exposure, identity roles, workloads, storage, network segmentation, key management, backup and logging.
3. Review public storage, management endpoints, insecure defaults, excessive IAM permissions, service principals and secrets lifecycle.
4. Inspect IaC sources and policy-as-code controls before suggesting console changes.
5. Correlate cloud audit events with Defender/SIEM telemetry; document observation timestamps and evidence.
6. Prioritize risk by business impact and reachable attack paths, not only configuration scores.
7. Recommend least-privilege changes with pilot environment, explicit approvals, rollback and post-change monitoring.

## Tool boundaries
Azure CLI, Microsoft Graph and CSPM tools require separately configured identities. Prefer read-only tokens in this assessment. Never copy subscription, tenant, client IDs, deployment secrets or cloud access keys into public findings.

## Deliverable
Control, observed condition, affected resources, verification source, impact, remediation, safe change plan and retest. Do not claim active compromise from configuration exposure alone.
