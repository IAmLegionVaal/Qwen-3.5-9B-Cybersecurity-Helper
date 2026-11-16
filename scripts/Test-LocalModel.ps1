#requires -Version 5.1
<#
.SYNOPSIS
Checks a local OpenAI-compatible models endpoint without submitting a prompt.
.DESCRIPTION
Defaults to loopback only. A server does not need to use this exact port.
An optional bearer token may be supplied via the named environment variable.
.EXAMPLE
.\Test-LocalModel.ps1 -BaseUrl 'http://127.0.0.1:1234'
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$BaseUrl = 'http://127.0.0.1:1234',

    [Parameter()]
    [ValidateRange(1, 120)]
    [int]$TimeoutSec = 10,

    [Parameter()]
    [string]$TokenEnvVarName = 'LM_API_TOKEN',

    [Parameter()]
    [switch]$AllowNonLoopback
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    $baseUri = [Uri]$BaseUrl
    if ($baseUri.Scheme -notin @('http', 'https')) {
        throw 'Only HTTP(S) endpoints are supported.'
    }
    if (-not $AllowNonLoopback -and $baseUri.Host -notin @('localhost', '127.0.0.1', '::1')) {
        throw 'Non-loopback address blocked. Specify -AllowNonLoopback only after verifying TLS, authentication and authorization.'
    }

    $root = $BaseUrl.TrimEnd('/')
    if ($root -match '/v1$') {
        $modelsUrl = $root + '/models'
    }
    else {
        $modelsUrl = $root + '/v1/models'
    }

    $headers = @{}
    if (-not [string]::IsNullOrWhiteSpace($TokenEnvVarName)) {
        $token = [Environment]::GetEnvironmentVariable($TokenEnvVarName)
        if (-not [string]::IsNullOrWhiteSpace($token)) {
            $headers['Authorization'] = 'Bearer ' + $token
        }
    }

    $response = Invoke-RestMethod -Uri $modelsUrl -Method Get -Headers $headers -TimeoutSec $TimeoutSec -ErrorAction Stop
    if ($null -eq $response -or $null -eq $response.data) {
        throw 'Endpoint responded but did not contain the expected data array.'
    }
    $ids = @($response.data | ForEach-Object { $_.id } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    [pscustomobject]@{
        Endpoint = $modelsUrl
        Reachable = $true
        ModelCount = $ids.Count
        ModelIds = $ids
    }
}
catch {
    Write-Error ('Local model health check failed: ' + $_.Exception.Message)
    exit 1
}
finally {
    # Drop the in-process header reference; never print tokens.
    if (Get-Variable -Name headers -ErrorAction SilentlyContinue) {
        $headers.Clear()
    }
}
