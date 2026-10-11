$ErrorActionPreference = 'Stop'
$tool = Join-Path $PSScriptRoot '..\scripts\dotnet-toolchain.ps1'
$failures = @()
function Assert-True([bool]$Condition, [string]$Message) {
    if ($Condition) { Write-Output "PASS: $Message" }
    else { $script:failures += $Message; Write-Output "FAIL: $Message" }
}
function Invoke-Tool([string[]]$Arguments) {
    $text = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $tool @Arguments 2>&1 | Out-String
    [pscustomobject]@{ Code = $LASTEXITCODE; Text = $text }
}
function New-Runtime([string]$Root, [string]$Version, [string]$MarkerFile) {
    $dir = Join-Path $Root "shared\Microsoft.NETCore.App\$Version"
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $dir $MarkerFile) -Value 'x'
}

$root = Join-Path ([IO.Path]::GetTempPath()) ('dotnet-toolchain-test-' + [guid]::NewGuid().ToString('N'))
try {
    New-Runtime $root '99.0.0' 'System.Private.CoreLib.dll'
    $r = Invoke-Tool @('-Action', 'Check', '-DotnetRoot', $root)
    Assert-True ($r.Code -eq 0 -and $r.Text -match '"status":\s*"PASS"') 'an intact runtime passes'

    $r = Invoke-Tool @('-Action', 'Check', '-DotnetRoot', $root, '-Version', '97.0')
    Assert-True ($r.Code -eq 1 -and $r.Text -match 'No intact runtime matches required version 97\.0') 'a missing required version fails'

    New-Runtime $root '98.0.0' 'hostpolicy.dll'
    $r = Invoke-Tool @('-Action', 'Check', '-DotnetRoot', $root)
    Assert-True ($r.Code -eq 1 -and $r.Text -match '"status":\s*"FAIL"' -and $r.Text -match '98\.0\.0 is registered but missing System\.Private\.CoreLib\.dll') 'a runtime missing CoreLib fails'

    $installer = Join-Path $env:TEMP 'dotnet-install.ps1'
    $before = if (Test-Path -LiteralPath $installer) { (Get-Item -LiteralPath $installer).LastWriteTimeUtc.Ticks } else { 0 }
    $r = Invoke-Tool @('-Action', 'Install', '-Kind', 'Runtime', '-Version', '10.0.12')
    $after = if (Test-Path -LiteralPath $installer) { (Get-Item -LiteralPath $installer).LastWriteTimeUtc.Ticks } else { 0 }
    Assert-True ($r.Code -eq 0 -and $r.Text -match 'DRY-RUN .*dotnet-install\.ps1.*-Version 10\.0\.12.*-Runtime dotnet' -and $r.Text -notmatch 'APPLY' -and $before -eq $after) 'install is a dry run by default and writes nothing'

    $r = Invoke-Tool @('-Action', 'Install', '-Kind', 'Sdk', '-Method', 'Winget', '-Version', '10.0.401')
    Assert-True ($r.Code -eq 0 -and $r.Text -match 'DRY-RUN winget install --id Microsoft\.DotNet\.SDK\.10 --exact --version 10\.0\.401') 'winget dry run names the exact package and version'

    $r = Invoke-Tool @('-Action', 'Install', '-Version', '10.0.12; calc')
    Assert-True ($r.Code -eq 2 -and $r.Text -match 'Invalid -Version') 'an injected version is refused'

    $r = Invoke-Tool @('-Action', 'Install')
    Assert-True ($r.Code -eq 2 -and $r.Text -match 'Install requires -Version') 'install without a version is refused'
}
finally {
    Remove-Item -LiteralPath $root -Recurse -Force -ErrorAction SilentlyContinue
}
if ($failures.Count) { Write-Output "FAILURES=$($failures.Count)"; exit 1 }
Write-Output 'TESTS-OK'
exit 0
