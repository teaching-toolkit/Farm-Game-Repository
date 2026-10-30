#!/usr/bin/env python3
"""Check the project's documents. Exit 1 on any problem.

- every Markdown link to a local file points at something that exists (archives are skipped);
- every ticket in .scratch/*/issues/ has a valid **Status:** and **Milestone:**;
- every `done` ticket is named (`feature/NN`) in PROJECT-LOG.md or archive/log-2026-10.md;
- ROADMAP.md's "Now" lines name no `done` ticket.

    python3 tools/check_docs.py
"""
import glob, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKIP = ("archive/", "story/archive/", ".git/", "web-build/", "reference-art/", "godot-prototype/.godot/", "node_modules/")
STATUSES = ("ready-for-agent", "needs-parent", "done")
MILESTONES = ("refactor", "prototype", "story", "later")
problems = []


def md_files():
    for dp, dn, fn in os.walk(ROOT):
        rel = os.path.relpath(dp, ROOT).replace(os.sep, "/")
        rel = "" if rel == "." else rel + "/"
        if any(rel.startswith(s) for s in SKIP):
            dn[:] = []
            continue
        for f in fn:
            if f.endswith(".md"):
                yield rel + f


LINK = re.compile(r"(?<!!)\[[^\]\n]*\]\(([^)\s]+)\)")
for f in md_files():
    text = open(os.path.join(ROOT, f), encoding="utf-8").read()
    text = re.sub(r"```.*?```", "", text, flags=re.S)  # ignore code blocks
    for m in LINK.finditer(text):
        target = m.group(1).split("#")[0]
        if not target or re.match(r"^[a-z]+:", target) or target.startswith(("/", "<")):
            continue
        path = os.path.normpath(os.path.join(ROOT, os.path.dirname(f), target))
        if not os.path.exists(path):
            problems.append(f"broken link: {f} -> {m.group(1)}")

tickets = {}
for path in sorted(glob.glob(os.path.join(ROOT, ".scratch", "*", "issues", "*.md"))):
    rel = os.path.relpath(path, ROOT)
    feat, name = path.split(os.sep)[-3], os.path.basename(path)
    if not re.match(r"\d\d-", name):
        problems.append(f"ticket file name must start with NN-: {rel}")
        continue
    text = open(path, encoding="utf-8").read()
    s = re.search(r"^\*\*Status:\*\*\s*(\S+)", text, re.M)
    m = re.search(r"^\*\*Milestone:\*\*\s*(\S+)", text, re.M)
    if not s or s.group(1) not in STATUSES:
        problems.append(f"ticket without a valid Status: {rel}")
    if not m or m.group(1) not in MILESTONES:
        problems.append(f"ticket without a valid Milestone: {rel}")
    tickets[f"{feat}/{name[:2]}"] = s.group(1) if s else "?"

logs = ""
for log in ("PROJECT-LOG.md", "archive/log-2026-10.md"):
    p = os.path.join(ROOT, log)
    if os.path.exists(p):
        logs += open(p, encoding="utf-8").read()
for k, s in tickets.items():
    if s == "done" and not re.search(r"(?<![\w-])%s(?!\d)" % re.escape(k), logs):
        problems.append(f"done ticket without a log row: {k}")

road = os.path.join(ROOT, "ROADMAP.md")
if os.path.exists(road):
    for line in open(road, encoding="utf-8"):
        if line.lstrip("- ").startswith("**Now"):
            for k in re.findall(r"\b([a-z][a-z-]+/\d\d)\b", line):
                if tickets.get(k) == "done":
                    problems.append(f"ROADMAP 'Now' names a done ticket: {k}")

for p in problems:
    print("✘ docs: " + p)
if problems:
    print(f"✘ docs: {len(problems)} problem(s)")
    sys.exit(1)
print(f"✔ docs ({len(tickets)} tickets, links, log rows, roadmap)")
