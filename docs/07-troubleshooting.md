# 07. Troubleshooting matrix

Use a new chat for each isolated test. Capture exact error, runtime version, model identifier and a *redacted* trace.

| Symptom | Likely categories | First checks |
| --- | --- | --- |
| Qwen loops/repeats | Prompt collision, context loss, decoding, small model/tool overload | Remove skills/tools; reduce prompt; repeat fixed regression prompt |
| Wrong PowerShell code | Incorrect assumptions, version mismatch, fabricated cmdlet | $PSVersionTable; Get-Command; Microsoft docs; dry-run; Pester |
| MCP "connected" but tools unavailable | Schema failure, server handshake, scope or visibility | Inspect MCP server logs and **actual advertised tool list** |
| MCP process times out | DNS/firewall, auth, wrong endpoint, Node error, rate limit | Node --check; restricted test call; provider status; bounded timeout |
| API /v1/models fails | Wrong port, server stopped, firewall, TLS/auth | Test-NetConnection 127.0.0.1 -Port 1234; scripts/Test-LocalModel.ps1 |
| Successful API but poor answers | Wrong model, sampling settings, context, template | Confirm returned model ID, reset prompt, run regression suite |
| GPU out of memory | Quantization/context too large, concurrent sessions | Lower context and concurrency, choose smaller quantization |
| Slow output | CPU offload, paging, thermal throttling, long context | Monitor Task Manager/VRAM and compare tokens/sec |
| Tool prints fake JSON rather than invoking tool | Model/harness tool calling mismatch, no actual tool registered | Verify tools exposed by host; use simple direct tool test |
| HTTP 401/403 | Missing/expired token or provider permission | Validate credential locally, do not paste token into chat |
| HTTP 429 | Quota/throughput | Backoff with cap; inspect provider quotas |
| GitHub push rejected | Protected branch or missing scopes | Read repo permissions, branch rules, token permissions |
| Bionic UI stuck | App state/rendering, incompatible runtime | Reopen app, inspect update/release notes, isolate model/extension |

## Diagnostic commands (Windows)

~~~powershell
$PSVersionTable.PSVersion
Get-Command node,python,git -ErrorAction SilentlyContinue | Select-Object Name,Source
Get-NetTCPConnection -LocalPort 1234 -State Listen -ErrorAction SilentlyContinue
Get-Process | Where-Object ProcessName -Match 'LM Studio|Bionic' | Select-Object ProcessName,CPU,WorkingSet
.\scripts\Test-LocalModel.ps1 -BaseUrl 'http://127.0.0.1:1234'
~~~

Connection refused is different from an application returning 401 or 500. Avoid changing firewalls or executing global policy changes until root cause is understood.

## Windows PowerShell execution policy

An execution-policy error is not permission to disable security globally. Use signed scripts, documented process-scoped settings if permitted, and an organization-approved change procedure. A script's credibility is more important than getting it to launch.

## Stop conditions

If diagnostic collection would expose live credentials, change production permissions, alter protected system state or collect sensitive user data, stop and request authorization and a safe storage location.
