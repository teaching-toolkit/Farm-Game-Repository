#!/usr/bin/env python3
"""Cut a sheet of full painted square pictures (album pictures, rounded corners, on a white page) into assets/<name>.png.

    python3 tools/import_album_sheet.py ../art-inbox/sheet61-album-ch6.png album/sq_a album/sq_b ...   (row by row)

Unlike import_art.py's `sheet` mode it never makes white INSIDE a picture see-through (a pale sky stays): only the white
page round each picture goes: the picture is cut as a rounded rectangle (RADIUS of its side; a flood fill leaks into a pale sky). Needs Pillow and numpy.
"""
import sys, os
import numpy as np
from PIL import Image, ImageDraw
RADIUS = 0.15
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def runs(mask, min_len):
    out, start = [], None
    for i, v in enumerate(list(mask) + [False]):
        if v and start is None: start = i
        elif not v and start is not None:
            if i - start >= min_len: out.append((start, i))
            start = None
    return out

def main():
    sheet, names = sys.argv[1], sys.argv[2:]
    im = Image.open(sheet).convert("RGB")
    a = np.asarray(im).astype(int)
    ink = (a.min(axis=2) < 235)
    boxes = []
    for y0, y1 in runs(ink.mean(axis=1) > 0.05, 40):
        for x0, x1 in runs(ink[y0:y1].mean(axis=0) > 0.05, 40):
            boxes.append((x0, y0, x1, y1))
    print("%s: found %d pictures, %d names" % (sheet, len(boxes), len(names)))
    if len(boxes) != len(names): sys.exit("count differs: nothing written")
    for (x0, y0, x1, y1), name in zip(boxes, names):
        if name == "-": continue
        c = im.crop((x0 + 2, y0 + 2, x1 - 2, y1 - 2)).convert("RGBA")
        mask = Image.new("L", (c.width * 4, c.height * 4), 0)      # a rounded rectangle, drawn big and scaled down for a smooth edge
        r = int(min(c.size) * RADIUS) * 4
        ImageDraw.Draw(mask).rounded_rectangle((0, 0, mask.width - 1, mask.height - 1), radius=r, fill=255)
        c.putalpha(mask.resize(c.size, Image.LANCZOS))
        c.thumbnail((512, 512))
        dest = os.path.join(ROOT, "assets", name + ".png")
        c.save(dest)
        print("saved", name, c.size)

main()
