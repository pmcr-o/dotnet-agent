---
name: migrate-mstest-v1v2-to-v3
description: ">"
---

# migrate-mstest-v1v2-to-v3

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-test-migration/skills/migrate-mstest-v1v2-to-v3`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-test-migration` and skill `migrate-mstest-v1v2-to-v3`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
