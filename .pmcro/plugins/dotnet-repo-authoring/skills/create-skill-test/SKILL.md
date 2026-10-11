---
name: create-skill-test
description: "Scaffolds eval.yaml evaluation specs for skills, custom agents, and redistributable gh-aw workflow packages in the dotnet/skills repository. Use when creating skill or workflow-package tests, writing evaluation stimuli, defining graders and rubrics, sizing an eval for statistical power, or setting up test fixture files. Handles the Vally eval.yaml schema, fixture organization, and overfitting avoidance. Do not use for running or debugging existing evals (use improve-skill-quality) nor for skills authoring (use create-skill)."
---

# create-skill-test

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/.agents/skills/create-skill-test`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-repo-authoring` and skill `create-skill-test`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
