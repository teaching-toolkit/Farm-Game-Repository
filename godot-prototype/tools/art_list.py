#!/usr/bin/env python3
"""Writes ART_LIST.csv (into ../art-inbox/): every picture the game can use, in the order worth drawing them, and whether it exists yet.

    python3 tools/art_list.py

Columns: priority, chapter, file, size, what, prompt (to paste after the style prompt), status.
The game never needs any of these — a missing picture just shows the emoji.
"""
import csv
import json
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = json.load(open(os.path.join(ROOT, "data", "farm-progression.json"), encoding="utf-8"))
NODES = DATA["nodes"]

STYLE = ("Bright, friendly mobile-game cartoon, thick rounded dark outlines, flat colours with simple cel shading, "
         "chunky cute proportions, three-quarter top-down view (isometric, like Hay Day), standing on a flat diamond-shaped footprint "
         "about twice as wide as deep, small soft shadow, isolated on plain white background, no text.")

# places on the map and their upgrade chains, read from scripts/spots.gd (ART_CHAINS)
spots_src = open(os.path.join(ROOT, "scripts", "spots.gd"), encoding="utf-8").read()
chains_src = spots_src.split("const ART_CHAINS")[1].split("}")[0]
chains = {m.group(1): re.findall(r'"(\w+)"', m.group(2)) for m in re.finditer(r'"(\w+)": \[([^\]]*)\]', chains_src)}

rows = []


def add(prio, ch, file, size, what, prompt):
    path = os.path.join(ROOT, "assets", file)
    rows.append([prio, ch, "assets/" + file, size, what, prompt, "done" if os.path.exists(path) else "missing"])


# ground and decoration first: they make the whole map look finished
add(1, 1, "tiles/grass.png", "512x512 seamless", "Grass ground", "seamless tileable short meadow grass seen from above, no objects")
add(1, 1, "tiles/path.png", "512x512 seamless", "Village road", "seamless tileable sandy dirt path seen from above")
# the field: diamond patches seen at an angle (weeds and stones sit on top of them)
add(1, 1, "deco/soil_heap.png", "512 max", "Field patch: empty or growing", "diamond-shaped raised patch of freshly dug brown soil with a few furrows")
add(1, 1, "deco/sprout.png", "256 max", "One young plant (one per seed planted)", "a tiny young green sprout with two round seed leaves")
add(1, 1, "tiles/overgrown.png", "256x256 seamless", "Wild growth on patches not cleared yet (drawn as a diamond)", "seamless tileable tangle of weeds and wild grass seen from above")
add(1, 1, "deco/weeds.png", "256 max", "One weed on a patch (one per weed)", "small clump of weeds")
add(1, 1, "deco/stone.png", "256 max", "One stone on a patch (one per stone)", "single grey field stone")
add(1, 1, "deco/rubble.png", "256 max", "Rocks on a patch not cleared yet, rubble in ruins", "small pile of grey fieldstone rubble")
add(1, 1, "deco/stump.png", "256 max", "Stump on a patch not cleared yet", "old tree stump with roots, cut flat on top")
add(1, 1, "deco/reeds.png", "256 max", "Reeds (marsh field, wild pond)", "small clump of reeds and cattails")
add(1, 1, "deco/planks.png", "256 max", "Planks lying in wooden ruins", "three old charred planks lying crossed on the ground")
add(1, 1, "deco/mystery_sign.png", "256 max", "Sign shown for a place you can't reach yet", "weathered wooden signpost with a painted question mark")
add(1, 1, "ruins/stone_wall.png", "512 max", "Ruined stone wall side (locked stone buildings)", "ruined low fieldstone wall segment, one straight side of an isometric diamond, lower left to upper right")
add(1, 1, "ruins/wood_wall.png", "512 max", "Ruined wooden wall side (locked wooden buildings)", "ruined burnt plank wall segment, one straight side of an isometric diamond, lower left to upper right")
add(1, 1, "map/well_1.png", "256 max", "Old bucket (water at the start)", "old dented tin bucket with a wire handle")
for i in range(1, 10):
    add(1, 1, f"ground/earth_{i}.png", "512 max", "Bare earth tile (yard, pens, ruins, lots)", "flat isometric diamond of beige trodden earth with soft grassy edges (#b1d876), no slab")
    add(2, 1, f"deco/weed_{i}.png", "256 max", "One weed (variants on the patches)", "one small weed")
    add(2, 1, f"deco/debris_{i}.png", "256 max", "Stones, twigs, roots on half-cleared patches", "small stone, twig or clod")
    add(3, 1, f"deco/grass_{i}.png", "256 max", "Little things growing in the grass", "grass tuft, daisies, clover, moss")
