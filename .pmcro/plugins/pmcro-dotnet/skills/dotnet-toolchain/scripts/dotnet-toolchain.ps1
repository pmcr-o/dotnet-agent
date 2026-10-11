<#
.SYNOPSIS
Check or install .NET runtimes and SDKs. Read-only unless Install is run with -Apply.
.DESCRIPTION
Check   Verifies that every registered runtime still contains its marker file.
        Exit 0 = PASS, 1 = FAIL. Output is one JSON object.
Install Prints the exact install commands as DRY-RUN lines and changes nothing.
        With -Apply it runs those commands. Exit 0 = done or planned, 1 = a step failed.
Exit 2 means invalid arguments. An agent and a person run the same script with the same arguments.
#>
[CmdletBinding()]
param(
    [ValidateSet('Check', 'Install')][string]$Action = 'Check',
    [ValidateSet('Runtime', 'Sdk')][string]$Kind = 'Runtime',
    [string]$Version,
    [ValidateSet('Script', 'Winget')][string]$Method = 'Script',
    [string]$DotnetRoot,
    [switch]$Apply
)
$ErrorActionPreference = 'Stop'

function Stop-With($Object, [int]$Code) {
    $Object | ConvertTo-Json -Depth 6
    exit $Code
}

if ($Version) {
    $pattern = if ($Action -eq 'Install') { '^\d+\.\d+\.\d+(-[0-9A-Za-z.]+)?$' } else { '^\d+\.\d+(\.\d+)?(-[0-9A-Za-z.]+)?$' }
    if ($Version -notmatch $pattern) { Stop-With ([ordered]@{ status = 'ERROR'; reason = "Invalid -Version '$Version'" }) 2 }
}
if ($Action -eq 'Install' -and -not $Version) {
    Stop-With ([ordered]@{ status = 'ERROR'; reason = 'Install requires -Version' }) 2
}

if ($Action -eq 'Check') {
    $markers = Get-Content -LiteralPath (Join-Path $PSScriptRoot '..\assets\runtime-markers.json') -Raw | ConvertFrom-Json
    $found = @()
    if ($DotnetRoot) {
        $shared = Join-Path $DotnetRoot 'shared'
        if (-not (Test-Path -LiteralPath $shared)) {
            Stop-With ([ordered]@{ status = 'FAIL'; failures = @("No shared directory under the supplied -DotnetRoot") }) 1
        }
        foreach ($framework in Get-ChildItem -LiteralPath $shared -Directory) {
            foreach ($dir in Get-ChildItem -LiteralPath $framework.FullName -Directory) {
                $found += [pscustomobject]@{ Name = $framework.Name; Version = $dir.Name; Path = $dir.FullName }
            }
        }
    }
    else {
        if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
            Stop-With ([ordered]@{ status = 'FAIL'; failures = @('dotnet is not on PATH') }) 1
        }
        $lines = & dotnet --list-runtimes
        if ($LASTEXITCODE -ne 0) { Stop-With ([ordered]@{ status = 'FAIL'; failures = @('dotnet --list-runtimes failed') }) 1 }
        foreach ($line in $lines) {
            if ($line -match '^(\S+)\s+(\S+)\s+\[(.+)\]$') {
                $found += [pscustomobject]@{ Name = $Matches[1]; Version = $Matches[2]; Path = (Join-Path $Matches[3] $Matches[2]) }
            }
        }
    }

    $checked = @()
    $failures = @()
    foreach ($item in $found) {
        $property = $markers.runtimes.PSObject.Properties[$item.Name]
        if (-not $property) { continue }
        $intact = Test-Path -LiteralPath (Join-Path $item.Path $property.Value)
        $checked += [ordered]@{ runtime = $item.Name; version = $item.Version; marker = $property.Value; intact = $intact }
        if (-not $intact) { $failures += "$($item.Name) $($item.Version) is registered but missing $($property.Value)" }
    }
    if ($checked.Count -eq 0) { $failures += 'No known runtimes were found' }
    if ($Version) {
        $match = @($checked | Where-Object { $_.intact -and $_.version -like "$Version*" })
        if ($match.Count -eq 0) { $failures += "No intact runtime matches required version $Version" }
    }
    $code = if ($failures.Count) { 1 } else { 0 }
    Stop-With ([ordered]@{ status = $(if ($code) { 'FAIL' } else { 'PASS' }); checked = $checked; failures = $failures }) $code
}

$major = $Version.Split('.')[0]
$installDir = Join-Path $env:LOCALAPPDATA 'Microsoft\dotnet'
$installer = Join-Path $env:TEMP 'dotnet-install.ps1'
$steps = @()
if ($Method -eq 'Script') {
    $steps += [pscustomobject]@{
        Text = "Invoke-WebRequest -UseBasicParsing -Uri https://dot.net/v1/dotnet-install.ps1 -OutFile `"$installer`""
        Run  = { Invoke-WebRequest -UseBasicParsing -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile $installer }
    }
    $steps += [pscustomobject]@{
        Text = "& `"$installer`" -Version $Version -InstallDir `"$installDir`"" + $(if ($Kind -eq 'Runtime') { ' -Runtime dotnet' } else { '' })
        Run  = { if ($Kind -eq 'Runtime') { & $installer -Version $Version -InstallDir $installDir -Runtime dotnet } else { & $installer -Version $Version -InstallDir $installDir } }
    }
}
else {
    $package = if ($Kind -eq 'Sdk') { "Microsoft.DotNet.SDK.$major" } else { "Microsoft.DotNet.Runtime.$major" }
    $steps += [pscustomobject]@{
        Text = "winget install --id $package --exact --version $Version --accept-package-agreements --accept-source-agreements"
        Run  = { & winget install --id $package --exact --version $Version --accept-package-agreements --accept-source-agreements }
    }
}

if (-not $Apply) {
    foreach ($step in $steps) { Write-Output "DRY-RUN $($step.Text)" }
    exit 0
}
foreach ($step in $steps) {
    Write-Output "APPLY $($step.Text)"
    $global:LASTEXITCODE = 0
    & $step.Run
    if ($LASTEXITCODE -ne 0) { Write-Output "FAILED step with exit $LASTEXITCODE"; exit 1 }
}
Write-Output 'APPLIED. Run -Action Check to verify the result.'
exit 0
