"""Mirror upstream skill trees and assemble a skills-only dotnet-agent marketplace."""
import argparse, hashlib, json, re, shutil, subprocess, sys
from pathlib import Path
from datetime import datetime, timezone

def load(path):
    return json.loads(Path(path).read_text(encoding="utf-8-sig"))
def write(path, value):
    path=Path(path); path.parent.mkdir(parents=True,exist_ok=True)
    path.write_text(json.dumps(value,indent=2,ensure_ascii=False)+"\n",encoding="utf-8")
def contained(root, relative):
    root=Path(root).resolve(); rel=Path(relative)
    if rel.is_absolute() or rel.drive or ".." in rel.parts: raise ValueError("Use a relative workspace path")
    target=(root/rel).resolve()
    if not target.is_relative_to(root): raise ValueError("Path escapes workspace")
    return target
def files(root):
    root=Path(root).resolve(); result={}
    for path in sorted(root.rglob("*")):
        if path.is_symlink() or bool(getattr(path.lstat(),"st_file_attributes",0) & 0x400) or not path.resolve().is_relative_to(root): raise ValueError("Linked source: "+str(path))
        if path.is_file() and "__pycache__" not in path.parts and path.suffix!=".pyc":
            result[path.relative_to(root).as_posix()]=hashlib.sha256(path.read_bytes()).hexdigest()
    return result
def metadata(path):
    text=(path/"SKILL.md").read_text(encoding="utf-8-sig")
    match=re.match(r"\A---\r?\n(.*?)\r?\n---",text,re.S)
    if not match: raise ValueError("Missing frontmatter: "+str(path))
    found=re.search(r"(?m)^name:\s*['\"]?([a-z0-9-]+)",match[1])
    if not found or found[1]!=path.name: raise ValueError("Skill name mismatch: "+str(path))
    if not re.search(r"(?m)^description:\s*\S",match[1]): raise ValueError("Missing description: "+str(path))
    return found[1]
def git(root,*args):
    return subprocess.check_output(["git","-C",str(root),*args],text=True,encoding="utf-8").strip()
def inspect(upstream):
    upstream=Path(upstream).resolve()
    revision=git(upstream,"rev-parse","HEAD")
    if git(upstream,"status","--porcelain","--","plugins",".claude-plugin/marketplace.json","LICENSE"):
        raise ValueError("Upstream skills/catalog/license must be clean before mirroring")
    published={p["name"]:p for p in load(upstream/".claude-plugin/marketplace.json")["plugins"]}
    plugins=[]; names=set()
    for directory in sorted((upstream/"plugins").iterdir()):
        skills=directory/"skills"
        if not skills.is_dir(): continue
        selected=[]
        for path in sorted(skills.iterdir()):
            if not path.is_dir() or not (path/"SKILL.md").is_file(): continue
            skill=metadata(path)
            if skill in names: raise ValueError("Duplicate skill name: "+skill)
            names.add(skill)
            selected.append({"name":skill,"path":path.relative_to(upstream).as_posix(),"files":files(path)})
        if selected: plugins.append({"name":directory.name,"publishedUpstream":directory.name in published,"skills":selected})
    if not plugins: raise ValueError("No skills found")
    return {"repository":git(upstream,"remote","get-url","origin"),"revision":revision,"plugins":plugins,
            "skillCount":len(names),"publishedPlugins":len(published)}
