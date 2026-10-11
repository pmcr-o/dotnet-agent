---
name: analyzing-dotnet-performance
description: ">-"
---

# analyzing-dotnet-performance

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-diag/skills/analyzing-dotnet-performance`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-diag` and skill `analyzing-dotnet-performance`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
