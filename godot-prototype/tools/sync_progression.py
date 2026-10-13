#!/usr/bin/env python3
"""Writes the whole farm data (data/farm/, see tools/farmdata.py) as ONE file, ../progression/farm-progression.json, and into the
explorer's built-in data, together with the bot's pacing report, so the progression explorer (progression/progression-explorer.html)
shows the same numbers as the game. Run after changing the progression data:
    python3 tools/sync_progression.py                       (from the godot-prototype folder)
    python3 tools/sync_progression.py --report a.json b.json   also merges the runs of these bot reports (tests/bot.gd --report=FILE)
                                                              into ../progression/pacing-report.json first (tools/update_explorer.sh does this)"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import farmdata
PROG = os.path.join(HERE, "..", "..", "progression")
HTML = os.path.join(PROG, "progression-explorer.html")
REPORT = os.path.join(PROG, "pacing-report.json")

# the bot's reports: merged runs, written next to the data
if "--report" in sys.argv:
    files = sys.argv[sys.argv.index("--report") + 1:]
    merged = None
    for f in files:
        r = json.load(open(f, encoding="utf-8"))
        if merged is None: merged = r
        else: merged["runs"] += r["runs"]
    if merged: open(REPORT, "w", encoding="utf-8").write(json.dumps(merged, ensure_ascii=False, indent=1) + "\n")

text = farmdata.merged_text(farmdata.load())
json.loads(text)                                   # stop here if it is not valid JSON
open(os.path.join(PROG, "farm-progression.json"), "w", encoding="utf-8").write(text)
html = open(HTML, encoding="utf-8").read()
pat = re.compile(r'(<script id="builtin-data" type="application/json">)(.*?)(</script>)', re.S)
if not pat.search(html): raise SystemExit("builtin-data block not found in the explorer")
html = pat.sub(lambda m: m.group(1) + text.rstrip("\n") + m.group(3), html, count=1)
if os.path.exists(REPORT):
    rep = json.dumps(json.load(open(REPORT, encoding="utf-8")), ensure_ascii=False)
    pat2 = re.compile(r'(<script id="bot-report" type="application/json">)(.*?)(</script>)', re.S)
    if not pat2.search(html): raise SystemExit("bot-report block not found in the explorer")
    html = pat2.sub(lambda m: m.group(1) + rep.replace("</", "<\\/") + m.group(3), html, count=1)
open(HTML, "w", encoding="utf-8").write(html)
print("synced progression/farm-progression.json and the explorer's built-in data" + (" and the bot's pacing report" if os.path.exists(REPORT) else ""))
