---
name: including-generated-files
description: "Own MSBuild generated-artifact integration. USE FOR: a target that creates or should create source, Content, None, or another physical file but the artifact is missing from compilation or output; target timing; evaluation-time glob misses; $(IntermediateOutputPath) placement; and FileWrites clean tracking. The prompt may describe the generated artifact without naming the producing task. DO NOT USE when the primary defect is general Include/Remove/Update semantics, item metadata or batching, duplicate/overlapping declarations, or a generated-item identity relationship; use item-management. Exclude Roslyn source-generator internals and non-MSBuild systems."
---

# including-generated-files

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-msbuild/skills/including-generated-files`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-msbuild` and skill `including-generated-files`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
