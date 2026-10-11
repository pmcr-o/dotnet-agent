# Mirror contract
Every upstream skill directory is preserved byte-for-byte at its original plugins/<plugin>/skills/<skill> path, including nested resources. Generated manifests belong to our distribution. Upstream plugin executables, MCP declarations, LSP configuration and custom agent definitions are outside this skills-only projection.
A clean upstream git checkout and its exact revision identify the import. Every discovered skills folder is checked, including separately labeled experimental folders.
Canonical host skills live in .pmcro/skills; .agents/skills points there, while Claude/Grok use .agents/skills through local directory junctions.
Duplicate skill names fail, so flattening the discovery projection cannot silently overwrite another skill. Plugin grouping remains in the original mirror.
MAF reads configured roots through its native provider: metadata -> instructions -> selected resources -> authorized scripts. Global home-directory skills are not required.
Native message types, session continuity and Ollama serialization belong to the existing MAF application.
