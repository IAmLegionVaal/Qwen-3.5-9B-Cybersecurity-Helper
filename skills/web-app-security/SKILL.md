---
name: web-app-security
description: Reviews authorized web applications and WordPress plugins for common security defects.
---

# Web application and WordPress security

Use for source review, WordPress plugin/theme audits, website configuration hardening and OWASP-style application risk analysis.

## Review

1. Confirm authorization, target scope, code version and environment.
2. Inventory the app, CMS/plugin versions and exposed interfaces.
3. Perform static review for SQL injection, cross-site scripting, CSRF, broken access control, SSRF, file upload validation, unsafe deserialization and hardcoded secrets.
4. Check WordPress capability/nonce validation for privileged AJAX/REST operations; distinguish authentication from authorization.
5. Review dependency manifests, update channels and permissions before installing tools.
6. Prefer reproducible tests in a staging environment and non-destructive demonstrations.
7. Provide prioritized findings, evidence, severity rationale, affected paths and mitigation.

## WordPress review prompts

- Does each privileged REST handler declare an appropriate permission_callback?
- Does a state-changing form verify a nonce AND permissions?
- Are database queries parameterized using the WordPress API correctly?
- Is output escaped for its HTML/attribute/URL/JS context?
- Are file uploads validated beyond client-supplied extension/MIME values?
- Are credentials stored in code or logs?

## Limits

Do not change a live website, install plugins, remove protections or run aggressive scanners without approval. An MCP integration must use the least privileged application identity and present an auditable tool list.

## Expected result

Short executive finding and technically precise fix including safe test/verification and rollback path.
