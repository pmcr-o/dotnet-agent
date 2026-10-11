---
name: dotnet-toolchain
description: "Check that installed .NET runtimes are intact and install a specific .NET runtime or SDK. Dry-run by default; changes the machine only with -Apply. Use before building or running .NET apps, or when dotnet fails to start."
---

# .NET toolchain
Check or install .NET runtimes and SDKs with one script that an agent and a person run the same way.
Run `powershell -NoProfile -File scripts/dotnet-toolchain.ps1 -Action Check` to test every registered runtime. It exits 1 and names any runtime that is registered but missing its marker file, such as `System.Private.CoreLib.dll`.
Run the same script with `-Action Install -Version <exact version>` to see the install commands as `DRY-RUN` lines. Add `-Apply` only when the person has authorized changing the machine. Options: `-Kind Runtime|Sdk`, `-Method Script|Winget`.
After `-Apply`, run Check again and report its output. A dry run proves nothing was installed.
Read references/toolchain.md for exit codes, install locations and limits.
Run tests/test-dotnet-toolchain.ps1 to exercise the script against temporary runtime trees.
This skill does not repair a damaged runtime in place and does not claim an install from a plan.
