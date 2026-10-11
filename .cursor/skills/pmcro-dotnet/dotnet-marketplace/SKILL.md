---
name: dotnet-marketplace
description: "Inventory and byte-mirror dotnet/skills into a skills-only dotnet-agent marketplace with PMCR-O overlays, bounded batches, portable manifests, host catalogs and shared .agents to .pmcro skill discovery."
---

# .NET marketplace
Use scripts/mirror.py inventory --upstream <clean-dotnet-skills-checkout> to inspect the pinned source.
Use mirror --root <workspace> --upstream <checkout> --out <new-relative-directory> --overlay-skill <relative-skill> repeatedly to select our DotAgent layer. Default is a write-free preview.
After reviewing the plan, add --apply. This copies actual upstream skills, all resources and licenses; it does not rewrite skill instructions. The loop uses bounded plugin batches within one goal.
Use verify --root <generated-marketplace> to validate exact source hashes and canonical skill copies.
Have a separate checker verify criteria and rerun checks before considering the marketplace complete.
Run pwsh -NoProfile -File scripts/link-host-skills.ps1 -Workspace <generated-marketplace> to establish .agents/skills -> .pmcro/skills, then .claude/skills and .grok/skills -> .agents/skills.
Only add project-local links. Existing mismatched paths are refused.
Read references/contract.md for scope and progressive disclosure.
The next seed is extension of the existing MAF application at W:/ProjectName after .NET marketplace verification.
