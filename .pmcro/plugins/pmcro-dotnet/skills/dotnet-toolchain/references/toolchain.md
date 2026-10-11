# .NET toolchain contract

## Check
`scripts/dotnet-toolchain.ps1 -Action Check` lists registered runtimes with `dotnet --list-runtimes`.
For each runtime named in `assets/runtime-markers.json` it tests that the marker file exists in
`<root>/<version>/`. A runtime that is registered but missing its marker is a FAIL, because the host
can list it yet fail to start with `Failed to create CoreCLR, HRESULT: 0x80070002`.
`-Version 10.0` additionally requires an intact runtime whose version starts with that prefix.
`-DotnetRoot <dir>` scans `<dir>/shared/<framework>/<version>` directly, for testing a copy or tree.
Exit 0 = PASS, 1 = FAIL, 2 = invalid arguments. The check never writes.

## Install
`-Action Install -Version 10.0.12` prints `DRY-RUN <command>` lines and changes nothing.
`-Apply` runs those same commands. Options: `-Kind Runtime|Sdk`, `-Method Script|Winget`.
- Script: downloads Microsoft's `dotnet-install.ps1` to the temp folder, then installs into the
  per-user folder `%LOCALAPPDATA%\Microsoft\dotnet`. No administrator rights are needed. The new
  install is not on PATH; set `DOTNET_ROOT` and PATH to use it.
- Winget: `winget install --id Microsoft.DotNet.Runtime.<major>` or `Microsoft.DotNet.SDK.<major>`
  at the exact version. This installs machine-wide and may ask for elevation.
Versions must be exact, such as `10.0.12`; anything else is refused with exit 2.

## Limits
This skill does not repair a damaged machine-wide runtime in place. It reports the damage, and a
person chooses a reinstall. A dry run is not evidence that an install happened; run Check after
`-Apply` and read its output.
