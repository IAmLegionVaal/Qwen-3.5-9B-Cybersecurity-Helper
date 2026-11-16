---
name: container-supply-chain-security
description: Reviews Docker containers, SBOMs, dependencies and CI workflows for known configuration and supply chain risks.
---

# Container and supply-chain security review

## Process
1. Confirm authorized source repository, build pipeline, image provenance, dependency lockfiles and release process.
2. Inspect Dockerfile for pinned base image digest, user privileges, minimal packages, copy scope and sensitive build arguments.
3. Review Kubernetes/container privileges, host mounts, capabilities, network egress, resource limits, read-only root filesystem and secret mounts.
4. Produce an SBOM with an approved tool; scan dependency versions against dated advisories using a configured vulnerability feed.
5. Inspect CI triggers, third-party actions, artifact integrity, token scope and whether untrusted pull requests can access secrets.
6. Avoid remote install commands without reviewing the exact revision and its transitive dependencies.
7. Document risk, compensating controls, remediations and rollback with a reproducible build/test.

## Example questions
- Is a container running as root unnecessarily?
- Is the base image pinned or mutable?
- Are GitHub Actions pinned to a trusted revision?
- Can an untrusted PR reach deployment secrets?
- Do build logs expose tokens?

## Deliverable
Prioritized configuration findings, evidence links, severity, tested remediation and CI hardening recommendations. No automatic deployment or registry publication.
