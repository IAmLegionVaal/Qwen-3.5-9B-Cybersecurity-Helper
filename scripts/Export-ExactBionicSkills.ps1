#requires -Version 5.1
<#
.SYNOPSIS
Stage the EXACT local Bionic skill files for PRIVATE review only.
.DESCRIPTION
Copies file bytes and relative paths from a specific skills root into a new
private review folder. Writes SHA256 hashes and a limited content-risk report
without printing matched credential values.

DOES NOT: publish, push to Git, upload, create a public ZIP, execute skills,
install dependencies, change the source files, or prove the output is safe.
Only run on a machine and skill directory you are authorized to inspect.

Because original files may contain secrets or third-party code, do not upload
the output until every file is reviewed for privacy, licensing and safety.
.EXAMPLE
.\Export-ExactBionicSkills.ps1 -SourceRoot "$HOME\.lmstudio\skills" -OutputDirectory "$HOME\Documents\BionicSkills-PrivateReview" -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$SourceRoot = (Join-Path $HOME '.lmstudio\skills'),

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputDirectory,

    [Parameter()]
    [ValidateRange(1, 100)]
    [int]$MaximumFileMB = 10,

    [Parameter()]
    [ValidateRange(1, 2048)]
    [int]$MaximumTotalMB = 100,

    [Parameter()]
    [string[]]$PrivateTerms = @()
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-InsideGitWorktree {
    param([Parameter(Mandatory)][string]$Path)
    $folder = [IO.DirectoryInfo]::new($Path)
    while ($null -ne $folder) {
        if (Test-Path -LiteralPath (Join-Path $folder.FullName '.git')) {
            return $true
        }
        $folder = $folder.Parent
    }
    return $false
}

