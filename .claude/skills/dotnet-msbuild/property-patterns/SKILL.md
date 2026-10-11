---
name: property-patterns
description: "Diagnose and fix concrete MSBuild property defects in projects and existing shared-file hierarchies. USE FOR: conditions, defaults, append versus overwrite, last-write-wins values, OS/TFM checks, portable paths, normalization, and reviews centered on those property defects. Property defects in Directory.Build.* remain in scope, including overwritten values across parent/child imports and conditions that run before TargetFramework is set, even when the fix changes import order or moves a property group to .targets. DO NOT USE FOR: placement-only or import-only requests with no concrete property defect, such as discovering shared files or choosing which file owns a target or customization (use directory-build-organization); item operations; target structure; broad reviews without a concrete property defect; non-MSBuild work."
---

# property-patterns

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-msbuild/skills/property-patterns`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-msbuild` and skill `property-patterns`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
