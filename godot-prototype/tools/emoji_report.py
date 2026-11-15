#!/usr/bin/env python3
"""Which things are shown by an emoji that two or more things share, or that does not show the thing?

    python3 tools/emoji_report.py

Reads items and nodes (tools/farmdata.py) and prints
  (a) every emoji used by two or more things that have no picture file yet, with the things;
  (b) things with no picture (or a picture drawn from the emoji) whose emoji does not show them: by rule, plus a short hand-kept list.
tools/art_list.py imports this file: everything in (b) becomes a row of ART_LIST.csv with a better prompt, and the
things of a kind are grouped into sheets of 6 to 9 (see sheet_hint). Which node kinds the game can show at all: NODE_FOLDERS.
"""
import json
import os
import sys
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import farmdata

DATA = farmdata.load()
ITEMS, NODES = DATA["items"], DATA["nodes"]
PLACES = json.load(open(os.path.join(ROOT, "data", "farm", "places.json"), encoding="utf-8"))
BENCH = {b["id"] for b in PLACES["bench"]}          # tools lying on the workbench have their own pictures (tools/)

# node type -> picture folder the game asks for (celebrations.gd: map, helpers, tools, interior; cards.gd: cards).
# Types not in this table (books, polish, patch_*, deliveries, merchants, sidequest orders) have no code that shows
# a picture of them: they are "not shown by the game yet", so no row.
NODE_FOLDERS = {"helper": "helpers", "gear": "helpers", "tool": "helpers", "station": "interior", "knowledge": "cards"}
SKIP_NODES = {"hands", "rock"}                      # no thing to draw

# generic emoji for material items: they show a shape, not the material
GENERIC = {"⚙️": "a gear", "⛰️": "a mountain", "🟫": "a brown square", "🟤": "a brown dot", "📌": "a pin", "⏳": "an hourglass",
           "🪟": "a window", "🔩": "a bolt"}
# known by hand: id -> (why the emoji does not fit, what the picture shows instead)
HAND = {
    "axle": ("shown as a gear", "an axle: a straight round wooden rod with a wheel hub at each end, NOT a gear"),
    "steel": ("shown as a gear", "a steel bar: a shiny blue-grey ingot, NOT a gear"),
    "boulder": ("shown as mountains", "one big grey boulder, a round lump of rock the size of a pumpkin crate, NOT a mountain"),
    "flour": ("same wheat ear as the grain", "a small cloth sack of white flour, loosely open, a little white dust, NOT a wheat ear"),
    "fine_flour": ("a sparkle", "a small cloth sack of very fine white flour with a soft puff of dust"),
    "straw": ("same wheat ear as the grain", "a golden bundle of dry straw tied with a string, NOT a wheat ear"),
    "yarrow_paste": ("same wheat ear as the grain", "a small clay pot of green-grey herb paste with a wooden spoon and a few yarrow flowers"),
    "plantain_paste": ("same leaf as the plant", "a small clay pot of green crushed-leaf paste with a wooden spoon and a plantain leaf"),
    "sand": ("an hourglass", "a small heap of pale sand with a wooden scoop"),
    "plank": ("a brown square", "two or three flat sawn wooden planks stacked"),
    "clay": ("a brown dot", "a lump of wet grey-brown clay with finger marks"),
}


def shown_by_emoji(key):
    """Item or node still shown by the emoji alone: no picture file."""
    if key in ITEMS:
        return not os.path.exists(os.path.join(ROOT, "assets", "items", key + ".png"))
    n = NODES.get(key)
    if n is None or n["type"] not in NODE_FOLDERS or key in SKIP_NODES or key in BENCH:
        return False
    return not os.path.exists(os.path.join(ROOT, "assets", NODE_FOLDERS[n["type"]], key + ".png"))


def misfit(key):
    """Why this thing's emoji does not show it ('' if it does)."""
    if key in HAND:
        return HAND[key][0]
    it = ITEMS.get(key)
    if it and it["category"] == "material" and it["emoji"] in GENERIC:
        return "material shown as " + GENERIC[it["emoji"]]
    if it and "paste" in key:
        return "herb paste shown as the plant"
    return ""


def things():
    """All things the game shows by emoji or picture: (id, name, emoji, kind)."""
    out = [(k, v["name"], v["emoji"], "item") for k, v in ITEMS.items()]
    out += [(k, v["name"], v.get("emoji", ""), v["type"]) for k, v in NODES.items() if v["type"] in NODE_FOLDERS]
    return out


def sheet_hint(kind, index, total):
    """Sheets of 6 to 9: the index-th (0-based) of `total` things of a kind goes on sheet number index*sheets//total + 1."""
    sheets = max(1, round(total / 7.5))
    return "sheet %s-%d" % (kind, index * sheets // total + 1)


def main():
    all_things = things()
    by_emoji = defaultdict(list)
    for k, name, e, kind in all_things:
        if e and shown_by_emoji(k):
            by_emoji[e].append("%s (%s)" % (name, kind))
    print("(a) emoji used by two or more things that have no picture file")
    clashes = sorted(((len(v), e, v) for e, v in by_emoji.items() if len(v) > 1), reverse=True)
    for n, e, v in clashes:
        print("  %s x%d: %s" % (e, n, ", ".join(v)))
    print("\n(a2) emoji shared by two or more things in total (also those with a picture: the emoji still shows in text lines)")
    every = defaultdict(list)
    for k, name, e, kind in all_things:
        if e:
            every[e].append(name)
    for n, e, v in sorted(((len(v), e, v) for e, v in every.items() if len(v) > 1), reverse=True)[:25]:
        print("  %s x%d: %s" % (e, n, ", ".join(v[:10])))
    print("\n(b) emoji does not show the thing (these get their own brief in ART_LIST.csv)")
    for k, name, e, kind in all_things:
        why = misfit(k)
        if why:
            print("  %s %s [%s]: %s%s" % (e, name, k, why, "" if shown_by_emoji(k) else "  (picture file exists: redraw if it still looks like the emoji)"))
    miss = sum(1 for k, _, _, _ in all_things if shown_by_emoji(k))
    print("\nthings with no picture file: %d of %d; emoji clashes among them: %d emoji" % (miss, len(all_things), len(clashes)))


if __name__ == "__main__":
    main()
