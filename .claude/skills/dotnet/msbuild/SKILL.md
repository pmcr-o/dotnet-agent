---
name: msbuild
description: "Use only for MSBuild failure investigation, build-performance analysis, or review of existing build XML/extension contracts. A plan to convert a working legacy/non-SDK project to SDK style or migrate packages.config is a project-system migration, NOT a build-file review: do not activate, even to check scope. Framework/API upgrades are also excluded. Activate for advisory Import/Exists hook and NuGet packed-import questions even without a checkout or failed build; .csproj/.fsproj/.vbproj/.props/.targets conditions; custom-target inputs/outputs; .binlog capture/replay; failing dotnet build/restore/pack/publish or MSBuild-based test builds; slow evaluation, compilation, copying, or no-change builds; and controlled timing comparisons. Exclude SDK installation alone, C# refactoring, runtime profiling, assertions after successful builds, and non-MSBuild builds."
---

# msbuild

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet/skills/msbuild`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet` and skill `msbuild`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
