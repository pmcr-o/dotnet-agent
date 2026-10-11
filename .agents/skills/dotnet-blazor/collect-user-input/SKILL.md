---
name: collect-user-input
description: "Build forms, validate data, and react to user input in Blazor. USE FOR adding forms, search boxes, filter panels, inline editing, data-entry UI, file uploads, validation (annotations or custom), handling form submissions, and binding input controls. Covers EditForm, built-in input components, DataAnnotationsValidator, custom validation, SSR form patterns (SupplyParameterFromForm, FormName, AntiforgeryToken, Enhance), and @bind for simple interactive controls. DO NOT USE for project scaffolding (see create-blazor-project) or prerendering issues (see support-prerendering)."
---

# collect-user-input

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-blazor/skills/collect-user-input`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-blazor` and skill `collect-user-input`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
