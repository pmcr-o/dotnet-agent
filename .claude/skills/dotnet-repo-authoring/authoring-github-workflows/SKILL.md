---
name: authoring-github-workflows
description: "Author and review GitHub Actions workflow YAML safely so syntactically-valid YAML can't ship a workflow that GitHub Actions refuses to run. USE FOR: editing, adding, or reviewing any file under .github/workflows/, writing run-name/name/if/env/run values that contain ${{ }} expressions, diagnosing a run that fails with 'This run likely failed because of a workflow file issue' and no jobs starting, deciding when a workflow scalar must be quoted, validating workflows with actionlint. DO NOT USE FOR: authoring application YAML unrelated to GitHub Actions, Azure Pipelines, GitLab CI, or non-workflow YAML. SCOPE: this skill covers *syntactic/structural* correctness of workflow YAML (quoting, parsing, actionlint); for *semantic and functional* workflow design (what a workflow should do, agentic-workflow behavior), see .github/agents/agentic-workflows.agent.md — the two are complementary. INVOKES: actionlint (downloaded pinned binary) plus git/grep for inspection."
---

# authoring-github-workflows

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/.agents/skills/authoring-github-workflows`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-repo-authoring` and skill `authoring-github-workflows`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
