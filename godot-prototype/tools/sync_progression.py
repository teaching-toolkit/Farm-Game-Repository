#!/usr/bin/env python3
"""Puts the progression data (data/farm/, see tools/farm_data.py) together into ../progression/farm-progression.json and
into the explorer's built-in data, so the explorer (progression/progression-explorer.html) shows the same numbers as the
game. Run after changing the progression data:
    python3 tools/sync_progression.py      (from the godot-prototype folder)"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import farm_data
PROG = os.path.join(HERE, "..", "..", "progression")
HTML = os.path.join(PROG, "progression-explorer.html")

text = farm_data.dumps_merged(farm_data.load())
json.loads(text)                                   # stop here if the data is not valid JSON
open(os.path.join(PROG, "farm-progression.json"), "w", encoding="utf-8").write(text)
html = open(HTML, encoding="utf-8").read()
pat = re.compile(r'(<script id="builtin-data" type="application/json">)(.*?)(</script>)', re.S)
if not pat.search(html): raise SystemExit("builtin-data block not found in the explorer")
html = pat.sub(lambda m: m.group(1) + text.rstrip("\n") + m.group(3), html, count=1)
REPORT = os.path.join(PROG, "pacing-report.json")
if os.path.exists(REPORT):          # the bot's report from the real game (Update explorer.command)
    rep = open(REPORT, encoding="utf-8").read()
    json.loads(rep)
    pat2 = re.compile(r'(<script id="pacing-report" type="application/json">)(.*?)(</script>)', re.S)
    html = pat2.sub(lambda m: m.group(1) + rep.strip() + m.group(3), html, count=1)
open(HTML, "w", encoding="utf-8").write(html)
print("synced progression/farm-progression.json, the explorer's built-in data" + (" and the pacing report" if os.path.exists(REPORT) else ""))
