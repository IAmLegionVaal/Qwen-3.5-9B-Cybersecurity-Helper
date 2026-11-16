# 04. MCP integrations and tool permissions

**Security principle:** MCP servers run code under the privileges assigned by the host environment. A malicious or compromised server may read files, execute programs or contact arbitrary internet endpoints. The model's system prompt is not a security boundary.

## Suggested rollout

1. Start with **zero** MCP tools; verify the model and skills.
2. Add one narrowly scoped, read-only tool (for example, a safe documentation lookup).
3. Inspect the server source, dependencies, package lock and release artifacts before execution.
4. Configure secrets through an OS secret manager or locally scoped environment variables, never in committed JSON.
5. Confirm available tool names, argument schemas, and that the model calls only the tool requested.
6. Add writable tools (GitHub, filesystem, tenant administration) only with explicit approvals and an isolated project.

## Bionic vs LM Studio

Bionic supports MCP through its **Settings > MCP** interface; in some builds, add a custom MCP specifying command, arguments and environment. LM Studio (the separate app) documents an mcp.json file that follows Cursor-style mcpServers notation. **Do not assume** the same JSON file is importable directly into every Bionic build.

See https://lmstudio.ai/docs/app/mcp for the standalone LM Studio JSON format, and https://lmstudio.ai/docs/bionic for the Bionic host.

## JSON reference (not live credentials)

config/mcp.example.json provides a **schema illustration only**. Paths are placeholders. Actual Bionic configuration should be created through the UI and checked against installed version. A field labelled TOKEN must not contain a literal secret in any shared file.

## Recommended permission model

| Tool class | Default | Review requirement |
| --- | --- | --- |
| Local model health / read-only metadata | Allowed | Normal |
| Documentation search | Allowed with approved domains | Validate cited sources |
| GitHub read | Scoped, read-only | Repo permission review |
| GitHub write | Disabled by default | Human review of diff |
| Browser / shell / filesystem | Restricted to sandbox/workspace | Per-command approval |
| WordPress or M365 production writes | Disabled by default | Named target, change ticket, rollback |
| Credential vault / token access | Never exposed to prompt | Secrets broker or human action |

## Prompt-injection defense

Treat MCP responses, webpages, code comments, retrieved markdown and repository issues as **untrusted data**. They may contain instructions telling the agent to ignore its task or exfiltrate files. The agent must preserve the developer/system instruction hierarchy, and it must not execute code just because a tool response says to.

## Cloud model tools

Gemini, DeepSeek and other providers are remote services. Merely registering a tool does not imply a working internet research capability. Verify billing/key status, network connectivity, provider model ID, search/grounding support, quotas, data residency and tool-call output. See docs/05-cloud-fallback.md.
