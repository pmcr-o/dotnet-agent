---
name: create-datadriven-aspnetcore
description: "Generate or scaffold ASP.NET Core code — Razor Pages, Blazor components, MVC controllers, views, and Minimal API endpoints — without using ASP.NET Core CLI scaffolding/code-generation tools. Use when (1) adding CRUD pages, views, or API endpoints backed by Entity Framework (EF Core) and a database, (2) generating code to create, read, update, and delete data using a DbContext, (3) scaffolding UI components that match the project's existing CSS framework and coding patterns, or (4) creating data-driven forms, tables, and navigation for a model class. Do not use for non-ASP.NET projects or when CLI-based scaffolding is preferred."
---

# create-datadriven-aspnetcore

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-data/skills/create-datadriven-aspnetcore`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-data` and skill `create-datadriven-aspnetcore`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
