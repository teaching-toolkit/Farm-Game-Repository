#!/usr/bin/env python3
"""Checks the game's data for mistakes a person (or an AI session) easily makes when editing it by hand (phase 2, R8).
Run from the game folder:   python3 tools/check_data.py        exit code 1 when there is an error.
ERROR = the game would break or silently ignore something; WARN = probably a mistake, worth a look.

What it checks:
- every id a node, recipe, the start, places, animals or chapters name exists (nodes, items, recipes, tags "tag:x")
- costs, needs, prices, feed, yields, gifts, steps, barter, seeds and recipe inputs/outputs use known items
  (or coins / energy / water)
- every effect key in the data is one the code reads (g("…"), m("…"), smod …) — otherwise it does nothing
- every "when" condition (golden acorns, perks) uses kinds and counters the game knows (kits/core/conditions.gd)
- a node does not require something from a later chapter
- quiz question ids are unique (packs and knowledge cards)
"""
import json, os, re, sys, glob
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import farm_data

errors, warns = [], []
def err(m): errors.append(m)
def warn(m): warns.append(m)

D = farm_data.load()
N, I, R, meta = D["nodes"], D["items"], D["recipes"], D["meta"]
TAGS = {t for it in I.values() for t in it.get("tags", [])}
SPECIAL = {"coins", "energy", "water", "read"}   # read = questions of reading time (knowledge cards)

def item_ok(k, where):
    if k in SPECIAL or k in I: return
    if k.startswith("tag:") and k[4:] in TAGS: return
    err(f"{where}: unknown item '{k}'")

def items_in(d, where):
    if isinstance(d, dict):
        for k in d: item_ok(k, where)

# --- nodes
for nid, n in N.items():
    for f in ("type", "name", "emoji", "chapter", "slot"):
        if f not in n: err(f"node {nid}: no '{f}'")
    for r in n.get("requires") or []:
        if r not in N: err(f"node {nid}: requires unknown node '{r}'")
        elif int(N[r].get("chapter", 1)) > int(n.get("chapter", 1)): warn(f"node {nid} (chapter {n.get('chapter')}) requires '{r}' from chapter {N[r].get('chapter')}")
    for f in ("replaces", "attach"):
        v = n.get(f)
        for x in (v if isinstance(v, list) else [v] if v else []):
            if x not in N: err(f"node {nid}: {f} unknown node '{x}'")
    for u in n.get("unlocks") or []:
        if u not in N and u not in R: err(f"node {nid}: unlocks unknown node or recipe '{u}'")
    for f in ("cost", "needs", "price", "feed", "yields", "gives", "sells", "seedCost"):
        if isinstance(n.get(f), dict): items_in(n[f], f"node {nid} {f}")
    rw = n.get("reward") or {}
    if rw.get("helper") and rw["helper"] not in N: err(f"node {nid}: reward helper '{rw['helper']}' is no node")
    for i, st in enumerate(n.get("steps") or []):
        items_in(st.get("cost", {}), f"node {nid} step {i + 1} cost"); items_in(st.get("gives", {}), f"node {nid} step {i + 1} gives")
    for k, price in (n.get("barter") or {}).items():
        item_ok(k, f"node {nid} barter"); items_in(price, f"node {nid} barter {k}")
    for k in n.get("discover") or []: item_ok(k, f"node {nid} discover")
    if n.get("seedItem"): item_ok(n["seedItem"], f"node {nid} seedItem")
# --- recipes
for rid, r in R.items():
    if r.get("station") not in N: err(f"recipe {rid}: unknown station '{r.get('station')}'")
    items_in(r.get("inputs", {}), f"recipe {rid} inputs"); items_in(r.get("outputs", {}), f"recipe {rid} outputs")
    for k in r.get("keeps", []): item_ok(k, f"recipe {rid} keeps")
    for x in r.get("requires", []):
        if x not in N: err(f"recipe {rid}: requires unknown node '{x}'")
    if not r.get("outputs"): warn(f"recipe {rid}: makes nothing")
# --- start
st = D["start"]
for x in st.get("unlocked", []):
    if x not in N: err(f"start: unknown node '{x}'")
items_in(st.get("inventory", {}), "start inventory")
for x in st.get("seeds", {}):
    if x not in N: err(f"start seeds: unknown crop '{x}'")
# --- places, animals, chapters (data/farm/)
P = json.load(open(os.path.join(ROOT, "data", "farm", "places.json"), encoding="utf-8"))
names = P["names"]
for par, it in P["interiors"].items():
    if par not in names: err(f"places interiors: unknown place '{par}'")
    if it["built"] not in N: err(f"places interiors {par}: built '{it['built']}' is no node")
    for m in it["members"]:
        if m not in names: err(f"places interiors {par}: unknown corner '{m}'")
for key in ("insideArt", "artChains", "plotChains"):
    for sid, chain in P[key].items():
        if sid not in names: err(f"places {key}: unknown place '{sid}'")
        for x in chain:
            if x not in N and x != sid: warn(f"places {key} {sid}: '{x}' is no node (a picture name only?)")
for sid in P["alwaysOpen"] + list(P["ruins"]) + list(P["pens"]):
    if sid not in names: err(f"places: unknown place '{sid}'")
for b in P["bench"]:
    if b["id"] not in N and b["id"] not in I: err(f"places bench: '{b['id']}' is neither node nor item")
def place_target(t, where):
    if t not in names: err(f"{where}: unknown place '{t}'")
