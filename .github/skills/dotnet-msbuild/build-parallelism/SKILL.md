---
name: build-parallelism
description: "Analyze an MSBuild solution, solution filter, or Build.proj that schedules multiple project files. USE FOR: measured idle worker nodes, `-m` that does not scale, a serial ProjectReference critical path, graph builds, or an MSBuild task that builds a Projects list. Requires at least two distinct project files whose scheduling or throughput must be analyzed. DO NOT USE for non-MSBuild build systems."
---

# build-parallelism

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-msbuild/skills/build-parallelism`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-msbuild` and skill `build-parallelism`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
