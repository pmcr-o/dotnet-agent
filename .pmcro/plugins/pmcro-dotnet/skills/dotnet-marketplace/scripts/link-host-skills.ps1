param([Parameter(Mandatory)][string]$Workspace)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $Workspace).Path.TrimEnd([char[]]'\/')
if (-not (Test-Path -LiteralPath (Join-Path $root '.pmcro/mirror.json') -PathType Leaf)) { throw 'Select a generated dotnet-agent marketplace.' }
$canonical = Join-Path $root '.pmcro/skills'
$shared = Join-Path $root '.agents/skills'
$links = @(
    @{Path=$shared;Target=$canonical},
    @{Path=(Join-Path $root '.claude/skills');Target=$shared},
    @{Path=(Join-Path $root '.grok/skills');Target=$shared}
)
foreach ($link in $links) {
    $full = [IO.Path]::GetFullPath($link.Path)
    $target = [IO.Path]::GetFullPath($link.Target)
    if (-not $full.StartsWith($root + '\',[StringComparison]::OrdinalIgnoreCase) -or -not $target.StartsWith($root + '\',[StringComparison]::OrdinalIgnoreCase)) { throw 'Link leaves workspace.' }
    if (Test-Path -LiteralPath $full) {
        $item = Get-Item -LiteralPath $full -Force
        if ($item.LinkType -ne 'Junction' -or [IO.Path]::GetFullPath($item.Target) -ne $target) { throw "Existing path differs: $full" }
    }
}
foreach ($link in $links) {
    if (-not (Test-Path -LiteralPath $link.Path)) {
        [void](New-Item -ItemType Directory -Path (Split-Path -Parent $link.Path) -Force)
        [void](New-Item -ItemType Junction -Path $link.Path -Target $link.Target)
    }
}
$expected = @(Get-ChildItem -LiteralPath $canonical -Directory).Count
$results = foreach ($link in $links) {
    $observed = @(Get-ChildItem -LiteralPath $link.Path -Directory).Count
    if ($observed -ne $expected) { throw 'Skill discovery counts differ.' }
    [pscustomobject]@{Path=$link.Path;Target=$link.Target;Skills=$observed;Status='PASS'}
}
$results | ConvertTo-Json
