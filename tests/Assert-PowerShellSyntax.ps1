#requires -Version 7.0
<#
.SYNOPSIS
Parse repository PowerShell scripts without executing any of their contents.
#>
[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    $root = Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts'
    $scripts = @(Get-ChildItem -LiteralPath $root -Filter '*.ps1' -File -ErrorAction Stop)
    if ($scripts.Count -lt 1) {
        throw 'No scripts found.'
    }
    $failures = New-Object 'System.Collections.Generic.List[string]'
    foreach ($script in $scripts) {
        $tokens = $null
        $parseErrors = $null
        [System.Management.Automation.Language.Parser]::ParseFile(
            $script.FullName,
            [ref]$tokens,
            [ref]$parseErrors
        ) | Out-Null

        if ($null -ne $parseErrors) {
          foreach ($parseError in @($parseErrors)) {
            $failures.Add(('{0}:{1} {2}' -f $script.Name, $parseError.Extent.StartLineNumber, $parseError.Message))
          }
        }
    }
    if ($failures.Count -gt 0) {
        foreach ($item in $failures) { Write-Error $item }
        exit 1
    }
    Write-Output ("PASS: Parsed {0} PowerShell scripts without executing them." -f $scripts.Count)
}
catch {
    Write-Error ('PowerShell syntax validation failed: ' + $_.Exception.Message)
    exit 1
}