def mirror(root,upstream,out,overlays,batch_size=3,apply=False):
    root=Path(root).resolve(); upstream=Path(upstream).resolve()
    destination=contained(root,out)
    if destination.exists(): raise ValueError("Destination exists; choose a new version")
    if destination==upstream or destination.is_relative_to(upstream): raise ValueError("Destination must be outside upstream")
    snapshot=inspect(upstream)
    selected=[]; names={s["name"] for p in snapshot["plugins"] for s in p["skills"]}
    for relative in overlays:
        source=contained(root,relative); skill=metadata(source)
        if skill in names: raise ValueError("Duplicate overlay skill: "+skill)
        names.add(skill); selected.append({"name":skill,"source":relative,"files":files(source)})
    batches=[snapshot["plugins"][i:i+batch_size] for i in range(0,len(snapshot["plugins"]),batch_size)]
    plan={"goal":"Mirror upstream dotnet skills and add PMCR-O DotAgent skills","nextSeed":"Inspect W:/ProjectName and extend the existing MAF application after this marketplace",
          "simulation":not apply,"revision":snapshot["revision"],"upstreamSkills":snapshot["skillCount"],"overlaySkills":len(selected),"batches":len(batches),"destination":str(destination)}
    if not apply: return plan
    catalog=[]; trail=[]
    license_source=upstream/"LICENSE"
    if not license_source.is_file(): raise ValueError("Upstream license missing")
    for number,batch in enumerate(batches,1):
        for plugin in batch:
            plugin_root=destination/"plugins"/plugin["name"]
            for skill in plugin["skills"]:
                source=contained(upstream,skill["path"])
                # Preserve the exact upstream plugin/skills/skill tree and bytes.
                target=destination/skill["path"]
                shutil.copytree(source,target,ignore=shutil.ignore_patterns("__pycache__","*.pyc"))
                if files(target)!=skill["files"]: raise ValueError("Copied skill differs: "+skill["name"])
                # Shared canonical host tree is a byte-identical projection.
                shutil.copytree(source,destination/".pmcro/skills"/skill["name"],ignore=shutil.ignore_patterns("__pycache__","*.pyc"))
            description="Byte-preserved .NET skills from dotnet/skills: "+plugin["name"]
            if not plugin["publishedUpstream"]: description+=" (upstream experimental/unpublished)"
            manifest(plugin_root,plugin["name"],description,".NET Team at Microsoft")
            shutil.copyfile(license_source,plugin_root/"LICENSE")
            catalog.append({"name":plugin["name"],"source":"./plugins/"+plugin["name"],"description":description})
        trail.append({"batch":number,"plugins":[p["name"] for p in batch],"status":"PASS","evidence":"byte-equality","independentModelVerdict":False})
    own=destination/"plugins/dotnet-agent"
    for item in selected:
        source=contained(root,item["source"])
        shutil.copytree(source,own/"skills"/item["name"],ignore=shutil.ignore_patterns("__pycache__","*.pyc"))
        shutil.copytree(source,destination/".pmcro/skills"/item["name"],ignore=shutil.ignore_patterns("__pycache__","*.pyc"))
    if selected:
        manifest(own,"dotnet-agent","PMCR-O high-level intent orchestration and DotAgent authoring workflows","PMCR-O")
        if (root/"LICENSE").is_file(): shutil.copyfile(root/"LICENSE",own/"LICENSE")
        catalog.insert(0,{"name":"dotnet-agent","source":"./plugins/dotnet-agent","description":"Manage goals and extend this skills-only marketplace"})
    write(destination/".claude-plugin/marketplace.json",{"name":"dotnet-agent","owner":{"name":"PMCR-O"},"plugins":catalog})
    write(destination/".agents/plugins/marketplace.json",{"name":"dotnet-agent","interface":{"displayName":"PMCR-O .NET Agent"},"plugins":[
        {"name":p["name"],"source":{"source":"local","path":p["source"]},"policy":{"installation":"AVAILABLE","authentication":"ON_INSTALL"}} for p in catalog]})
    shutil.copyfile(license_source,destination/"LICENSE.dotnet")
    write(destination/".pmcro/mirror.json",{"source":snapshot,"overlays":selected,"goal":plan})
    write(destination/".pmcro/batches.json",trail)
    (destination/"README.md").write_text(README,encoding="utf-8")
    write(destination/"mirror-lock.json",{"kind":"dotnet-agent.skills-mirror","sourceRevision":snapshot["revision"],"packageFiles":files(destination)})
    return {**plan,"status":"PASS","plugins":len(catalog)}
def manifest(root,name,description,author):
    portable={"$schema":"https://agent-plugins.org/schemas/1.0.0/plugin.schema.json","name":name,"version":"0.1.0","description":description,"author":{"name":author},"license":"MIT"}
    write(root/"plugin.json",portable)
    compatibility={k:v for k,v in portable.items() if k!="$schema"}
    write(root/".claude-plugin/plugin.json",{**compatibility,"skills":"./skills/"})
    write(root/".codex-plugin/plugin.json",{**compatibility,"skills":"./skills/","interface":{"displayName":name,"shortDescription":description}})
def package_inventory(root):
    expected_links={".agents/skills":".pmcro/skills",".claude/skills":".agents/skills",".grok/skills":".agents/skills"}
    result={}
    def walk(directory):
        for path in sorted(directory.iterdir()):
            relative=path.relative_to(root).as_posix()
            if relative in expected_links:
                if not (path.is_symlink() or bool(getattr(path.lstat(),"st_file_attributes",0) & 0x400)):
                    raise ValueError("Host skill projection must be a link: "+relative)
                if path.resolve()!=contained(root,expected_links[relative]):
                    raise ValueError("Unexpected host skill target: "+relative)
                continue
            if path.is_symlink() or bool(getattr(path.lstat(),"st_file_attributes",0) & 0x400):
                raise ValueError("Unexpected linked package content: "+relative)
            if path.is_dir(): walk(path)
            elif path.is_file() and relative!="mirror-lock.json":
                result[relative]=hashlib.sha256(path.read_bytes()).hexdigest()
    walk(root)
    return result

