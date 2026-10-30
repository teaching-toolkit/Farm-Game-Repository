#!/usr/bin/env python3
"""Print the tracker's frontier and the parent's queue.

    python3 tools/tracker.py             frontier + parent's queue (milestones refactor and prototype)
    python3 tools/tracker.py --all       every milestone
    python3 tools/tracker.py --counts    counts per status and milestone

Frontier: `ready-for-agent` tickets whose blockers are all `done`.
Parent's queue: `needs-parent` tickets, refactor first, then by size (quick, short, sitting, unsized).
Rules: .scratch/README.md.
"""
import glob, os, re, sys
from collections import Counter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ORDER = ["refactor", "prototype", "story", "later"]
SIZES = ["quick", "short", "sitting"]


def field(text, name):
    m = re.search(r"^\*\*%s:\*\*\s*(.*)$" % name, text, re.M)
    return m.group(1).strip() if m else ""


def load():
    tickets = {}
    for path in sorted(glob.glob(os.path.join(ROOT, ".scratch", "*", "issues", "[0-9]*.md"))):
        text = open(path, encoding="utf-8").read()
        feat = path.split(os.sep)[-3]
        nn = os.path.basename(path)[:2]
        status = field(text, "Status").split()[0] if field(text, "Status") else "?"
        blocked = field(text, "Blocked by")
        blockers = [] if blocked.lower().startswith("none") else re.findall(r"\b([a-z][a-z-]+/\d\d)\b", blocked)
        title = text.split("\n", 1)[0].lstrip("# ").strip()
        size = (field(text, "Size").split() or [""])[0].rstrip(".,(")
        tickets[f"{feat}/{nn}"] = dict(path=os.path.relpath(path, ROOT), status=status, title=title,
                                       milestone=field(text, "Milestone"), blockers=blockers, size=size)
    return tickets


def main():
    t = load()
    show = ORDER if "--all" in sys.argv else ORDER[:2]
    if "--counts" in sys.argv:
        c = Counter((v["milestone"], v["status"]) for v in t.values())
        for m in ORDER:
            print(f"{m:10} " + "  ".join(f"{s} {c[(m, s)]}" for s in ["ready-for-agent", "needs-parent", "done"]))
        return
    def done(k):
        return k in t and t[k]["status"] == "done"
    print("FRONTIER (ready, all blockers done)")
    for m in show:
        for k, v in t.items():
            if v["milestone"] == m and v["status"] == "ready-for-agent" and all(done(b) for b in v["blockers"]):
                print(f"  [{m}] {k}  {v['title']}")
    print("\nPARENT'S QUEUE (needs-parent)")
    q = [(k, v) for k, v in t.items() if v["status"] == "needs-parent" and v["milestone"] in show]
    blocking = {b for v in t.values() for b in v["blockers"]}
    q.sort(key=lambda kv: (ORDER.index(kv[1]["milestone"]) if kv[1]["milestone"] in ORDER else 9,
                           0 if kv[0] in blocking else 1,
                           SIZES.index(kv[1]["size"]) if kv[1]["size"] in SIZES else 3, kv[0]))
    for k, v in q:
        flag = " (others wait on it)" if k in blocking else ""
        print(f"  [{v['milestone']}] {v['size'] or '-':7} {k}  {v['title']}{flag}")


if __name__ == "__main__":
    main()
