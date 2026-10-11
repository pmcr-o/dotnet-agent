---
name: csharp-refactoring
description: "Safely refactors C#/.NET code without changing behavior. USE FOR any request to refactor, rename, move, extract, inline, merge, consolidate, deduplicate, split, or modernize C# code, including partial/generated declarations, wrappers, public APIs, serialization/reflection/configuration names, friend assemblies, conditional compilation, and multi-targeted projects. Also use when a request calls a feature, bug fix, package/framework upgrade, or public nullability change a refactor and the behavior-changing part must be separated or declined. DO NOT USE FOR ordinary feature or bug fixes not presented as refactoring; standalone upgrades after reclassification (use dotnet-upgrade); adding tests; or formatting-only work."
---

# csharp-refactoring

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet/skills/csharp-refactoring`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet` and skill `csharp-refactoring`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