for i in range(1, 5):
    add(2, 1, f"deco/post_{i}.png", "256 max", "Lone old fence post (remnants)", "one old weathered fence post")
for f in ["stick_broken_2", "stick_broken_3"]:
    add(2, 1, f"fences/{f}.png", "512 max", "Broken fence side (variant)", "broken stick fence, one straight side of an isometric diamond")
add(1, 1, "map/workbench_empty.png", "512 max", "Empty workbench (what is made lies on it)", "rustic wooden workbench with an empty top")
for t in ["rope", "stone_hammer", "wooden_shovel", "stone_axe", "flint_knife", "wooden_rake", "hand_saw", "iron_hammer"]:
    add(2, 1, f"tools/{t}.png", "256 max", "On the workbench / on the workshop wall", t.replace("_", " ") + " lying on its side")
for u in ["clock_face", "clock_hour", "clock_minute"]:
    add(1, 1, f"ui/{u}.png", "512 max", "Time Quiz button (old clock)", "antique clock face without hands / one clock hand pointing up")
for t in ["grass_2", "grass_3", "overgrown_2", "overgrown_3"]:
    add(2, 1, f"tiles/{t}.png", "512x512 seamless", "Ground variety", t.replace("_", " ") + " seen from above, seamless")
add(1, 1, "plots/pond_wild.png", "512 max", "Wild overgrown pond (before it is dug out)", "small wild pond lying flat: murky water, reeds, duckweed, lily pads, muddy banks")
add(1, 1, "deco/signpost.png", "256 max", "Field signpost (Home Field)", "wooden signpost with a blank sign")
add(1, 1, "map/_lot.png", "512 max", "Empty building lot", "empty diamond-shaped plot of grass with a low wooden fence and a small blank sign")
add(1, 1, "deco/tree_pine.png", "512 max", "Forest tree", "tall pine tree")
add(1, 1, "deco/tree_oak.png", "512 max", "Forest tree", "round leafy oak tree")
add(1, 1, "deco/bush.png", "256 max", "Bush", "small round green bush")
add(2, 1, "deco/fence_stick.png", "256 max", "Stick fence piece", "short piece of rustic stick fence")
# square patches, still used for the orchard and greenhouse sheets
add(4, 2, "tiles/soil.png", "256x256", "Orchard/greenhouse patch: empty", "square patch of freshly dug brown soil seen from above")
add(4, 2, "tiles/soil_sprouts.png", "256x256", "Orchard/greenhouse patch: growing", "square patch of dark soil with rows of tiny green sprouts seen from above")
add(4, 2, "tiles/overgrown.png", "256x256", "Orchard/greenhouse patch: overgrown", "square patch of ground overgrown with weeds seen from above")
SPOT_ART = {  # places without an upgrade chain get one picture named after the place
    "forest": (1, 1, "Forest edge (gathering)", "edge of a forest, cluster of trees with a small path leading in"),
    "lumber": (2, 1, "Woodlot clearing (before the woodlot is built)", "small forest clearing with a tree stump, an axe and a few logs"),
    "market": (1, 1, "Market stall (seed merchant)", "small village market stall with a striped awning and sacks of seeds"),
    "board": (1, 1, "Notice board (jobs, favours)", "wooden notice board on two posts with blank pinned papers"),
    "bookcart": (2, 1, "Book cart", "wooden hand cart full of colourful books"),
    "pets": (2, 1, "Pet corner", "small wooden bunny hutch with a straw roof"),
    "cows": (3, 2, "Cow pasture", "small cow pasture with a wooden fence, a trough and a cow"),
    "pond": (3, 2, "Pond", "small round farm pond with reeds and a duck"),
    "broker": (6, 5, "Import Broker", "fancy travelling merchant wagon with crates and a canopy"),
}
for sid, (pr, ch, what, prompt) in SPOT_ART.items():
    add(pr, ch, f"map/{sid}.png", "512 max", what, prompt)
# buildings in the order the story reaches them
for sid, chain in chains.items():
    for nid in chain:
        n = NODES.get(nid)
        if not n or nid.startswith("road_"):      # the road is drawn from road tiles (road/road_1 … road_9)
            continue
        ch = int(n.get("chapter", 1))
        add(2 if ch == 1 else ch + 1, ch, f"map/{nid}.png", "512 max", f"{n['name']} ({sid})", f"{n['name'].lower()}: {n.get('desc', '')}")
