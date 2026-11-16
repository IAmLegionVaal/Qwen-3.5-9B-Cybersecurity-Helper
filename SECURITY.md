# Security policy

Please report sensitive security findings through GitHub's private vulnerability reporting if enabled for this repository, rather than pasting exploit details or secrets into public issues.

## Never publish

API keys, OAuth access/refresh tokens, private keys, client secrets, cookies, browser profiles, customer data, support tickets, machine-specific inventories, credential-containing MCP configuration or unredacted logs.

## Response to accidental exposure

1. Revoke/rotate the affected credential at its issuer immediately.
2. Disable the integration if compromise is suspected; examine service audit logs.
3. Remove the credential from tracked files; assess all reachable commits, tags, branches, forks and cached copies.
4. Rewrite history if appropriate, coordinate with collaborators and treat previously pushed values as compromised even after removal.
5. Add a regression test to block recurrence. Do not post the leaked value in the issue.

See [the threat model](docs/06-security-and-secrets.md). The bundled scanner is **defense in depth**, not proof that a repository contains no secrets.
