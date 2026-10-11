---
name: assertion-quality
description: "Analyze assertion quality, depth, variety, and false confidence in existing tests. ALWAYS USE when asked about weak, shallow, trivial, always-true, self-referential, assertion-free, presence/truthiness-only, or insufficiently diverse assertions, including MSTest, Jest, pytest, and Go. DO NOT USE for direct fixes: writing-mstest-tests owns supplied MSTest assertions; code-testing owns new cases. Use test-gap-analysis when asked whether tests would catch a production change, and test-anti-patterns for general severity-ranked audits."
---

# assertion-quality

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-test/skills/assertion-quality`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-test` and skill `assertion-quality`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