# pens, gardens and the pond lie flat (an empty fenced diamond with nice ground); what is built there comes as add-ons
LAYOUT = json.load(open(os.path.join(ROOT, "data", "map_layout.json"), encoding="utf-8"))
PLOT_PROMPTS = {
    "coop": "empty chicken run: packed earth with straw, fenced with a rustic picket fence along all four diamond edges, small gate, nothing inside",
    "cows": "empty cow pasture: lush grass and clover, three-rail wooden fence along all four diamond edges, gate, nothing inside",
    "sheep": "empty sheep meadow: soft grass and tiny flowers, low stone-and-rail fence along all four diamond edges, nothing inside",
    "pets": "empty pet garden: soft grass, stepping stones, flower clumps, low white picket fence along the diamond edges",
    "bees": "wildflower bee garden with lavender, poppies, sunflowers and a stepping-stone path, no fence, no hives",
    "pond": "small farm pond with reeds, lily pads and a little wooden jetty on a diamond of grass",
    "orchard": "orchard plot: tidy grass with four small apple trees in a 2 by 2 pattern",
}
for sid, p in LAYOUT.get("places", {}).items():
    if p.get("k") == "plot":
        add(2, 1, f"plots/{sid}.png", "512 max", f"Ground of {sid} (flat, diamond)", PLOT_PROMPTS.get(sid, sid + " plot seen as a diamond"))
add(2, 1, "plots/home.png", "512 max", "House yard before the house (2×2 tiles)", "homestead yard: packed earth with a few flagstones, nothing on it")
for pid, lst in LAYOUT.get("addons", {}).items():
    for a in lst:
        n = NODES.get(a["id"], {})
        ch = int(n.get("chapter", 1))
        add(3 if ch <= 2 else ch + 1, ch, f"addons/{a.get('pic', a['id'])}.png", "256 max", f"On {pid}: {n.get('name', a['id'])} (appears when built)",
            (n.get("name", a["id"]).lower() + ": " + n.get("desc", "")).strip())
# fences round the fields and borders in the gaps between patches: ONE straight side of a diamond, rising from lower
# left to upper right (1 up for every 2 across); the game mirrors it for the other sides
SIDE = "one straight side of an isometric diamond, running from lower left to upper right, rising 1 for every 2 across, posts at both ends"
for kind, ch, what in [("stick_broken", 1, "broken old stick fence (after the fire)"), ("stick_fence", 1, "stick fence"),
                       ("wattle_fence", 2, "woven wattle fence"), ("wattle_broken", 2, "sagging wattle fence with holes"),
                       ("picket_fence", 3, "white picket fence"), ("picket_broken", 3, "weathered picket fence, pickets missing"),
                       ("stone_wall", 4, "dry-stone wall"), ("stone_broken", 1, "crumbling stone wall round the old fields"),
                       ("hedge_row", 5, "trimmed hedgerow")]:
    add(2 if ch == 1 else ch + 1, ch, f"fences/{kind}.png", "512 max", f"Field fence side: {what}", f"{what}, {SIDE}")
for kind, ch, what in [("stick", 1, "short sticks as edging"), ("stick_broken", 1, "old leaning stick edging"),
                       ("stone", 2, "low border of flat stones"), ("stone_broken", 2, "stone border with gaps and grass"),
                       ("log", 1, "one round log lying as edging (raised log beds)"), ("wicker", 2, "very low woven wicker edging"),
                       ("net", 3, "tiny mesh net fence against rabbits and birds"), ("channel", 3, "narrow irrigation channel with water"),
                       ("drip", 4, "thin black drip irrigation hose")]:
    add(2 if ch == 1 else ch + 1, ch, f"edging/{kind}.png", "384 max", f"Patch border side: {what}", f"{what}, low and narrow, {SIDE}")
# the insides of the buildings (empty rooms) and what gets built inside them
for art, what in [("house", "farmhouse"), ("barn", "big wooden barn"), ("workshop", "timber workshop")]:
    add(3, 2, f"interiors/{art}.png", "1024 max", f"Inside the {what} (empty)", f"empty {what} interior as an isometric dollhouse cutaway: diamond floor, two back walls, no furniture")
hot_src = spots_src.split("const HOTSPOT_ART")[1].split("\n}")[0]
for m in re.finditer(r'"(\w+)": \[([^\]]*)\]', hot_src):
    for nid in re.findall(r'"(\w+)"', m.group(2)):
        n = NODES.get(nid)
        if not n:
            continue
        ch = int(n.get("chapter", 1))
        add(4 if ch <= 2 else ch + 2, ch, f"interior/{nid}.png", "384 max", f"{n['name']} (inside, {m.group(1)})", f"{n['name'].lower()}: {n.get('desc', '')}")
