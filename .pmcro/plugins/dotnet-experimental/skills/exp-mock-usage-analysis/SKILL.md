---
name: exp-mock-usage-analysis
description: "Audits .NET test mock usage by tracing each mock setup through the production code's execution path to find dead, unreachable, redundant, or replaceable mocks. Use when the user asks to audit mock usage, find unused or unnecessary mock setups, check if mocks are needed, reduce mock duplication or over-mocking, simplify test setup, or review whether mock configurations like ILogger/IOptions should use real implementations instead. Supports Moq, NSubstitute, and FakeItEasy."
---

# exp-mock-usage-analysis

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-experimental/skills/exp-mock-usage-analysis`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-experimental` and skill `exp-mock-usage-analysis`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
