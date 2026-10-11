---
name: directory-build-organization
description: "USE ONLY for (1) two or more projects with repeated MSBuild policy, targets, or package versions, or (2) an existing Directory.Build.props/targets/rsp hierarchy with an import, placement, or layering defect. A one-project repo without an existing Directory.Build file is outside scope; do not load this skill. Covers centralizing shared policy and targets, Directory.Packages.props across projects, parent hierarchy/import structure, props-versus-targets placement, and folder/project exceptions. An existing hierarchy defect remains in scope when only one project is affected. For property value or condition semantics use property-patterns. Exclude legacy-to-SDK migration and non-MSBuild systems."
---

# directory-build-organization

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-msbuild/skills/directory-build-organization`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-msbuild` and skill `directory-build-organization`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
