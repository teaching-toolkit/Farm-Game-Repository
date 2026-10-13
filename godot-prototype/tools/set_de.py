#!/usr/bin/env python3
"""Sets German texts: python3 tools/set_de.py file.json   (file: {"nodes/x/name": "…"}) for data-de.json, or imported: from set_de import set_de.
Clears the "stale" mark of what it sets. German with ss, never ß."""
import json, os, sys

def set_de(mapping, which="data-de.json"):
    here = os.path.dirname(os.path.abspath(__file__))
    p = os.path.join(os.path.dirname(here), "data", "i18n", which)
    d = json.load(open(p, encoding="utf-8"))
    for k, v in mapping.items():
        if "ß" in v: raise SystemExit(f"ß in {k}")
        if which == "data-de.json":
            if k not in d: raise SystemExit(f"unknown key {k} (run tools/i18n.py first)")
            d[k]["de"] = v
            d[k].pop("stale", None)
        else:
            if k not in d: raise SystemExit(f"unknown key {k} (run tools/i18n.py first)")
            d[k] = v
    json.dump(d, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)

if __name__ == "__main__":
    set_de(json.load(open(sys.argv[1], encoding="utf-8")), sys.argv[2] if len(sys.argv) > 2 else "data-de.json")
