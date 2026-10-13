#!/usr/bin/env python3
"""Adds entries (one per line, like the other entries) to the end of a data file of the form {"id": {...}, ...}.
Used by the slices that add items, recipes and nodes:  from add_data import add;  add("data/farm/items.json", {"axle": {...}})
An id that already exists is replaced in place (so a slice can be run again)."""
import json, os, re

def add(path, entries):
    here = os.path.dirname(os.path.abspath(__file__))
    path = path if os.path.isabs(path) else os.path.join(os.path.dirname(here), path)
    text = open(path, encoding="utf-8").read()
    lines = text.rstrip("\n").split("\n")
    assert lines[0].strip() == "{" and lines[-1].strip() == "}", path
    body = lines[1:-1]
    for k, v in entries.items():
        line = "  " + json.dumps(k, ensure_ascii=False) + ": " + json.dumps(v, ensure_ascii=False)
        hit = [i for i, l in enumerate(body) if l.startswith("  " + json.dumps(k, ensure_ascii=False) + ": ")]
        if hit:
            i = hit[0]
            comma = "," if body[i].rstrip().endswith(",") else ""
            body[i] = line + comma
        else:
            if body and not body[-1].rstrip().endswith(","): body[-1] = body[-1].rstrip() + ","
            body.append(line)
    open(path, "w", encoding="utf-8").write("{\n" + "\n".join(body) + "\n}\n")
