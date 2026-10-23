#!/usr/bin/env python3
"""Put full-bleed story pictures into the game.

    python3 tools/import_story_pictures.py            # everything in tools/story_pictures.json
    python3 tools/import_story_pictures.py --force    # redo pictures that are already up to date
    python3 tools/import_story_pictures.py --check    # only list what is mapped, missing or unused

tools/story_pictures.json maps a story piece id to a picture file, relative to ../art-inbox/Story pictures/:

    { "c1_stalk": "openart outputs/2026-10-12_135108_wheat-stalk-nibbled-closeup_cea49a38.png",
      "c1_stalk_p2": "openart outputs/…png" }       # "<id>_p2" = the picture of page 2 of a piece

Each picture is shrunk to SIZE px (a square scene stays square) and saved as assets/story/<key>.webp (lossy, about 0.1 MB), with a
small <key>.webp.import beside it that tells Godot to keep it lossy: without that file Godot re-encodes a WebP losslessly and
the picture grows about six times in the web pack. (Godot rewrites the .import file when it imports; it is never overwritten here.)
The story box (game/farm/ui/storybox.gd) finds a picture by the piece id, so no change to the story data is needed. A missing file
is skipped (the game then shows the emoji), and the originals in art-inbox/ are never changed.

Unlike import_art.py "one", nothing is cut out or made see-through: a story picture fills its whole frame.
Needs Python 3 with Pillow built with WebP (pip install pillow).
"""
import json
import os
import sys

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SOURCE = os.path.join(os.path.dirname(ROOT), "art-inbox", "Story pictures")
OUT = os.path.join(ROOT, "assets", "story")
MAPPING = os.path.join(HERE, "story_pictures.json")
SIZE = 768   # the story box shows a picture about 520 px wide; 768 keeps it sharp on a retina iPad without a huge download
QUALITY = 82  # WebP quality of the file in assets/
IMPORT_FILE = """[remap]

importer="texture"
type="CompressedTexture2D"

[params]

compress/mode=1
compress/lossy_quality=0.8
mipmaps/generate=false
"""


def load_mapping():
    with open(MAPPING, encoding="utf-8") as f:
        return {k: v for k, v in json.load(f).items() if not k.startswith("_")}


def convert(src, dst):
    im = Image.open(src).convert("RGB")
    if im.size != (SIZE, SIZE):
        w, h = im.size
        s = SIZE / max(w, h)
        im = im.resize((max(1, round(w * s)), max(1, round(h * s))), Image.LANCZOS)
    im.save(dst, "WEBP", quality=QUALITY, method=6)
    if not os.path.exists(dst + ".import"):
        with open(dst + ".import", "w") as f:
            f.write(IMPORT_FILE)


def main(argv):
    force = "--force" in argv
    check = "--check" in argv
    mapping = load_mapping()
    os.makedirs(OUT, exist_ok=True)
    done = skipped = missing = 0
    for key, rel in sorted(mapping.items()):
        src = os.path.join(SOURCE, rel)
        dst = os.path.join(OUT, key + ".webp")
        if not os.path.exists(src):
            print("missing:  %s  <- %s" % (key, rel))
            missing += 1
            continue
        if check:
            print("mapped:   %s" % key)
            continue
        if not force and os.path.exists(dst) and os.path.getmtime(dst) >= os.path.getmtime(src):
            skipped += 1
            continue
        convert(src, dst)
        done += 1
        print("saved:    assets/story/%s.webp (%d KB)" % (key, os.path.getsize(dst) // 1024))
    for f in sorted(os.listdir(OUT)):
        if f.endswith((".png", ".webp")) and f.rsplit(".", 1)[0] not in mapping:
            print("unused:   assets/story/%s is not in story_pictures.json (or is an old .png: delete it)" % f)
    print("%d saved, %d up to date, %d missing" % (done, skipped, missing))
    return 1 if missing else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
