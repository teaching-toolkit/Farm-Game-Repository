#!/usr/bin/env python3
"""Writes the whole farm data (data/farm/, see tools/farmdata.py) as ONE file, ../progression/farm-progression.json, and into the
explorer's built-in data, so the progression explorer (progression/progression-explorer.html) shows the same numbers as the game.
Run after changing the progression data:
    python3 tools/sync_progression.py      (from the godot-prototype folder)"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import farmdata
PROG = os.path.join(HERE, "..", "..", "progression")
HTML = os.path.join(PROG, "progression-explorer.html")

text = farmdata.merged_text(farmdata.load())
json.loads(text)                                   # stop here if it is not valid JSON
open(os.path.join(PROG, "farm-progression.json"), "w", encoding="utf-8").write(text)
html = open(HTML, encoding="utf-8").read()
pat = re.compile(r'(<script id="builtin-data" type="application/json">)(.*?)(</script>)', re.S)
if not pat.search(html): raise SystemExit("builtin-data block not found in the explorer")
html = pat.sub(lambda m: m.group(1) + text.rstrip("\n") + m.group(3), html, count=1)
open(HTML, "w", encoding="utf-8").write(html)
print("synced progression/farm-progression.json and the explorer's built-in data")
