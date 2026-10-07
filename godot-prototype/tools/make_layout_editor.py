#!/usr/bin/env python3
"""Builds tools/layout-editor.html: a page where you drag and resize everything on the farm map
(and the corners inside the house, barn and workshop).

    python3 tools/make_layout_editor.py                 # writes tools/layout-editor.html (open it in any browser)
    python3 tools/make_layout_editor.py page-body.html  # also writes the page body for publishing on claude.ai

The page starts from data/map_layout.json (what the game uses now) and carries small copies of the pictures,
so it works on its own, also offline. Its result is a new map_layout.json: copy the text, or download it, and
put it into data/ — or send it to Claude. Run this again after adding pictures or after the layout changed.
"""
import base64
import io
import json
import os
import re
import sys

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
ASSETS = os.path.join(ROOT, "assets")

layout = json.load(open(os.path.join(ROOT, "data", "map_layout.json"), encoding="utf-8"))
spots_src = open(os.path.join(ROOT, "scripts", "spots.gd"), encoding="utf-8").read()


def const_block(name):
    m = re.search(r"const " + name + r" := \{(.*?)\n\}", spots_src, re.S)
    return m.group(1) if m else ""


titles = {m.group(1): (m.group(2), m.group(3)) for m in re.finditer(r'"(\w+)": \["([^"]+)", "([^"]+)"\]', const_block("SPOTS"))}
chains = {m.group(1): re.findall(r'"(\w+)"', m.group(2)) for m in re.finditer(r'"(\w+)": \[([^\]]*)\]', const_block("ART_CHAINS"))}
plot_chains = {m.group(1): re.findall(r'"(\w+)"', m.group(2)) for m in re.finditer(r'"(\w+)": \[([^\]]*)\]', const_block("PLOT_CHAINS"))}
hotspot_art = {m.group(1): re.findall(r'"(\w+)"', m.group(2)) for m in re.finditer(r'"(\w+)": \[([^\]]*)\]', const_block("HOTSPOT_ART"))}
interiors = {}
for m in re.finditer(r'"(\w+)": \{"built": "(\w+)", "art": "(\w+)", "members": \[([^\]]*)\]\}', const_block("INTERIORS")):
    interiors[m.group(1)] = {"art": m.group(3), "members": re.findall(r'"(\w+)"', m.group(4))}
pens = {m.group(1): m.group(2) for m in re.finditer(r'"(\w+)": \{"fence": "(\w*)"', const_block("PENS"))}
always = re.search(r"ALWAYS_OPEN := \[([^\]]*)\]", spots_src)
always = re.findall(r'"(\w+)"', always.group(1)) if always else []
data = json.load(open(os.path.join(ROOT, "data", "farm-progression.json"), encoding="utf-8"))
start = set(data["start"].get("unlocked", []))

pics = {}


def exists(name):
    return os.path.exists(os.path.join(ASSETS, name + ".png"))


def add_pic(name, max_side=256):
    """Small WebP copy of assets/<name>.png as a data URI (keeps the page small); returns the name or None."""
    if name in pics:
        return name
    path = os.path.join(ASSETS, name + ".png")
    if not os.path.exists(path):
        return None
    im = Image.open(path).convert("RGBA")
    im.thumbnail((max_side, max_side), Image.LANCZOS)
    buf = io.BytesIO()
    im.save(buf, "WEBP", quality=84, method=3)
    pics[name] = "data:image/webp;base64," + base64.b64encode(buf.getvalue()).decode()
    return name


