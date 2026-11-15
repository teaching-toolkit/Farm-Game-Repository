#!/usr/bin/env python3
"""Put window pictures (the painted strip across the top of a window) into the game.

    python3 tools/import_window_pictures.py <key> <picture file>   # one picture (a path, or relative to ../art-inbox/)
    python3 tools/import_window_pictures.py                        # everything in tools/window_picture_files.json

<key> is an id of tools/window_pictures.json (storage, bag, ws_loom ...). The picture is trimmed of a plain border (if it has one),
cropped to 3:2 around its middle, scaled to 768 x 512 and saved as assets/windows/<key>.webp (lossy) with a small .import file
beside it that keeps it lossy (the same trick as import_story_pictures.py). The originals are never changed.
Needs Python 3 with Pillow built with WebP (the project's artvenv).
"""
import json
import os
import sys

from PIL import Image, ImageChops

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
INBOX = os.path.join(os.path.dirname(ROOT), "art-inbox")
OUT = os.path.join(ROOT, "assets", "windows")
MAPPING = os.path.join(HERE, "window_picture_files.json")
W, H = 768, 512
QUALITY = 82
IMPORT_FILE = """[remap]

importer="texture"
type="CompressedTexture2D"

[params]

compress/mode=1
compress/lossy_quality=0.8
mipmaps/generate=false
"""


def trim_border(im):
    """Cut off a plain border (the colour of the corner), if there is one."""
    bg = Image.new("RGB", im.size, im.getpixel((0, 0)))
    box = ImageChops.difference(im, bg).point(lambda v: 255 if v > 12 else 0).getbbox()
    if box and box != (0, 0) + im.size and (box[2] - box[0]) > im.width * 0.5 and (box[3] - box[1]) > im.height * 0.5:
        return im.crop(box)
    return im


def convert(src, dst):
    im = trim_border(Image.open(src).convert("RGB"))
    w, h = im.size
    if w * 2 > h * 3:      # wider than 3:2: cut left and right
        nw = round(h * 3 / 2)
        im = im.crop(((w - nw) // 2, 0, (w - nw) // 2 + nw, h))
    else:                  # taller: cut top and bottom
        nh = round(w * 2 / 3)
        im = im.crop((0, (h - nh) // 2, w, (h - nh) // 2 + nh))
    im = im.resize((W, H), Image.LANCZOS)
    im.save(dst, "WEBP", quality=QUALITY, method=6)
    if not os.path.exists(dst + ".import"):
        with open(dst + ".import", "w") as f:
            f.write(IMPORT_FILE)


def one(key, path):
    src = path if os.path.exists(path) else os.path.join(INBOX, path)
    if not os.path.exists(src):
        print("missing:  %s  <- %s" % (key, path))
        return False
    os.makedirs(OUT, exist_ok=True)
    dst = os.path.join(OUT, key + ".webp")
    convert(src, dst)
    print("saved:    assets/windows/%s.webp (%d KB)" % (key, os.path.getsize(dst) // 1024))
    return True


def main(argv):
    if len(argv) == 2:
        return 0 if one(argv[0], argv[1]) else 1
    if argv:
        print(__doc__)
        return 2
    with open(MAPPING, encoding="utf-8") as f:
        mapping = {k: v for k, v in json.load(f).items() if not k.startswith("_")}
    bad = sum(0 if one(k, v) else 1 for k, v in sorted(mapping.items()))
    print("%d mapped, %d missing" % (len(mapping), bad))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
