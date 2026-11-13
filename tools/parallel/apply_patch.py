#!/usr/bin/env python3
"""Usage: [S=scratch dir] apply_patch.py <name> [--dry-run]   (the orchestrator's tool: applies $S/out/<name> to the REAL project)"""
import os, sys, subprocess, shutil
HERE = os.path.dirname(os.path.abspath(__file__))
S = os.environ.get("S") or os.path.join(os.environ.get("TMPDIR", "/tmp"), "farm-parallel")
R = os.path.abspath(os.path.join(HERE, "..", ".."))
name = sys.argv[1]; dry = "--dry-run" in sys.argv; out = f"{S}/out/{name}"
pf = f"{out}/changes.patch"
if os.path.getsize(pf) > 0:
    r = subprocess.run(["patch", "-p1", "--dry-run", "-i", pf], cwd=R, capture_output=True, text=True)
    print(r.stdout.strip()); print(r.stderr.strip())
    if r.returncode != 0 and "--force" not in sys.argv:
        print("PATCH DOES NOT APPLY CLEANLY (dry run) - nothing was changed"); sys.exit(1)
    if not dry:
        r = subprocess.run(["patch", "-p1", "--no-backup-if-mismatch", "-i", pf], cwd=R, capture_output=True, text=True); print(r.stdout.strip()); print(r.stderr.strip())
for sub in ("new", "binary"):
    for dp, _, fns in os.walk(f"{out}/{sub}"):
        for f in fns:
            src = os.path.join(dp, f); rel = os.path.relpath(src, f"{out}/{sub}"); dst = os.path.join(R, rel)
            if sub == "new" and os.path.exists(dst): print(f"CONFLICT: new file already exists: {rel}"); continue
            print(("would copy " if dry else "copied ") + f"{sub}: {rel}")
            if not dry: os.makedirs(os.path.dirname(dst), exist_ok=True); shutil.copy2(src, dst)
d = open(f"{out}/deleted.txt").read().split()
if d: print("NOT deleting (agents must not delete):", d)
