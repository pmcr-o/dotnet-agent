---
name: improve-skill-quality
description: "Diagnoses and fixes skills in the dotnet/skills repository that lose to their own baseline, fail to activate, time out, or return 'no credible improvement'. Use when an evaluation verdict is a regression or underpowered, when a skill regressed after a change, when /evaluate reports no results, or when deciding whether a weak skill should be strengthened or retired. Do not use for scaffolding a brand-new skill (use create-skill) or a brand-new eval (use create-skill-test)."
---

# improve-skill-quality

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/.agents/skills/improve-skill-quality`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-repo-authoring` and skill `improve-skill-quality`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