for slot, rule in P["slots"].items():
    if isinstance(rule, str): place_target(rule, f"places slots {slot}")
    else:
        for x, t in rule.get("byId", {}).items():
            place_target(t, f"places slots {slot}")
            if x not in N: warn(f"places slots {slot}: byId '{x}' is no node")
        for t in rule.get("byPrefix", {}).values(): place_target(t, f"places slots {slot}")
        place_target(rule.get("default", P.get("defaultPlace", "field")), f"places slots {slot}")
used_slots = {str(n.get("slot", "")) for i, n in N.items() if not i.startswith("ruins_")}
for s in sorted(used_slots):
    if s and not s.startswith(("gear:", "tool:")) and s not in P["slots"]: warn(f"slot '{s}' has no place rule (its nodes go to '{P.get('defaultPlace', 'field')}')")
A = json.load(open(os.path.join(ROOT, "data", "farm", "animals.json"), encoding="utf-8"))
for x in A["animals"] + A["pets"] + list(A.get("petVoices", {})):
    if x not in N: err(f"animals.json: unknown node '{x}'")
for sid, vs in A.get("voices", {}).items():
    place_target(sid, "animals.json voices")
    for aid in vs.values():
        if aid not in N: err(f"animals.json voices: unknown animal '{aid}'")
C = json.load(open(os.path.join(ROOT, "data", "farm", "chapters.json"), encoding="utf-8"))
for x in C.get("advanceWhenDone", []):
    if x not in N: err(f"chapters.json: unknown node '{x}'")
for c in C.get("list", []):
    if c.get("pet") and c["pet"] not in N: err(f"chapters.json list: unknown pet '{c['pet']}'")
# --- effect keys the code reads
code = ""
for p in glob.glob(os.path.join(ROOT, "game", "**", "*.gd"), recursive=True) + glob.glob(os.path.join(ROOT, "kits", "**", "*.gd"), recursive=True):
    code += open(p, encoding="utf-8").read()
read = set(re.findall(r'\b(?:g|m|smod)\(\s*"([^"]+)"', code)) | set(re.findall(r'\b(?:g|m)\(\s*"([^"]+)"\s*%', code))
dyn = set(re.findall(r'\b(?:g|m)\(\s*"([a-zA-Z_]+[:_])"\s*\+', code)) | set(re.findall(r'\b(?:g|m)\(\s*"([a-zA-Z_]+[:_])%s"', code))
def effect_keys(e):
    for kind in ("set", "add", "mult"):
        for k in (e or {}).get(kind, {}): yield k
srcs = [(f"node {nid}", n.get("effects")) for nid, n in N.items()] + [(f"gift card {g['id']}", g.get("effects")) for g in meta.get("giftCards", {}).get("pool", [])]
unknown = {}
for where, e in srcs:
    for k in effect_keys(e):
        if k in read or any(k.startswith(p) for p in dyn): continue
        unknown.setdefault(k, []).append(where)
for k, ws in sorted(unknown.items()):
    warn(f"effect key '{k}' is not read by name in the code ({', '.join(ws[:3])}{' …' if len(ws) > 3 else ''}); check that it does something")
for g in meta.get("giftCards", {}).get("pool", []):
    for k in (g.get("effects") or {}).get("produces", {}): item_ok(k, f"gift card {g['id']} produces")
for nid, n in N.items():
    for k in (n.get("effects") or {}).get("produces", {}): item_ok(k, f"node {nid} produces")
# --- conditions
KINDS = {"unlocked", "done", "has", "seen", "season"}
COUNTERS = {"sidequests", "seasons", "weeds", "cards", "harvests", "rest_quick", "medals", "arith_level", "sold_kinds", "friends", "chapter", "step"}
NAMED = {"luck"}
def cond_ok(w, where):
    for part in str(w).split("&"):
        p = part.strip()
        m = re.match(r"^(\w+)\s*(>=|<=|==|>|<)\s*[\d.]+$", p)
        if m:
            if m.group(1) not in COUNTERS: err(f"{where}: unknown counter '{m.group(1)}' in '{w}'")
            continue
        if ":" in p:
            k, a = p.split(":", 1)
            if k not in KINDS: err(f"{where}: unknown kind '{k}' in '{w}'")
            elif k in ("unlocked", "done") and a not in N: err(f"{where}: unknown node '{a}' in '{w}'")
            continue
        if p not in NAMED: err(f"{where}: cannot read condition '{w}'")
for a in meta.get("acorns", {}).get("list", []): cond_ok(a.get("when", ""), f"acorn {a['id']}")
for p in meta.get("perks", {}).get("list", []):
    if "when" in p: cond_ok(p["when"], f"perk {p['id']}")
# --- quiz ids
seen = {}
for p in sorted(glob.glob(os.path.join(ROOT, "data", "quiz_packs", "*.json"))):
    for q in json.load(open(p, encoding="utf-8")).get("questions", []):
        if "id" in q:
            if q["id"] in seen: err(f"quiz: id {q['id']} twice ({seen[q['id']]} and {os.path.basename(p)})")
            seen[q["id"]] = os.path.basename(p)
        else: warn(f"quiz {os.path.basename(p)}: a question without id (run tools/quiz_ids.py)")
for nid, n in N.items():
    for q in n.get("questions", []):
        if "id" in q:
            if q["id"] in seen: err(f"quiz: id {q['id']} twice ({seen[q['id']]} and card {nid})")
            seen[q["id"]] = "card " + nid
        else: warn(f"card {nid}: a question without id (run tools/quiz_ids.py)")

for w in warns: print("WARN ", w)
for e in errors: print("ERROR", e)
print(f"data check: {len(N)} nodes, {len(I)} items, {len(R)} recipes, {len(seen)} quiz ids — {len(errors)} errors, {len(warns)} warnings")
sys.exit(1 if errors else 0)
