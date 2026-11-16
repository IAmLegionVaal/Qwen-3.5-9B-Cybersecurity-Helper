#requires -Version 5.1
<#
.SYNOPSIS
Copies reviewed skills to a user-selected staging directory.
.DESCRIPTION
This is NOT Bionic's internal skills store. Import the staged files via Bionic Settings > Skills.
Will not overwrite existing skill folders. Use -WhatIf to preview actions.
.EXAMPLE
.\Install-Skills.ps1 -Destination "$HOME\AgentSkills" -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$SourceRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) 'skills'),

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Destination
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    $source = (Resolve-Path -LiteralPath $SourceRoot -ErrorAction Stop).ProviderPath
    $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)
    if (Test-Path -LiteralPath $destinationPath -PathType Leaf) {
        throw 'Destination is an existing file.'
    }

    $skillDirectories = @(Get-ChildItem -LiteralPath $source -Directory -ErrorAction Stop)
    if ($skillDirectories.Count -eq 0) {
        throw 'No skill directories found in source folder.'
    }

    foreach ($skill in $skillDirectories) {
        $manifest = Join-Path $skill.FullName 'SKILL.md'
        if (-not (Test-Path -LiteralPath $manifest -PathType Leaf)) {
            throw ('Missing SKILL.md for: ' + $skill.Name)
        }
    }

    if (-not (Test-Path -LiteralPath $destinationPath -PathType Container)) {
        if ($PSCmdlet.ShouldProcess($destinationPath, 'Create staging directory')) {
            New-Item -ItemType Directory -Path $destinationPath -Force -ErrorAction Stop | Out-Null
        }
    }

    foreach ($skill in $skillDirectories) {
        $target = Join-Path $destinationPath $skill.Name
        if (Test-Path -LiteralPath $target) {
            Write-Warning ('Skipped existing folder: ' + $skill.Name)
            continue
        }
        if ($PSCmdlet.ShouldProcess($target, 'Copy reviewed skill directory')) {
            Copy-Item -LiteralPath $skill.FullName -Destination $target -Recurse -ErrorAction Stop
            Write-Output ('Staged: ' + $skill.Name)
        }
    }
}
catch {
    Write-Error ('Skill staging failed: ' + $_.Exception.Message)
    exit 1
}
