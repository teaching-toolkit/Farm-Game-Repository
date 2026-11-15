#!/usr/bin/env python3
"""Take the white paving slab out from under a deco sprite (OpenArt draws one under every object).

    python3 tools/strip_footprint.py <backup-dir> assets/deco/barrels.png assets/deco/crates_produce.png ...

What it does, per picture: the white slab (and the soft grey shadow on it) becomes transparent with the
shadow kept as a faint black; the slab's thin dark outline is erased; the object itself is untouched.
A copy of the original is kept in <backup-dir> (outside assets/). Needs Pillow, numpy and scipy (see the farm-game-content skill for the venv).
"""
import os
import sys
import shutil
import numpy as np
from PIL import Image
from scipy import ndimage as ndi


def strip(path, backup):
    im = Image.open(path).convert("RGBA")
    a = np.array(im)
    rgb = a[..., :3].astype(int)
    alpha = a[..., 3] > 0
    v = rgb.min(axis=2)
    neutral = (rgb.max(axis=2) - rgb.min(axis=2)) <= 14
    light = alpha & neutral & (v >= 165)
    lab, n = ndi.label(light)
    flood = np.zeros_like(light)
    for i in range(1, n + 1):
        m = lab == i
        if m.sum() > 400 and (v[m] >= 240).any():
            flood |= m
    if not flood.any():
        return False
    # the slab's own outline: thin dark pixels hugging the slab's outer edge
    ys, xs = np.nonzero(flood)
    hull_rows = np.zeros_like(flood)
    # convex hull of the slab by row/column extremes (a diamond is convex): fill between left/right extremes
    for y in np.unique(ys):
        row = xs[ys == y]
        hull_rows[y, row.min():row.max() + 1] = True
    hull_cols = np.zeros_like(flood)
    for x in np.unique(xs):
        col = ys[xs == x]
        hull_cols[col.min():col.max() + 1, x] = True
    hull = hull_rows & hull_cols
    band = ndi.binary_dilation(hull, iterations=6)
    rest = alpha & ~flood
    opened = ndi.binary_opening(rest, structure=np.ones((5, 5), bool))
    ring = band & rest & ~opened
    # shadow on the slab: grey -> faint black, white -> clear
    out = a.copy()
    dark = (236 - v).clip(0, 70) / 70.0   # the slab's white (v 236-255) is clear; only a real shadow stays
    out[flood, :3] = 20
    out[flood, 3] = (dark[flood] * 90).astype(np.uint8)
    out[ring, 3] = 0
    # drop specks left by the erasing
    keep = out[..., 3] > 0
    lab2, n2 = ndi.label(keep)
    sizes = ndi.sum(keep, lab2, range(1, n2 + 1))
    for i, s in enumerate(sizes, 1):
        if s < 60:
            out[lab2 == i, 3] = 0
    os.makedirs(backup, exist_ok=True)
    shutil.copyfile(path, os.path.join(backup, os.path.basename(path)))
    Image.fromarray(out).save(path)
    return True


if __name__ == "__main__":
    for p in sys.argv[2:]:
        print(p, "stripped" if strip(p, sys.argv[1]) else "no slab found")
