---
name: optimizing-ef-core-queries
description: "Optimize and improve the performance of slow Entity Framework Core (EF Core) queries: make them generate less SQL, make fewer database round-trips, and return results faster. Use whenever an EF Core or DbContext query or data-access path is slow or should be made faster — whether or not EF Core owns the database schema. For EF Core, not Dapper or raw ADO.NET."
---

# optimizing-ef-core-queries

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-data/skills/optimizing-ef-core-queries`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-data` and skill `optimizing-ef-core-queries`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
