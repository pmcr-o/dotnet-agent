---
name: csharp-scripts
description: "Run file-based C# apps with the .NET CLI when the user explicitly wants C#/.NET code without creating a project. Use for C# language/API experiments, one-file C# apps, small multi-file C# apps composed with `#:include`/`#:exclude`, or C# file-based apps linked with `#:ref`. Do not use for language-agnostic throwaway scripts, generic computations, Python/PowerShell-style automation, full projects, or existing app integration."
---

# csharp-scripts

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-advanced/skills/csharp-scripts`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-advanced` and skill `csharp-scripts`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
