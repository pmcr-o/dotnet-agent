---
name: support-prerendering
description: "Make interactive Blazor components work correctly with prerendering. USE FOR fixing duplicate data loads, UI flicker during prerender-to-interactive handoff, null references during prerender, persisting state across prerender, disabling prerendering, excluding pages from interactive routing, or detecting whether a component is currently prerendering. DO NOT USE for choosing which render mode to use (see create-blazor-project) or general component authoring (see author-component)."
---

# support-prerendering

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-blazor/skills/support-prerendering`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-blazor` and skill `support-prerendering`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
