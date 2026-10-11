---
name: msbuild-antipatterns
description: "DO NOT INVOKE when the primary request explicitly asks to convert, migrate, modernize, or rewrite a legacy/old-style project to SDK style; use msbuild-modernization. Migration prompts often mention ToolsVersion, explicit Compile/Reference entries, packages.config, or Microsoft.CSharp.targets, but merely reviewing or auditing a file that contains those patterns remains in scope here. USE FOR broad review, audit, lint, or maintainability/correctness checks of project/build files, including custom targets; prioritized cross-cutting findings; discrete anti-patterns; F# ordering/FS0039; cross-platform paths; and focused Import safety verdicts. Review/audit is analysis-only unless fixes are requested. For concrete property/item defects use property-patterns/item-management; use target-authoring for implementation and extension-points for NuGet auto-import/layout discovery. Exclude non-MSBuild systems."
---

# msbuild-antipatterns

This is a PMCR-O integration wrapper over the pinned `dotnet/skills` repository.
The upstream source remains immutable at `.pmcro/upstream/dotnet-skills/plugins/dotnet-msbuild/skills/msbuild-antipatterns`.

## Workflow
1. Route only after `.agents/catalog.json` selects plugin `dotnet-msbuild` and skill `msbuild-antipatterns`.
2. Read `references/upstream.md`, then the upstream source on demand.
3. Use `scripts/integrate.ps1` for both agent execution and manual terminal execution.
4. Integration is dry-run by default. `-Apply` is explicit and never widens the current grant.
5. Return exact source path, command, exit code, and evidence to the PMCR-O checker.