def verify(root):
    root=Path(root).resolve(); lock=load(root/"mirror-lock.json")
    if package_inventory(root)!=lock["packageFiles"]: raise ValueError("Package file inventory changed (added, removed or modified files)")
    for relative,sha in lock["packageFiles"].items():
        target=contained(root,relative)
        if not target.is_file() or hashlib.sha256(target.read_bytes()).hexdigest()!=sha: raise ValueError("Changed mirror file: "+relative)
    info=load(root/".pmcro/mirror.json")
    count=0
    for plugin in info["source"]["plugins"]:
        for skill in plugin["skills"]:
            if files(root/skill["path"])!=skill["files"]: raise ValueError("Upstream mirror mismatch")
            if files(root/".pmcro/skills"/skill["name"])!=skill["files"]: raise ValueError("Canonical skill mismatch")
            count+=1
    for skill in info["overlays"]:
        if files(root/"plugins/dotnet-agent/skills"/skill["name"])!=skill["files"] or files(root/".pmcro/skills"/skill["name"])!=skill["files"]: raise ValueError("Overlay mismatch")
        count+=1
    return {"status":"PASS","skills":count,"sourceRevision":info["source"]["revision"],"evidence":"byte-equality-and-required-files"}
README="""# PMCR-O .NET Agent marketplace
This is a skills-only mirror of a pinned dotnet/skills revision plus PMCR-O's DotAgent layer.
Start with goal-orchestrator. One seed owns inventory, bounded batches, checks and delivery.
Upstream plugin grouping and every skill resource are preserved under plugins/<plugin>/skills/<skill>.
.pmcro/skills is the canonical shared projection. Host skill links route .claude/skills and .grok/skills through .agents/skills to .pmcro/skills.
Run the packaged dotnet-marketplace/scripts/link-host-skills.ps1 to create and verify the links.
The .agents/plugins and .claude-plugin catalogs install standard plugin copies; use either marketplace installation or direct shared skill discovery per host to avoid duplicate advertisements.
Skill discovery follows progressive disclosure: metadata first; selected instructions second; resources/scripts on demand.
Native MAF integration uses AgentSkillsProvider and local Ollama. The existing W:/ProjectName application is the next seed; this package does not include another application.
Conversation messages must use native MAF types and tool call/result IDs, with OllamaSharp handling API serialization.
This mirror imports only skills. Upstream MCP, LSP, hooks and host-specific agents are not installed by copying their skill instructions.
Experimental upstream folders are labeled and remain separately selectable plugins.
See .pmcro/mirror.json for revision and per-skill hashes, .pmcro/batches.json for the completed batch evidence, and mirror-lock.json for package integrity.
"""
def main():
    p=argparse.ArgumentParser(description=__doc__); sub=p.add_subparsers(dest="command",required=True)
    i=sub.add_parser("inventory"); i.add_argument("--upstream",required=True); i.add_argument("--out")
    m=sub.add_parser("mirror"); m.add_argument("--root",required=True); m.add_argument("--upstream",required=True); m.add_argument("--out",required=True); m.add_argument("--overlay-skill",action="append",default=[]); m.add_argument("--batch-size",type=int,default=3); m.add_argument("--apply",action="store_true")
    v=sub.add_parser("verify"); v.add_argument("--root",required=True)
    args=p.parse_args()
    try:
        if args.command=="inventory":
            result=inspect(args.upstream)
            if args.out: write(args.out,result)
            print(json.dumps({"revision":result["revision"],"plugins":len(result["plugins"]),"skills":result["skillCount"],"unpublished":[p["name"] for p in result["plugins"] if not p["publishedUpstream"]]},indent=2))
            return
        if args.command=="mirror":
            if not 1<=args.batch_size<=5: raise ValueError("Batch size must be 1-5")
            result=mirror(args.root,args.upstream,args.out,args.overlay_skill,args.batch_size,args.apply)
        else: result=verify(args.root)
        print(json.dumps(result,indent=2))
    except (ValueError,OSError,KeyError,subprocess.SubprocessError) as e:
        print("FAIL: "+str(e),file=sys.stderr); raise SystemExit(1)
if __name__=="__main__": main()
