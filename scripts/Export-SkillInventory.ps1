#requires -Version 5.1
<#
.SYNOPSIS
Exports names, sizes and SHA256 hashes of installed/staged SKILL.md files.
.DESCRIPTION
Does not copy skill contents, user paths, secrets or app caches.
Review even this limited inventory before external sharing.
.EXAMPLE
.\Export-SkillInventory.ps1 -SkillsRoot "$HOME\AgentSkills" -OutputPath "$HOME\Desktop\skill-inventory.json"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$SkillsRoot,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    $root = (Resolve-Path -LiteralPath $SkillsRoot -ErrorAction Stop).ProviderPath
    $output = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
    $parent = Split-Path -Parent $output
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        throw 'Output parent folder does not exist.'
    }

    $inventory = @(
        Get-ChildItem -LiteralPath $root -Directory -ErrorAction Stop |
        Sort-Object Name |
        ForEach-Object {
            $manifest = Join-Path $_.FullName 'SKILL.md'
            if (Test-Path -LiteralPath $manifest -PathType Leaf) {
                $item = Get-Item -LiteralPath $manifest -ErrorAction Stop
                $digest = Get-FileHash -LiteralPath $manifest -Algorithm SHA256 -ErrorAction Stop
                [pscustomobject]@{
                    name = $_.Name
                    manifest_bytes = $item.Length
                    sha256 = $digest.Hash.ToLowerInvariant()
                }
            }
        }
    )

    $payload = [ordered]@{
        format_version = 1
        generated_utc = [DateTime]::UtcNow.ToString('o')
        warning = 'Review skill names before sharing; no private paths or content included.'
        skills = $inventory
    }

    $json = ConvertTo-Json -InputObject $payload -Depth 5
    Set-Content -LiteralPath $output -Value $json -Encoding UTF8 -ErrorAction Stop
    Write-Output ('Inventory created for ' + $inventory.Count + ' skills. Review before sharing.')
}
catch {
    Write-Error ('Inventory export failed: ' + $_.Exception.Message)
    exit 1
}
