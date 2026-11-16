# Connection recipes: what each integration does and how to reproduce it

> **Status:** This is public-safe documentation of connection types used or explored in the reference workstation. It is not a dump of live local MCP configuration. No token, private endpoint, production tenant, real website or company name is included.

## 1. Understand the layers

| Layer | Example | Provides |
| --- | --- | --- |
| Local model | qwen/qwen3.5-9b | Generates responses and tool requests |
| Bionic | LM Studio Bionic | Agent workspace, model orchestration, skill access, MCP host |
| Skill | PowerShell Expert SKILL.md | Repeatable instructions, references and examples |
| MCP server | PowerShell, GitHub, WordPress, Gemini | Actual executable tools exposed to the host |
| Local API | http://127.0.0.1:1234/v1 or custom 1235 | Programmatic inference endpoint if enabled |
| Internet search | Approved search tool or provider grounding | Up-to-date retrieval; separate from a model API |

**Only give a tool the permissions its work requires.** The model can propose a call but the host or MCP server actually executes it. Connection state does not guarantee a successful tool call.

## 2. Local Qwen inference

Bionic can use a downloaded local Qwen3.5-9B model. Choose the model in the Bionic session, then validate a short response before adding tools.

One reference setup also exposed a local OpenAI-compatible API at **http://localhost:1235/v1**. The standalone LM Studio API server commonly uses **127.0.0.1:1234** by default, but these ports are configurable and different products may manage their own process.

Read-only diagnostic:

~~~powershell
Test-NetConnection 127.0.0.1 -Port 1235
.\scripts\Test-LocalModel.ps1 -BaseUrl 'http://127.0.0.1:1235'
~~~

A working /v1/models response verifies endpoint reachability, not that the Bionic agent can invoke MCP tools. Avoid listening on all network interfaces unless authentication, TLS and network rules have been deliberately designed.

## 3. Safe PowerShell tool server

The reference configuration included tools with functions similar to:

| Observed tool name | Purpose | Permission class |
| --- | --- | --- |
| powershell_validate | Validate PowerShell source without deploying changes | Validation |
| powershell_readonly | Narrow read-only system diagnostics | Read-only |
| shell_command | Execute a command when the host permits it | Potentially destructive |
| read_file_lines / read_file_chars | Read selected local files | Scoped file read |
| edit_file_tool / replace_file | Edit selected local files | Scoped write |

These tools are **not bundled in the Qwen model**. The exact runtime implementation, actual argument names and version must be inspected in the Bionic host before use.

A prior failure was caused by calling powershell_readonly with a boolean when its **check** field expected a **string**, for example **environment**. Always use the advertised input schema and stop after errors.

Recommended progression: **validate only → read-only diagnostics → narrowly approved shell/file changes**. Do not give a small local model unattended administrator-level shell execution.

## 4. GitHub MCP

Reference use: read repository files, inspect code and optionally create/update files with approval.

Suggested setup:
1. Choose a reputable Bionic-compatible GitHub MCP provider; audit its source and required OAuth/PAT scopes.
2. Use a dedicated test repository and fine-grained, repository-restricted credentials.
3. In Bionic Settings → MCP, add the server through the documented method for your Bionic version.
4. Complete authentication without pasting the secret into a prompt or public config.
5. Ask the model to list *actual connected tools*, then call a harmless read-only operation.
6. Verify the result against GitHub directly.
7. Enable writes only with approval, diff preview, branch and path validation.
8. Test failure handling for expired tokens, missing repository permissions and rate limits.

A reference session used a GitHub-hosted remote MCP endpoint; the precise authentication and supported tools can change. Consult current vendor documentation. Do not copy broad personal-access-token scopes used in exploratory setups as a default.

## 5. WordPress MCP via the official Adapter

WordPress's [MCP Adapter](https://github.com/WordPress/mcp-adapter) exposes selected site abilities to an MCP client. Its usual default endpoint is:

~~~text
https://example.org/wp-json/mcp/mcp-adapter-default-server
~~~

