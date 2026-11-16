---
name: api-auth-testing
description: Reviews authorized API authentication, authorization, schemas, input handling and rate limits.
---

# API authentication and authorization assessment

Use for an API whose owner supplies explicit test endpoints, scopes, dummy data and test identities.

## Method
1. Review API specification, permission scopes, environments, test roles and rate limits.
2. Inspect where access tokens are issued, validated, rotated and revoked. Never paste live tokens into a prompt or repository.
3. Confirm that authentication and per-object authorization are implemented server-side, including ownership and tenant isolation.
4. Evaluate least-privilege scopes, token audience/issuer/expiration, authorization on nested resources, and default-deny behavior.
5. Check request schema validation, pagination/resource limits, idempotency, safe errors and sensitive response fields.
6. Examine throttling and abuse monitoring using **owner-approved low-volume** tests; do not stress the API with uncontrolled traffic.
7. Use dummy records to document expected/observed access outcomes across test identities.

## Common risk categories
Broken object-level authorization, broken function-level authorization, excessive data exposure, unsafe mass assignment, missing tenant isolation and insecure third-party integration.

## Evidence
Endpoint class; allowed role; authentication method; intended authorization decision; observed result; sanitized request/response; remediation and regression test.

## Safety
Do not enumerate real users or exfiltrate private records. Avoid placing access tokens in HTTP examples; use a local secret store and redact all traces.
