#!/usr/bin/env python3
"""Writes the starting farm-map layout (version 2: everything on one iPad screen) to data/map_layout.json.

You normally don't need this: move and resize things with the layout editor (tools/layout-editor.html)
and save its result as data/map_layout.json. This script only recreates the original arrangement.

Coordinates are design pixels: the farm is 834 wide and 1000 high and is scaled to fit the screen.
The ground is an isometric grid of diamond tiles, `tile` pixels wide and half as high. The fields have their own,
bigger patches (`field.patch` wide) with a gap between them (`field.gap`) for edging, little fences and irrigation.

places   — every place on the map. x, y are its "feet": the front (lowest) corner of its footprint diamond.
           foot = [a, b] tiles (a along the right-down edge, b along the left-down edge).
           w = picture width; ws = {picture name: width} for stages that need another size (a basket is smaller
           than the warehouse that replaces it). k = "obj" (stands up, drawn by its feet), "plot" (lies flat: a pen,
           a garden, the pond), "sub" (stands in the house yard until the house is built, then moves inside).
fields   — the three fields (3×3 patches with gaps), feet = front corner; they stand in a column in the middle.
addons   — things built ON a place that appear when they are built (a bigger chicken house, nest boxes, bee hives …):
           dx, dy from the place's feet, w = width, pic = picture name if not the node id,
           until = hide once this node is built.
interiors— where the corners stand inside the house, barn and workshop (x, y, w as fractions of the inside picture).
"""
import json
import os
import random

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

W, H = 834, 1000
TILE = 88                      # ground tile: footprints of the places
FIELD = {"patch": 144, "gap": 12}   # field patches (diamond width) and the gap between them

forest = [[0, 0], [300, 0], [0, 150]]                    # the forest comes in from the top left
road = {"points": [[540, -30], [900, 150]], "w": 60}     # the village road comes in from the top right

places = {
    # the homestead above the fields, the forest and the road
    "forest":   {"x": 170, "y": 196, "foot": [2, 1], "w": 150},
    "lumber":   {"x": 95,  "y": 318, "foot": [2, 2], "w": 180, "ws": {"lumber": 120}},
    "home":     {"x": 417, "y": 244, "foot": [2, 2], "w": 195},
    "living":   {"x": 417, "y": 200, "foot": [1, 1], "w": 100, "k": "sub"},
    "library":  {"x": 373, "y": 222, "foot": [1, 1], "w": 70, "k": "sub"},
    "kitchen":  {"x": 461, "y": 222, "foot": [1, 1], "w": 76, "k": "sub"},
    "well":     {"x": 268, "y": 262, "foot": [1, 1], "w": 80},
    "storage":  {"x": 573, "y": 266, "foot": [2, 1], "w": 140, "ws": {"basket": 74}},
    "board":    {"x": 505, "y": 108, "foot": [1, 1], "w": 80},
    "market":   {"x": 655, "y": 168, "foot": [2, 1], "w": 150, "ws": {"market": 120}},
    "bookcart": {"x": 775, "y": 236, "foot": [1, 1], "w": 92},
    "windmill": {"x": 785, "y": 330, "foot": [1, 1], "w": 110},
    # the three fields stand in a column in the middle; the sign of the Home Field and things in the pockets between them
    "field":    {"x": 240, "y": 452, "foot": [1, 1], "w": 50},
    "compost":  {"x": 250, "y": 545, "foot": [1, 1], "w": 90},
    "broker":   {"x": 584, "y": 785, "foot": [1, 1], "w": 92},
    # left side: animals, the pond
    "coop":     {"x": 95,  "y": 452, "foot": [2, 2], "w": 185, "k": "plot"},
    "pond":     {"x": 95,  "y": 572, "foot": [2, 2], "w": 185, "k": "plot"},
    "pets":     {"x": 95,  "y": 692, "foot": [2, 2], "w": 185, "k": "plot"},
    "cows":     {"x": 95,  "y": 812, "foot": [2, 2], "w": 185, "k": "plot"},
    "sheep":    {"x": 95,  "y": 932, "foot": [2, 2], "w": 185, "k": "plot"},
    # right side: workshop, barn, bees, orchard, greenhouse
    "workshop": {"x": 739, "y": 452, "foot": [2, 2], "w": 185, "ws": {"workbench": 100}},
    "bees":     {"x": 739, "y": 572, "foot": [2, 2], "w": 185, "k": "plot"},
    "barn":     {"x": 739, "y": 692, "foot": [2, 2], "w": 190},
    "orchard":  {"x": 739, "y": 812, "foot": [2, 2], "w": 185, "k": "plot"},
    "greenhouse": {"x": 739, "y": 932, "foot": [2, 2], "w": 185},
}

# front corners of the three 3×3 fields, one above the other
fields = [{"x": 417, "y": 486}, {"x": 417, "y": 726}, {"x": 417, "y": 966}]