The documented default server exposes three meta-tools for ability discovery, schema inspection and execution; some host/proxy layers present tool names differently. The reference setup discovered site-inspection and plugin-audit abilities. These are examples of **actual tool discovery**, not built-in Bionic capabilities.

Setup:
1. Build a **test** WordPress site and back it up.
2. Review and install the official MCP Adapter release; verify current compatibility and authentication instructions.
3. Create a **dedicated WordPress user** with the minimum capabilities needed for read-only checks.
4. Where Bionic can connect directly with authenticated HTTP MCP, prefer direct transport. Otherwise review [mcp-wordpress-remote](https://github.com/Automattic/mcp-wordpress-remote) and use it as a stdio-to-HTTP proxy if the host needs one.
5. Configure credentials in a local OS secret store or supported secure UI, not in this repository.
6. Verify discovered abilities and permission callbacks.
7. Run one read-only site inspection in the test site. Validate results.
8. Only after approval add write-capable abilities, and consider separate credentials for deployment vs auditing.

**Risks:** WordPress MCP capabilities may create/update/delete posts, users, plugins, WooCommerce records and other production data. The permissions of the WordPress user and the server ability definitions are security boundaries.

## 6. Gemini remote second opinion

A reference environment used a local Node.js MCP bridge that offered **ask_gemini** and called an external Gemini model. The MCP server file lived under a local user-profile folder and the Bionic connection showed **one tool available**. Early requests timed out; a later call returned HTTP 200 from a Gemini model but **search grounding was disabled**.

This is a useful architecture, but there are three separate acceptance checks:

1. **MCP transport:** Bionic can start or reach the Node process and list ask_gemini.
2. **API generation:** The backend obtains HTTP success from the configured model and returns an answer.
3. **Search grounding:** The provider's actual grounding/search feature is enabled and the response includes evidence.

Passing (1) does not prove (2); passing (2) does not prove (3).

Implementation plan:
1. Install supported Node.js and confirm node --version and npm.cmd --version.
2. Create a **separate** local folder for the MCP bridge outside Git.
3. Use official Google GenAI SDK documentation; check model ID, region availability, quota and current grounding API.
4. Load GEMINI_API_KEY from a vault or locally supplied environment variable (never hardcode).
5. Create a narrow ask_gemini MCP tool with a typed schema, timeout, errors and output length limits.
6. Restrict input to public/sanitized information after explicit consent.
7. Test first with a small harmless prompt, then a deliberately invalid token/timeout, then a grounding-enabled query where supported.
8. Log status, latency, model ID and whether grounding metadata was observed, **not** keys or sensitive prompts.

Official grounding docs: https://ai.google.dev/gemini-api/docs/google-search

**Do not assume a cloud model grants automatic internet research.** That requires configured search/grounding or an independent search tool.

## 7. Additional skill resources considered

Earlier setup discussions included PowerShell Expert, Microsoft Security skills, Microsoft Graph development skills, Microsoft 365 tenant management and cybersecurity skill collections. External repositories are enumerated in [09-third-party-skills.md](09-third-party-skills.md). This repository does not claim they were all installed, audited or working.

## 8. Acceptance checklist for every MCP

- Actual server owner/source, revision, license and dependencies inspected.
- Transport and host version compatible.
- Tool list and schemas verified from the host.
- Read-only test and error case observed.
- Account permissions reviewed; secrets stored locally.
- Prompt-injection risks and data export risks assessed.
- Writes disabled or approval-gated.
- No secret, private endpoint or customer identity in public source files or logs.

## 9. Common mistakes

- Assuming a SKILL.md grants new tools.
- Installing all MCP servers concurrently and overwhelming a 9B context.
- Treating a success icon as evidence that a real tool invocation worked.
- Using npm instead of npm.cmd in a Windows PowerShell session with script-policy restrictions; confirm the actual command path and use approved command execution.
- Assuming a Gemini model response includes Google Search grounding.
- Assigning blanket WordPress/GitHub administrator permissions to a local LLM.
- Forgetting that a browser or remote model tool may transmit input outside the local device.
