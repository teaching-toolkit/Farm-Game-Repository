#!/usr/bin/env python3
"""The farm's progression data, split into files people can read (phase 2, R8, 12 Oct 2026). The game (game.gd,
_load_farm_data) and every tool put the pieces back together into the one structure they always used:
    {"meta": …, "chapters": […], "start": …, "items": …, "nodes": …, "recipes": …}

    data/farm/rules/<part>.json      the "meta" blocks, one file per part of the game (fields, seasons, crafting …)
    data/farm/chapters.json          "list": the chapters (names, homes, themes, pets) + the chapter rule (R2)
    data/farm/start.json             what a new farm starts with
    data/farm/items.json             every item, one per line
    data/farm/recipes.json           every recipe, one per line
    data/farm/nodes/ch1.json …       every node (building, tool, crop, card …) by its chapter, one per line
    data/farm/nodes/order.json       the order the game goes through the nodes (a new node not listed comes last)

Use from other tools:   import farm_data;  D = farm_data.load();  …;  farm_data.save(D)
Run on its own to check that the files load:   python3 tools/farm_data.py
"""
import json, os, glob

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FARM = os.path.join(ROOT, "data", "farm")
RULE_PARTS = {   # file -> meta blocks in it
    "general": ["title", "version", "updated", "status", "units", "pacing", "targets", "rules", "numbers", "note_on_numbers", "flex"],
    "fields": ["weeds", "pests", "stones", "rotation", "yield", "water"],
    "seasons": ["seasons", "freshness"],
    "crafting": ["fuel", "polish", "practice", "carry", "building"],
    "animals": ["muck"],
    "knowledge": ["knowledge", "quiz"],
    "needs": ["rest"],
    "trade": ["market", "pricing"],
    "rewards": ["luck", "giftCards", "jobs", "acorns", "luckFinds", "perks", "postcards"],
}

# the order of the rule blocks in the one-file view (as the data had it before the split)
META_ORDER = ["title", "version", "updated", "status", "units", "pacing", "weeds", "targets", "rules", "numbers", "rest", "quiz", "knowledge", "seasons", "freshness", "water", "pests", "stones", "fuel", "muck", "rotation", "polish", "luck", "giftCards", "jobs", "practice", "acorns", "luckFinds", "note_on_numbers", "yield", "building", "market", "pricing", "perks", "postcards", "carry", "flex"]

def _read(path):
    return json.load(open(path, encoding="utf-8"))

def load():
    meta = {}
    for part in RULE_PARTS:
        p = os.path.join(FARM, "rules", part + ".json")
        if os.path.exists(p): meta.update(_read(p))
    for p in sorted(glob.glob(os.path.join(FARM, "rules", "*.json"))):      # a new rules file nobody listed yet
        if os.path.basename(p)[:-5] not in RULE_PARTS: meta.update(_read(p))
    by_id = {}
    files = sorted(glob.glob(os.path.join(FARM, "nodes", "ch*.json")), key=lambda p: int(os.path.basename(p)[2:-5]))
    for p in files: by_id.update(_read(p)["nodes"])
    order = _read(os.path.join(FARM, "nodes", "order.json"))["order"] if os.path.exists(os.path.join(FARM, "nodes", "order.json")) else []
    nodes = {k: by_id[k] for k in order if k in by_id}
    for k in by_id:
        if k not in nodes: nodes[k] = by_id[k]
    meta = {**{k: meta[k] for k in META_ORDER if k in meta}, **{k: v for k, v in meta.items() if k not in META_ORDER}}
    return {"meta": meta, "chapters": _read(os.path.join(FARM, "chapters.json")).get("list", []),
            "start": _read(os.path.join(FARM, "start.json"))["start"],
            "items": _read(os.path.join(FARM, "items.json"))["items"], "nodes": nodes,
            "recipes": _read(os.path.join(FARM, "recipes.json"))["recipes"]}

def _lines(key, d, note=None):
    rows = [f'  {json.dumps(k, ensure_ascii=False)}: {json.dumps(v, ensure_ascii=False)}' for k, v in d.items()]
    head = f'{{\n  "note": {json.dumps(note, ensure_ascii=False)},\n' if note else "{\n"
    return head + f' {json.dumps(key)}: {{\n' + ",\n".join(rows) + "\n }\n}\n"

def _write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, "w", encoding="utf-8").write(text)

def save(D):
    left = dict(D["meta"])
    for part, keys in RULE_PARTS.items():
        block = {k: left.pop(k) for k in keys if k in left}
        _write(os.path.join(FARM, "rules", part + ".json"), json.dumps(block, ensure_ascii=False, indent=2) + "\n")
    if left:   # meta blocks not sorted into a part yet
        gen = _read(os.path.join(FARM, "rules", "general.json")); gen.update(left)
        _write(os.path.join(FARM, "rules", "general.json"), json.dumps(gen, ensure_ascii=False, indent=2) + "\n")
    chp = os.path.join(FARM, "chapters.json")
    ch = _read(chp) if os.path.exists(chp) else {}
    ch["list"] = D["chapters"]
    _write(chp, json.dumps(ch, ensure_ascii=False, indent=1) + "\n")
    _write(os.path.join(FARM, "start.json"), json.dumps({"start": D["start"]}, ensure_ascii=False, indent=2) + "\n")
    _write(os.path.join(FARM, "items.json"), _lines("items", D["items"], "Every item, one per line (tools/farm_data.py)."))
    _write(os.path.join(FARM, "recipes.json"), _lines("recipes", D["recipes"], "Every recipe, one per line (tools/farm_data.py)."))
    by_ch = {}
    for k, n in D["nodes"].items(): by_ch.setdefault(int(n.get("chapter", 1)), {})[k] = n
    for c, nodes in sorted(by_ch.items()):
        _write(os.path.join(FARM, "nodes", f"ch{c}.json"), _lines("nodes", nodes, f"The nodes of chapter {c}, one per line (tools/farm_data.py). A node's \"chapter\" decides its file."))
    _write(os.path.join(FARM, "nodes", "order.json"), json.dumps({"note": "The order the game goes through the nodes (quest book, unlocking). A new node not listed here comes last. tools/farm_data.py keeps it up to date.", "order": list(D["nodes"].keys())}, ensure_ascii=False, indent=0) + "\n")

def dumps_merged(d):
    """All the data in one file, one item / node / recipe per line (for the explorer: progression/farm-progression.json)."""
    parts = []
    for k, v in d.items():
        if k == "chapters":
            rows = ["    " + json.dumps(c, ensure_ascii=False) for c in v]
            parts.append(f'  {json.dumps(k)}: [\n' + ",\n".join(rows) + "\n  ]")
        elif k in ("items", "nodes", "recipes"):
            rows = [f'    {json.dumps(ik, ensure_ascii=False)}: {json.dumps(iv, ensure_ascii=False)}' for ik, iv in v.items()]
            parts.append(f'  {json.dumps(k)}: {{\n' + ",\n".join(rows) + "\n  }")
        else:
            body = json.dumps(v, ensure_ascii=False, indent=2).replace("\n", "\n  ")
            parts.append(f'  {json.dumps(k)}: {body}')
    return "{\n" + ",\n".join(parts) + "\n}\n"

if __name__ == "__main__":
    D = load()
    print("farm data: %d items, %d nodes, %d recipes, %d rule blocks, %d chapters" % (len(D["items"]), len(D["nodes"]), len(D["recipes"]), len(D["meta"]), len(D["chapters"])))
