param()
$ErrorActionPreference='Stop'
$skillRoot=Split-Path -Parent $PSScriptRoot
$meta=Get-Content -LiteralPath (Join-Path $skillRoot 'assets/source.json') -Raw | ConvertFrom-Json
if(-not $meta.source -or -not $meta.revision){throw 'source metadata incomplete'}
'PASS'
exit 0
