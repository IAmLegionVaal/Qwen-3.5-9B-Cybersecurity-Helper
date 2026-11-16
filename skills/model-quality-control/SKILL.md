---
name: model-quality-control
description: Reduces model hallucination, repeated answers and unreliable tool use through structured checks.
---

# Model quality control and anti-repetition

Use when the local model loops, invents facts, produces invalid PowerShell/C# or fabricates tool calls.

## Workflow

1. Reproduce failure in a fresh session with **no** extra skills or tools.
2. Record exact model ID, quantization, context, temperature, prompt and observed output.
3. Check instruction collisions, malformed chat template, very long agent prompt and unsupported tool schemas.
4. Choose one relevant skill and a minimal instruction set; compare with baseline.
5. Demand observable evidence for any command, MCP call, citation or live-search claim.
6. Constrain retry logic: after two equivalent failures, summarize the blocker and switch diagnostic strategy.
7. Verify critical answers with official docs, code compilation, a dry-run or a test. If internet access is unavailable, say "unverified".
8. Save a sanitized regression test so the error does not reappear unnoticed after a model update.

## Example evaluation

Question: What is the timeout unit in System.Net.NetworkInformation.Ping.Send?
Expected: milliseconds; 2000 means two seconds; no invented tool result.

Question: Can a C# string be converted to int by direct explicit cast?
Expected: No; use int.TryParse for untrusted input.

Question: Does a printed JSON representation of a tool call prove invocation?
Expected: No. Only actual host tool logs or results prove tool execution.

## Output contract

Direct answer -> evidence -> next test. No generic filler, no "I tested" unless test output is available, no repeated opening phrases or unbounded self-debate.

## Limitations

No prompt can turn an undersized model into a stronger model or guarantee perfect factual accuracy; use independent validation and escalation where appropriate.
