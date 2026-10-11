[CmdletBinding()]
param([string]$RelativeScript='', [switch]$Apply)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$skillRoot=Split-Path -Parent $PSScriptRoot
$meta=Get-Content -LiteralPath (Join-Path $skillRoot 'assets/source.json') -Raw | ConvertFrom-Json
$project=$skillRoot
while($project -and -not (Test-Path -LiteralPath (Join-Path $project '.pmcro'))){$parent=Split-Path -Parent $project;if($parent -eq $project){break};$project=$parent}
if(-not(Test-Path -LiteralPath (Join-Path $project '.pmcro'))){throw 'project root not found'}
$source=Join-Path $project ('.pmcro/upstream/dotnet-skills/' + [string]$meta.source)
if(-not(Test-Path -LiteralPath $source)){throw 'pinned upstream source missing'}
if(-not $RelativeScript){Write-Output ('SOURCE ' + $source); exit 0}
if([IO.Path]::IsPathRooted($RelativeScript) -or $RelativeScript -match '(^|[\\/])\.\.([\\/]|$)'){throw 'RelativeScript must stay inside the upstream source'}
$target=[IO.Path]::GetFullPath((Join-Path $source $RelativeScript));$prefix=[IO.Path]::GetFullPath($source)
if(-not $prefix.EndsWith([IO.Path]::DirectorySeparatorChar)){$prefix += [IO.Path]::DirectorySeparatorChar}
if(-not $target.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase)){throw 'script escapes upstream source'}
if(-not(Test-Path -LiteralPath $target -PathType Leaf)){throw 'upstream script not found'}
if(-not $Apply){Write-Output ('DRY-RUN ' + $target); exit 0}
$ext=[IO.Path]::GetExtension($target).ToLowerInvariant()
if($ext -eq '.ps1'){& pwsh -NoProfile -File $target}
elseif($ext -eq '.py'){& python $target}
elseif($ext -eq '.sh'){& bash $target}
elseif($ext -in @('.cmd','.bat')){& cmd /c $target}
else{throw 'unsupported integration script type'}
exit $LASTEXITCODE
