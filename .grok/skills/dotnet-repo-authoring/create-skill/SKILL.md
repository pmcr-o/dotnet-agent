---
name: create-skill
description: "Scaffolds new agent skills for the dotnet/skills repository. Use when creating a new skill, generating SKILL.md files, writing a skill description that the runtime will actually route to, or setting up skill directory structures. Handles frontmatter generation, section templates, and validation guidance. Do not use for fixing a skill that already fails its evaluation (use improve-skill-quality) or for writing eval.yaml (use create-skill-test)."
---

# create-skill

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/.agents/skills/create-skill`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-repo-authoring` and skill `create-skill`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
