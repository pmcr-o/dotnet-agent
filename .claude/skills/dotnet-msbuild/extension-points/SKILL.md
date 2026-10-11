---
name: extension-points
description: "Own MSBuild import and hook discovery. USE FOR: CustomBefore/CustomAfter hooks, ordered wildcard and NuGet auto-imports, control properties, build/buildTransitive packed layout, package ID and file-name matching, per-TFM forwarders, and tracing why assets or hooks are missing, broken, or replaced. An import guard remains in scope when it is one defect in a broader hook/import flow. DO NOT USE for a focused safety verdict on whether one specific Import needs Exists or is an intentionally unguarded package contract; use msbuild-antipatterns. NEVER INVOKE when imports and hook placement already work and the request is only target Inputs/Outputs, incremental skipping, or FileWrites clean tracking; use incremental-build or target-authoring. Exclude props-versus-targets placement and non-MSBuild systems."
---

# extension-points

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-msbuild/skills/extension-points`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-msbuild` and skill `extension-points`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
