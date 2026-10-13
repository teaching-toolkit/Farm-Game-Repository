"""The farm's data, split into files (data/farm/), loaded and written the way the game does.

    import farmdata
    D = farmdata.load()               # the same structure the game builds: meta, chapters, start, items, nodes, recipes
    D, where = farmdata.load_with_where()   # where[node_id] = the file a node lives in (for tools that change nodes)
    farmdata.save_nodes(D, where)     # writes the nodes back into their files (same layout: one node per line)

Layout of data/farm/ (the game's loader, kits/core/data.gd, reads the same files in the same order):
    chapters.json  start.json  items.json  recipes.json
    nodes/NN-name.json     the nodes; files are read in name order and the nodes keep their order, so what comes first in the
                           first file comes first in the game (many lists follow node order). Each file is a thematic slice.
    rules/NN-name.json     the numbers and texts of the systems (the old "meta"); the top-level keys of all files are merged
Items, recipes, nodes and chapters are written one entry per line, so a change is one line in a diff.
"""
import json, os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
DIR = os.path.join(ROOT, "data", "farm")

def _read(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)

def _files(sub):
    d = os.path.join(DIR, sub)
    return [os.path.join(d, f) for f in sorted(os.listdir(d)) if f.endswith(".json")]

def load_with_where(directory=None):
    base = directory or DIR
    meta, nodes, where = {}, {}, {}
    for path in sorted(os.path.join(base, "rules", f) for f in os.listdir(os.path.join(base, "rules")) if f.endswith(".json")):
        for k, v in _read(path).items():
            if k in meta: raise SystemExit(f"rules: key {k} is in two files ({path})")
            meta[k] = v
    for path in sorted(os.path.join(base, "nodes", f) for f in os.listdir(os.path.join(base, "nodes")) if f.endswith(".json")):
        for k, v in _read(path).items():
            if k in nodes: raise SystemExit(f"nodes: {k} is in two files ({where[k]} and {path})")
            nodes[k] = v
            where[k] = os.path.relpath(path, base)
    D = {"meta": meta, "chapters": _read(os.path.join(base, "chapters.json")), "start": _read(os.path.join(base, "start.json")),
         "items": _read(os.path.join(base, "items.json")), "nodes": nodes, "recipes": _read(os.path.join(base, "recipes.json"))}
    return D, where

def load(directory=None):
    return load_with_where(directory)[0]

def entries(d):
    """{"id": {...},\n ...} with one entry per line."""
    rows = [f'  {json.dumps(k, ensure_ascii=False)}: {json.dumps(v, ensure_ascii=False)}' for k, v in d.items()]
    return "{\n" + ",\n".join(rows) + "\n}\n"

def rows_list(lst):
    return "[\n" + ",\n".join("  " + json.dumps(c, ensure_ascii=False) for c in lst) + "\n]\n"

def pretty(d):
    return json.dumps(d, ensure_ascii=False, indent=2) + "\n"

def save_nodes(D, where, only=None):
    """Writes the nodes back into the files they came from (all of them, or only those in `only`, a set of relative paths)."""
    by_file = {}
    for k, v in D["nodes"].items():
        by_file.setdefault(where[k], {})[k] = v
    for rel, d in by_file.items():
        if only is not None and rel not in only: continue
        with open(os.path.join(DIR, rel), "w", encoding="utf-8") as f:
            f.write(entries(d))

def merged_text(D):
    """The whole data as ONE json text (the layout the old data/farm-progression.json had): for the progression explorer."""
    parts = []
    for k, v in D.items():
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
