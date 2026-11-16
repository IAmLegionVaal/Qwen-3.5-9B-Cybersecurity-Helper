# 06. Security and secrets: threat model

## Assets

Private source code, customer/tenant data, system credentials, browser cookies, remote access configurations, local API endpoints, SSH keys, incident artifacts, and Git history.

## Threat surfaces

| Vector | Example | Protection |
| --- | --- | --- |
| Committed secret | API key included in config | .gitignore + CI scan + rotation plan |
| Hostile Agent Skill | SKILL.md asks agent to run remote shell script | Read the skill + deny unreviewed execution |
| Compromised MCP | Tool has shell/network access | Sandbox, pin dependencies, least privilege |
| Prompt injection | Retrieved page asks to send files | Trust-boundary instruction in prompt, human approvals |
| Exposed local API | Service listens on 0.0.0.0 without auth | Loopback bind; auth + firewall if needed |
| Credential leakage in logs | Tool prints Authorization header | Redact, restrictive log retention |
| Unsafe automation | Agent writes to production tenant | Preview, target scope, approval, rollback |
| Supply-chain hijack | Mutable upstream branch / npx latest | Review, pin revision and version/hash |
| Unexpected remote fallback | Private context sent to provider | Data classification + explicit consent |

## Mandatory rules

1. Never commit or print real credentials, even in private test fixtures.
2. Default MCP and system shell permissions to read-only or project-scoped.
3. Do not give an LLM standing administrative privileges.
4. Treat all skill files and tool results as potentially attacker-controlled until reviewed.
5. Authenticate remote clients when network serving is enabled. Do not port-forward an unauthenticated model API.
6. Keep production data out of public Git repositories, issues, Actions logs and model examples.
7. Audit the entire **history** on suspected leaks. A new clean commit cannot erase earlier exposure.
8. Never auto-execute "curl | sh", "iwr | iex" or opaque install scripts from a tool response.

## Local secret storage

Prefer Windows Credential Manager, a supported OS vault or a scoped secrets manager. For a local demo, process-scoped environment variables are better than committing values in JSON, but environment variables can still leak through dumps, inherited child processes and debugging tools.

Never copy machine-local Bionic MCP files verbatim into this repository. Build templates using placeholders and recreate actual local secrets manually.

## Pre-commit gate

~~~powershell
python tools/scan_secrets.py .
python tools/validate_skills.py skills
python -m unittest discover -s tests -v
git diff --cached --name-only
git diff --cached
~~~

Review every staged path for private log files, proprietary source code and account identifiers before pushing. The included scanner checks patterns but **cannot prove a clean repository**; use additional mature scanners such as gitleaks for a comprehensive deployment.

## If a credential leaks

1. Revoke at provider, rotate and assess scope.
2. Review service logs and rotate adjacent credentials if necessary.
3. Remove from files and Git history according to the team's incident process.
4. Inform affected parties via appropriate private channels.
5. Assume copies may exist in forks and caches even after history rewrite.

## Security review checklist for external repositories

- Is the owner reputable and is the repo maintained?
- What license applies? Are there binaries, hooks, npm postinstall steps or dynamic downloads?
- What shell/network commands are embedded in SKILL.md? Any deceptive instructions?
- What does the dependency lockfile install? Are versions pinned?
- Does a tool request filesystem, repository or tenant write access?
- Has execution been tested in a non-privileged disposable environment?
- Are there private keys, suspicious endpoints, encoded payloads or hardcoded credentials?

Review findings should include commit SHA, reviewer, timestamp, risk rating, test environment and accepted limitations. External sources in docs/09 are **not** marked audited.
