---
name: item-management
description: "Own concrete MSBuild ItemGroup and item-expression questions. USE FOR: Include, Remove, Update, item identity and metadata, transforms, filtering, batching, duplicate or overlapping items, and reviews that verify whether those operations are correct. Generated items stay in scope when the central defect is item identity, metadata, batching, duplicate declarations, or glob/Remove/Update semantics. For a generated artifact missing from compilation or output, wrong target timing/path, or FileWrites clean tracking without a broader item-semantics defect, use including-generated-files. The item operation may be broken, suspected, or already correct. Exclude property-only issues, general incrementality with no item question, broad reviews with no concrete item concern, and non-MSBuild systems."
---

# item-management

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-msbuild/skills/item-management`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-msbuild` and skill `item-management`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
