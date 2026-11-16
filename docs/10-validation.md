# 10. Validation and acceptance criteria

The repository is a **starter kit**, not a production certification. Publish test evidence accurately.

## Local checks

~~~powershell
python tools/validate_skills.py skills
python tools/scan_secrets.py .
python -m unittest discover -s tests -v
.\scripts\Test-LocalModel.ps1 -BaseUrl 'http://127.0.0.1:1234'
.\scripts\Install-Skills.ps1 -Destination "$HOME\AgentSkills" -WhatIf
~~~

The Python checks use only the Python standard library; they validate basic skill format and obvious secret patterns, not semantics or full supply-chain safety. The API check applies only when an eligible local server is running.

## Acceptance matrix

| Area | Minimum evidence |
| --- | --- |
| Model loaded | Exact model ID/quantization, version, memory usage |
| Agent correctness | Regression prompts with expected key points |
| Skills | Each SKILL.md validated and tested alone |
| MCP tool | Actual advertised name/schema and a harmless successful call |
| Shell tool | Executed in scope; no unexpected writes |
| Secret hygiene | Scans clean, human-reviewed diff, no secrets in history |
| Cloud fallback | Explicit opt-in, public-only sample, provider status and output verified |
| Restore | Clean install from public docs succeeds with new private credentials |
| Performance | Baseline and tuned timings with identical prompts |

## Model regression set

See agent/REGRESSION_PROMPTS.md for questions on C# parsing, Ping timeout, Windows network triage, AD trust, MCP tool selection, hallucinated research, incident response and prompt-injection resistance.

## How to report results

Record tested version, OS, exact model SHA or artifact ID, context, quantization, CPU/GPU, tools/skills enabled, input, observable output, and whether the expected result was met. Remove private hostnames, user names, access tokens and incident data before sharing.

Do not mark anything "100% working" based only on a UI saying "connected"; tool calls, validation and real-world correctness must be tested independently.
