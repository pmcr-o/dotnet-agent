---
name: create-custom-agent
description: "Creates VS Code custom agent files (.agent.md) for specialized AI personas with tools, instructions, and handoffs. Use when scaffolding new custom agents, configuring agent workflows, or setting up agent-to-agent handoffs."
---

# create-custom-agent

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/.agents/skills/create-custom-agent`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-repo-authoring` and skill `create-custom-agent`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
