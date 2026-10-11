---
name: fetch-and-send-data
description: "Call APIs, load data into components, and handle the async lifecycle in Blazor. USE FOR fetching data from a backend, submitting data to an API, displaying loading/error states, registering HttpClient, building service abstractions for Auto/WebAssembly render modes. DO NOT USE for form validation (see collect-user-input), prerendering persistence (see support-prerendering), or project scaffolding (see create-blazor-project)."
---

# fetch-and-send-data

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-blazor/skills/fetch-and-send-data`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-blazor` and skill `fetch-and-send-data`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