addons = {
    "coop": [{"id": "coop_1", "dx": -34, "dy": -48, "w": 80}, {"id": "coop_2", "dx": -34, "dy": -48, "w": 96},
             {"id": "nest_boxes", "dx": 40, "dy": -40, "w": 52}, {"id": "perches", "dx": 26, "dy": -14, "w": 40}],
    "cows": [{"id": "animal_cow", "pic": "cow_shelter", "dx": -32, "dy": -50, "w": 92}, {"id": "salt_lick", "dx": 42, "dy": -30, "w": 46}],
    "sheep": [{"id": "shearing_table", "dx": 36, "dy": -36, "w": 56}],
    "bees": [{"id": "animal_bees", "pic": "bee_skep", "until": "cap_bees_2", "dx": -30, "dy": -40, "w": 44},
             {"id": "cap_bees_2", "pic": "beehive", "dx": -30, "dy": -40, "w": 50},
             {"id": "cap_bees_3", "pic": "bee_house", "dx": 30, "dy": -46, "w": 70}],
    "pets": [{"id": "pet_bunny", "pic": "pets", "dx": -36, "dy": -44, "w": 70}],
    "pond": [{"id": "duck_house", "dx": 40, "dy": -50, "w": 50}],
    "home": [{"id": "farmhouse_sunroom", "pic": "sunroom", "dx": 72, "dy": -10, "w": 80}],
    "greenhouse": [{"id": "greenhouse_2", "pic": "greenhouse_extension", "dx": 72, "dy": -10, "w": 90}],
    "well": [{"id": "rain_barrel", "dx": 36, "dy": -6, "w": 30}],
    "storage": [{"id": "hand_cart", "dx": 62, "dy": 0, "w": 50}],
    "windmill": [{"id": "wind_pump", "dx": 42, "dy": 0, "w": 40}],
}

interiors = {   # fitted to assets/interiors/*.png (feet on the floor diamond)
    "home": {"living": {"x": 0.47, "y": 0.80, "w": 0.26}, "library": {"x": 0.68, "y": 0.52, "w": 0.20},
             "kitchen": {"x": 0.29, "y": 0.56, "w": 0.22}},
    "barn": {"barn_build": {"x": 0.84, "y": 0.64, "w": 0.13}, "barn_cellar": {"x": 0.24, "y": 0.66, "w": 0.22},
             "barn_ferment": {"x": 0.44, "y": 0.50, "w": 0.15}, "barn_hay": {"x": 0.64, "y": 0.52, "w": 0.20},
             "barn_seeds": {"x": 0.50, "y": 0.84, "w": 0.18}},
    "workshop": {"ws_build": {"x": 0.86, "y": 0.66, "w": 0.12}, "ws_bench": {"x": 0.50, "y": 0.70, "w": 0.24},
                 "ws_fire": {"x": 0.25, "y": 0.56, "w": 0.20}, "ws_loom": {"x": 0.72, "y": 0.56, "w": 0.20},
                 "ws_tools": {"x": 0.58, "y": 0.45, "w": 0.18}},
}


def in_forest(x, y):
    # above-left of the forest's inner edge (a diagonal from (300, 0) to (0, 150))
    return y < 150 - x * 0.5 - 6


rng = random.Random(11)
deco = []
tries = 0
while len(deco) < 14 and tries < 4000:
    tries += 1
    x = rng.uniform(4, 292)
    y = rng.uniform(14, 150)
    if not in_forest(x, y):
        continue
    if any((x - d["x"]) ** 2 + ((y - d["y"]) * 1.8) ** 2 < 46 ** 2 for d in deco):
        continue
    deco.append({"pic": "tree_pine" if rng.random() < 0.55 else "tree_oak", "x": round(x), "y": round(y),
                 "w": round(rng.uniform(54, 72))})
deco += [
    {"pic": "tree_pine", "x": 22, "y": 196, "w": 58}, {"pic": "bush", "x": 300, "y": 160, "w": 40},
    {"pic": "bush", "x": 815, "y": 410, "w": 38}, {"pic": "stone", "x": 262, "y": 778, "w": 28},
    {"pic": "bush", "x": 250, "y": 800, "w": 40}, {"pic": "bush", "x": 600, "y": 900, "w": 40},
    {"pic": "stone", "x": 230, "y": 980, "w": 26}, {"pic": "bush", "x": 590, "y": 380, "w": 34},
]
deco.sort(key=lambda d: d["y"])

layout = {
    "version": 2,
    "size": {"w": W, "h": H},
    "tile": TILE,
    "field": FIELD,
    "ground": {"forest": forest, "road": road},
    "fields": fields,
    "scarecrow": {"x": 584, "y": 540, "w": 56},
    "pests": {"x": 584, "y": 548},
    "places": places,
    "addons": addons,
    "deco": deco,
    "interiors": interiors,
}

out = os.path.join(ROOT, "data", "map_layout.json")
with open(out, "w", encoding="utf-8") as f:
    json.dump(layout, f, indent=1, ensure_ascii=False)
print("wrote", out, "-", len(places), "places,", len(deco), "decorations")
