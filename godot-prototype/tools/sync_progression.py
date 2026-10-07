#!/usr/bin/env python3
"""Copies data/farm-progression.json to ../progression/ and into the explorer's built-in data, so the explorer
(progression/progression-explorer.html) shows the same numbers as the game. Run after changing the progression data:
    python3 tools/sync_progression.py      (from the godot-prototype folder)"""
import json, os, re, shutil

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.join(HERE, "..", "data", "farm-progression.json")
PROG = os.path.join(HERE, "..", "..", "progression")
HTML = os.path.join(PROG, "progression-explorer.html")

text = open(DATA, encoding="utf-8").read()
json.loads(text)                                   # stop here if the data is not valid JSON
shutil.copyfile(DATA, os.path.join(PROG, "farm-progression.json"))
html = open(HTML, encoding="utf-8").read()
pat = re.compile(r'(<script id="builtin-data" type="application/json">)(.*?)(</script>)', re.S)
if not pat.search(html): raise SystemExit("builtin-data block not found in the explorer")
html = pat.sub(lambda m: m.group(1) + text.rstrip("\n") + m.group(3), html, count=1)
open(HTML, "w", encoding="utf-8").write(html)
print("synced progression/farm-progression.json and the explorer's built-in data")
