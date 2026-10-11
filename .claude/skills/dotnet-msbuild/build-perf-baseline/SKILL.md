---
name: build-perf-baseline
description: "Establish MSBuild/.NET build performance baselines before optimizing. USE FOR: a .NET build or solution that is slow or has build-performance concerns; cold, warm, incremental, or no-op measurements; before/after comparisons; CI build output caching; static graph build decisions; artifacts output; and dependency graph trimming. Start here before build-perf-diagnostics, incremental-build, or build-parallelism. DO NOT USE for webpack, npm, JavaScript bundlers, or other non-MSBuild build systems. For detailed target/task/analyzer bottleneck analysis after baselining, use build-perf-diagnostics."
---

# build-perf-baseline

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-msbuild/skills/build-perf-baseline`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-msbuild` and skill `build-perf-baseline`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
