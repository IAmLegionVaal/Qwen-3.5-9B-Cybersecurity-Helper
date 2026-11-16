---
name: powershell-engineering
description: Designs, debugs, reviews and tests secure PowerShell automation for Windows administration.
---

# PowerShell engineering

Use this skill for PowerShell 5.1 and PowerShell 7 scripts, Win32/CIM management, diagnostic automation, modules, error handling and production-safe tooling.

## Workflow

1. Confirm target PowerShell edition/version, privileges, remoting context and intended scope.
2. Find the supported cmdlet or .NET API; distinguish PowerShell casting from C# syntax. Prefer Get-Command and official Microsoft documentation for ambiguous behavior.
3. Identify input types, null behavior, encoding, path quoting, network timeouts and version differences.
4. Write advanced functions or scripts with CmdletBinding, parameter validation, explicit ErrorAction where required, and structured try/catch/finally.
5. Prefer idempotent and read-only discovery. For changes, support ShouldProcess/-WhatIf and a documented rollback when feasible.
6. Never hardcode passwords, API tokens, account IDs or production servers. Use environment variables or an approved secrets manager.
7. Validate output types and all exceptional paths. Do not silently swallow errors.
8. Where appropriate, provide Pester tests and a static-analysis suggestion. Do not claim tests ran unless execution occurred.

## Diagnostic examples

~~~powershell
$PSVersionTable
Get-Command Test-NetConnection -ErrorAction SilentlyContinue
Get-CimInstance Win32_OperatingSystem -ErrorAction Stop | Select-Object Caption,Version,BuildNumber
~~~

## Correctness requirements

- NetworkInformation.Ping.Send(address, timeout) timeout is in **milliseconds**.
- To parse a string port, use TryParse and validate 1..65535; C# explicit cast from string to int is not valid.
- Treat Windows PowerShell 5.1 and PowerShell 7 feature availability differently.
- Capture command output and exit codes rather than assuming success.
- Consider 32-bit vs 64-bit PowerShell and WOW64 when working with registry and ODBC.

## Safety gate

Before executing a write, confirm authorization, target scope, reversibility and expected change. Never disable EDR, AMSI or logging to make a troubleshooting script work.

## Final answer

Give short root-cause context, minimal correct code, expected output, error handling and verification/rollback where needed.
