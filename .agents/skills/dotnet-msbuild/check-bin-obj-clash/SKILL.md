---
name: check-bin-obj-clash
description: "Detects MSBuild projects with conflicting OutputPath or IntermediateOutputPath. USE FOR: builds failing with 'Cannot create a file when that file already exists', 'The process cannot access the file because it is being used by another process', intermittent build failures that succeed on retry, or missing/overwritten outputs in multi-project or multi-targeting builds where bin/obj (or project.assets.json) collide. Common causes: shared OutputPath, missing AppendTargetFrameworkToOutputPath, extra global properties (e.g. PublishReadyToRun), or SetTargetFramework on a ProjectReference to a single-targeting project. DO NOT USE FOR: file access errors unrelated to MSBuild (OS-level locking), single-project single-TFM builds, non-MSBuild build systems."
---

# check-bin-obj-clash

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-msbuild/skills/check-bin-obj-clash`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-msbuild` and skill `check-bin-obj-clash`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
