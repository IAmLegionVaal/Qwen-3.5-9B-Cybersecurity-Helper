# 05. Optional cloud fallback / second opinion

**Goal:** Escalate a hard task to a more capable remote model only when approved and appropriate. This is an **architecture design**, not an included or already connected live service.

## Decision flow

1. Try locally with bounded retries and one relevant skill.
2. Detect failure: schema-invalid tool call, lack of verified source, repeated answer, or explicit low-confidence result.
3. Identify confidentiality: PUBLIC, INTERNAL, CONFIDENTIAL, SECRET.
4. If anything other than PUBLIC, keep processing locally by default. Require an explicit human-approved redaction and data-transfer decision before sending externally.
5. For eligible, approved PUBLIC tasks, optionally call a configured provider. Include a timeout, limited retry policy, rate limiting and structured error reporting.
6. Compare cloud output against authoritative documentation or direct tests. The remote model is not guaranteed accurate.
7. Never send credentials, tokens, private source code, customer records or raw incident artifacts automatically.

## Reference workflow

~~~text
User task
  -> classify data / authorization
  -> local model + focused skill
  -> verify answer and tool outcome
  -> failure? -> ask for explicit cloud escalation approval
     -> sanitize public-only prompt
     -> remote model (if configured and reachable)
     -> verify / cite / disclose remote processing
  -> final answer
~~~

## Internet research is a separate capability

A model API request does not grant search access. Gemini or any other cloud model can only provide live web-grounded answers when its specific API/tools and request parameters enable grounding/retrieval and the response reports evidence. If search is not configured, state "not verified against live sources".

## Operational concerns

- Use distinct timeouts for network connect and request processing where supported.
- Bound retry count and use exponential backoff for transient errors; never retry invalid credentials indefinitely.
- Log status codes, durations and tool names, **not** prompts containing sensitive data or Authorization headers.
- Enforce explicit provider model IDs, approved outbound endpoints, TLS validation and outbound firewall rules.
- Never hardcode a real key in mcp.json or a prompt. Store it outside Git; rotate if exposed.

## What this repository does not include

No real provider key, paid quota, hosted account, working search grounding integration or silent automatic model router. Validate these separately in your environment before claiming cloud fallback works.
