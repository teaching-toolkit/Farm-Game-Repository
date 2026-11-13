#!/usr/bin/env python3
"""Usage: [S=scratch dir] export_patch.py <name>
Compares $S/w/<name>/base (pristine) with $S/w/<name>/work (the agent's edits) and writes $S/out/<name>/:
  changes.patch   unified diffs (a/ b/ labels) of every changed TEXT file   (apply from the project root with `patch -p1`)
  new/<path>      every NEW file (text or binary), whole
  binary/<path>   every changed BINARY file, whole
  deleted.txt     files that exist in base but not in work (agents must not delete files: this should be empty)
  summary.txt     the list of all of the above
Skips .git, .godot, __pycache__, .DS_Store and symlinks."""
import os, sys, subprocess, shutil, hashlib
HERE = os.path.dirname(os.path.abspath(__file__))
S = os.environ.get("S") or os.path.join(os.environ.get("TMPDIR", "/tmp"), "farm-parallel")
SKIP = {".git", ".godot", "__pycache__"}
def walk(root):
    out = {}
    for dp, dns, fns in os.walk(root, followlinks=False):
        dns[:] = [d for d in dns if d not in SKIP and not os.path.islink(os.path.join(dp, d))]
        for f in fns:
            p = os.path.join(dp, f)
            if os.path.islink(p) or f == ".DS_Store" or f.endswith(".pyc"): continue
            out[os.path.relpath(p, root)] = p
    return out
def digest(p):
    h = hashlib.sha1()
    with open(p, "rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""): h.update(b)
    return h.hexdigest()
def is_text(p):
    with open(p, "rb") as f: b = f.read(8192)
    if b"\0" in b: return False
    try: b.decode("utf-8"); return True
    except UnicodeDecodeError:
        return True if len(b) == 8192 else False
name = sys.argv[1]
W = f"{S}/w/{name}"; base, work = f"{W}/base", f"{W}/work"; out = f"{S}/out/{name}"
shutil.rmtree(out, ignore_errors=True); os.makedirs(out)
b, w = walk(base), walk(work)
patch, lines = [], []
for rel in sorted(w):
    if rel not in b:
        dst = f"{out}/new/{rel}"; os.makedirs(os.path.dirname(dst), exist_ok=True); shutil.copy2(w[rel], dst); lines.append(f"NEW      {rel}")
    elif digest(b[rel]) != digest(w[rel]):
        if is_text(w[rel]) and is_text(b[rel]):
            r = subprocess.run(["diff", "-u", "--label", f"a/{rel}", "--label", f"b/{rel}", b[rel], w[rel]], capture_output=True, text=True)
            patch.append(r.stdout); lines.append(f"CHANGED  {rel}")
        else:
            dst = f"{out}/binary/{rel}"; os.makedirs(os.path.dirname(dst), exist_ok=True); shutil.copy2(w[rel], dst); lines.append(f"BINARY   {rel}")
deleted = [rel for rel in sorted(b) if rel not in w]
for rel in deleted: lines.append(f"DELETED  {rel}")
open(f"{out}/changes.patch", "w").write("".join(patch))
open(f"{out}/deleted.txt", "w").write("\n".join(deleted) + ("\n" if deleted else ""))
open(f"{out}/summary.txt", "w").write("\n".join(lines) + "\n")
print("\n".join(lines)); print(f"-> {out}  ({len(lines)} files)")
