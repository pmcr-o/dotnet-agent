---
name: migrate-static-to-wrapper
description: ">"
---

# migrate-static-to-wrapper

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-test/skills/migrate-static-to-wrapper`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-test` and skill `migrate-static-to-wrapper`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