function Get-Flags {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string[]]$Terms
    )

    $alerts = New-Object 'System.Collections.Generic.List[string]'
    if ($Path -match '(?i)(^|[\\/])(\.env|secrets?|credentials?|auth\.json|mcp\.json)([\\/]|$)') {
        $alerts.Add('Risky filename')
    }

    $ext = [IO.Path]::GetExtension($Path).ToLowerInvariant()
    if ($ext -notin @('.md','.txt','.ps1','.psm1','.psd1','.js','.mjs','.ts','.json','.yaml','.yml','.toml','.py','.xml','.sh','.cmd','.bat')) {
        $alerts.Add('Non-text or unrecognized extension; manual inspection required')
        return $alerts.ToArray()
    }

    try {
        $content = [IO.File]::ReadAllText($Path)
    }
    catch {
        $alerts.Add('Unreadable text file; manual inspection required')
        return $alerts.ToArray()
    }

    $patterns = [ordered]@{
        'Potential key or credential' = '(?i)\b(?:api[_-]?key|access[_-]?token|client[_-]?secret|password)\b.{0,24}[:=]\s*["'']?[A-Za-z0-9+/_-]{12,}'
        'Possible private key' = '-----BEGIN (?:RSA |EC |OPENSSH |ENCRYPTED )?PRIVATE KEY-----'
        'Possible GitHub token' = '(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,})'
        'Possible Google API key' = 'AIza[0-9A-Za-z_-]{35}'
        'Email address (review for personal data)' = '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b'
    }
    foreach ($label in $patterns.Keys) {
        if ([regex]::IsMatch($content, $patterns[$label], [Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
            $alerts.Add($label)
        }
    }
    foreach ($term in $Terms) {
        if (-not [string]::IsNullOrWhiteSpace($term) -and
            ($content.IndexOf($term, [StringComparison]::OrdinalIgnoreCase) -ge 0 -or
             $Path.IndexOf($term, [StringComparison]::OrdinalIgnoreCase) -ge 0)) {
            $alerts.Add('Private term match (value withheld)')
        }
    }
    return $alerts.ToArray()
}

try {
    $source = (Resolve-Path -LiteralPath $SourceRoot -ErrorAction Stop).ProviderPath.TrimEnd('\','/')
    if (-not (Test-Path -LiteralPath $source -PathType Container)) {
        throw 'Skills source does not exist or is not a directory.'
    }
    $destination = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputDirectory).TrimEnd('\','/')
    if ([string]::IsNullOrWhiteSpace($destination)) {
        throw 'Invalid output path.'
    }
    if ($destination.Equals($source, [StringComparison]::OrdinalIgnoreCase) -or
        $destination.StartsWith($source + '\', [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Output must be outside the source skill directory.'
    }
    if (Test-InsideGitWorktree -Path $destination) {
        throw 'Output is in a Git worktree. Choose a private non-Git folder.'
    }
    if (Test-Path -LiteralPath $destination) {
        $existing = @(Get-ChildItem -LiteralPath $destination -Force -ErrorAction Stop)
        if ($existing.Count -gt 0) {
            throw 'Output directory is not empty; refusing to overwrite or mix exports.'
        }
    }

    $items = @(Get-ChildItem -LiteralPath $source -Recurse -Force -ErrorAction Stop)
    if ($items.Count -eq 0) {
        throw 'No files or skill folders were found.'
    }
    foreach ($item in $items) {
        if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw 'Source contains a symbolic link or junction. Refusing to follow it.'
        }
    }
    $files = @($items | Where-Object { -not $_.PSIsContainer })
    if ($files.Count -eq 0) {
        throw 'No files found in the skill tree.'
    }

    $maxFile = [long]$MaximumFileMB * 1MB
    $maxTotal = [long]$MaximumTotalMB * 1MB
    $total = [long]0
    foreach ($file in $files) {
        if ($file.Length -gt $maxFile) {
            throw 'One or more skill files exceed the per-file size limit; review manually.'
        }
        $total += [long]$file.Length
        if ($total -gt $maxTotal) {
            throw 'Skill tree exceeds total size limit; review manually.'
        }
    }

    $manifest = @()
    $riskCount = 0
    foreach ($file in $files) {
        $relative = $file.FullName.Substring($source.Length).TrimStart('\','/')
        $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        $flags = @(Get-Flags -Path $file.FullName -Terms $PrivateTerms)
        if ($flags.Count -gt 0) { $riskCount++ }
        $manifest += [pscustomobject]@{
            relative_path = $relative.Replace('\','/')
            bytes = [long]$file.Length
            sha256 = $hash
            review_flags = $flags
        }
    }

    if ($PSCmdlet.ShouldProcess($destination, ('Copy ' + $files.Count + ' exact skill files for PRIVATE review'))) {
        New-Item -Path $destination -ItemType Directory -Force -ErrorAction Stop | Out-Null
        $copyRoot = Join-Path $destination 'skills'
        New-Item -Path $copyRoot -ItemType Directory -Force -ErrorAction Stop | Out-Null

        foreach ($file in $files) {
            $relative = $file.FullName.Substring($source.Length).TrimStart('\','/')
            $target = Join-Path $copyRoot $relative
            $targetParent = Split-Path -Parent $target
            if (-not (Test-Path -LiteralPath $targetParent -PathType Container)) {
                New-Item -Path $targetParent -ItemType Directory -Force -ErrorAction Stop | Out-Null
            }
            Copy-Item -LiteralPath $file.FullName -Destination $target -ErrorAction Stop
            $targetHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant()
            $originalHash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
            if ($targetHash -ne $originalHash) {
                throw 'File content changed during copying; output is incomplete, DO NOT PUBLISH.'
            }
        }

        $report = [ordered]@{
            format_version = 1
            status = 'PRIVATE_REVIEW_ONLY_NOT_PUBLICATION_READY'
            generated_utc = [DateTime]::UtcNow.ToString('o')
            files_count = $files.Count
            flagged_file_count = $riskCount
            caveat = 'Flags are not a comprehensive secret, malware or license scan. Review every file.'
            files = $manifest
        }
        $reportPath = Join-Path $destination 'review-manifest.json'
        [IO.File]::WriteAllText($reportPath, (ConvertTo-Json -InputObject $report -Depth 8))
        Write-Output ("PRIVATE export complete. Files: {0}; flagged for review: {1}." -f $files.Count, $riskCount)
        Write-Warning 'DO NOT PUBLISH this directory. Manually audit all files for secrets, private references, malware and licenses.'
    }
}
catch {
    Write-Error ('Export failed: ' + $_.Exception.Message)
    Write-Warning 'If an output directory was partially written, keep it private and review before deleting.'
    exit 1
}