# scarecrow levels sit on the field
for nid in ["scarecrow_1", "scarecrow_2", "scarecrow_3"]:
    n = NODES[nid]
    add(2 if n["chapter"] == 1 else n["chapter"] + 1, n["chapter"], f"map/{nid}.png", "256 max", n["name"], "friendly scarecrow, " + n.get("desc", ""))
# animals and pets walking around
for nid, n in NODES.items():
    if n["type"] in ("animal", "pet"):
        ch = int(n.get("chapter", 1))
        add(3 if ch == 1 else ch + 2, ch, f"animals/{nid}.png", "256 max", n["name"], n["name"].lower() + ", whole body, side view")
# crops: ONE grown plant (each plant on a patch is drawn on its own; also the picture on top of a patch's sheet)
for nid, n in NODES.items():
    if n["type"] == "crop":
        ch = int(n.get("chapter", 1))
        add(ch + 1, ch, f"crops/{nid}.png", "256 max", n["name"] + " (one plant)", "one ripe " + n["name"].lower() + " plant growing out of the ground, no pot")

# the people you help: their portrait is the stamp on their postcards (friends/<side quest id>.png; a friend helped twice
# has one portrait, under the first favour)
_seen_friends = set()
for nid, n in NODES.items():
    if n["type"] == "sidequest" and n.get("friend") and n["friend"]["name"] not in _seen_friends:
        _seen_friends.add(n["friend"]["name"])
        ch = int(n.get("chapter", 1))
        add(3 if ch == 1 else ch + 2, ch, f"friends/{nid}.png", "256 max", f"Friend: {n['friend']['name']} (postcard stamp)",
            f"head-and-shoulders portrait of {n['friend']['name'].lower()}, friendly, looking at the viewer, in a round frame")
# pictures in the album, one per favour (shown instead of the placeholder text)
for nid, n in NODES.items():
    if n["type"] == "sidequest":
        ch = int(n.get("chapter", 1))
        add(4 if ch == 1 else ch + 3, ch, f"album/{nid}.png", "512 max", f"Album picture: {n['name']}", n.get("reward", {}).get("picture", n["name"]))
# pests on the fields (emoji until drawn)
for p, what in [("bird", "small sparrow pecking"), ("rabbit", "small wild rabbit nibbling"), ("slug", "garden slug"), ("caterpillar", "green caterpillar"), ("vole", "small field vole")]:
    add(3, 1, f"pests/{p}.png", "128 max", f"Pest on a patch: {p}", what + ", whole body, side view")
# things in the store, the market and flying to the basket (emoji until drawn)
for k, it in DATA["items"].items():
    ch = int(it.get("chapter", 1))
    add(5 if ch <= 2 else ch + 3, ch, f"items/{k}.png", "128 max", f"Item: {it['name']}", f"{it['name'].lower()}, single object icon")
rows.sort(key=lambda r: (r[0], r[1], r[2]))
# pictures already generated on a sheet that is not in the art inbox yet (e.g. round 8: the parent still picks the best version)
_inbox = os.path.join(os.path.dirname(ROOT), "art-inbox")
_sheets = json.load(open(os.path.join(ROOT, "tools", "art_sheets.json"), encoding="utf-8"))["sheets"]
_waiting = {}
for _sheet, _names in _sheets.items():
    if not os.path.exists(os.path.join(_inbox, _sheet)):
        for _n in _names:
            if _n != "-":
                _waiting.setdefault("assets/" + _n + ".png", _sheet)
for r in rows:
    if r[6] == "missing" and r[2] in _waiting:
        r[6] = "generated - pick " + _waiting[r[2]]
# next to the art inbox if there is one (a .csv inside the Godot project would be imported as a translation)
inbox = os.path.join(os.path.dirname(ROOT), "art-inbox")
out = os.path.join(inbox if os.path.isdir(inbox) else os.path.dirname(os.path.abspath(__file__)), "ART_LIST.csv")
with open(out, "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["# style prompt: " + STYLE])
    w.writerow(["priority", "chapter", "file", "size", "what", "prompt", "status"])
    seen = set()
    for r in rows:
        if r[2] in seen:
            continue
        seen.add(r[2])
        w.writerow(r)
done = sum(1 for r in rows if r[6] == "done")
waiting = sum(1 for r in rows if r[6].startswith("generated"))
print(f"wrote {out}: {len(seen)} pictures, {done} done, {waiting} generated and waiting to be picked")