places = {}
for sid, p in layout["places"].items():
    title, emoji = titles.get(sid, (sid.capitalize(), "❔"))
    chain = chains.get(sid, [])
    kind = p.get("k", "obj")
    if kind == "plot":
        start_pic = add_pic("plots/pond_wild", 320) if sid == "pond" else None
        final_pic = None if sid in pens else add_pic("plots/" + sid, 320)
        open_at_start = sid in always or any(n in start for n in plot_chains.get(sid, []))
    else:
        started = [n for n in chain if n in start]
        start_pic = next((add_pic("map/" + n) for n in reversed(started) if exists("map/" + n)), None) or add_pic("map/" + sid)
        final_pic = next((add_pic("map/" + n) for n in reversed(chain) if exists("map/" + n)), None) or add_pic("map/" + sid)
        open_at_start = sid in always or bool(started) or (not chain and exists("map/" + sid) and sid in ("forest", "market", "board", "field"))
    if sid == "home":
        title = "House"
        add_pic("plots/home", 320)
    places[sid] = {"title": title, "emoji": emoji, "startPic": start_pic, "finalPic": final_pic, "openAtStart": open_at_start}
    if sid in pens:
        places[sid]["pen"] = pens[sid]

addon_pics = {}
for pid, lst in layout.get("addons", {}).items():
    for a in lst:
        keys = [a.get("pic", a["id"]), a["id"]]
        found = None
        for folder in ("addons", "map"):
            for k in keys:
                if exists(folder + "/" + k):
                    found = add_pic(folder + "/" + k)
                    break
            if found:
                break
        addon_pics[a["id"]] = found

corners = {}
for b, info in interiors.items():
    add_pic("interiors/" + info["art"], 900)
    mem = {}
    for m in info["members"]:
        t, e = titles.get(m, (m, "❔"))
        arts = hotspot_art.get(m, [])
        def first(ids):
            for n in ids:
                for folder in ("interior", "map"):
                    if exists(folder + "/" + n):
                        return add_pic(folder + "/" + n)
            return None
        mem[m] = {"title": t, "emoji": e, "startPic": first([n for n in arts if n in start]), "finalPic": first(list(reversed(arts)))}
    corners[b] = {"art": info["art"], "members": mem}

deco_kinds = ["tree_pine", "tree_oak", "bush", "stone", "weeds", "fence_stick", "signpost"]
for name in ["map/scarecrow_1", "deco/soil_heap", "deco/sprout_patch", "deco/overgrown_patch"] + ["deco/" + k for k in deco_kinds] + ["deco/" + d["pic"] for d in layout.get("deco", [])]:
    add_pic(name)
for t in ["tiles/grass", "tiles/path"]:
    add_pic(t, 256)
# fence sides round the fields and borders for the gaps between patches (one side each; mirrored for the other sides)
for k in ["stick_broken", "stick_fence", "wattle_fence", "wattle_broken", "picket_fence", "picket_broken", "stone_wall", "stone_broken", "hedge_row"]:
    add_pic("fences/" + k)
for k in ["stick", "stick_broken", "stone", "stone_broken", "log", "wicker", "net", "channel", "drip"]:
    add_pic("edging/" + k)

tpl = open(os.path.join(HERE, "layout_editor_template.html"), encoding="utf-8").read()
body = (tpl.replace("__LAYOUT__", json.dumps(layout))
           .replace("__PICS__", json.dumps(pics))
           .replace("__PLACES__", json.dumps(places, ensure_ascii=False))
           .replace("__ADDONS__", json.dumps(addon_pics))
           .replace("__CORNERS__", json.dumps(corners, ensure_ascii=False))
           .replace("__DECO__", json.dumps(deco_kinds)))
full = ("<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\">"
        "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1,viewport-fit=cover\">"
        "<style>body{margin:0}img{max-width:100%}[hidden]{display:none!important}</style></head><body>"
        + body + "</body></html>")
out = os.path.join(HERE, "layout-editor.html")
open(out, "w", encoding="utf-8").write(full)
print("wrote", out, round(len(full) / 1e6, 2), "MB,", len(pics), "pictures")
if len(sys.argv) > 1:
    open(sys.argv[1], "w", encoding="utf-8").write(body)
    print("wrote page body for publishing:", sys.argv[1])
