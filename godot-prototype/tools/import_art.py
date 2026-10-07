#!/usr/bin/env python3
"""Turn AI-generated pictures into game sprites.

Sprite sheet (objects on a plain white background, read left-to-right, top-to-bottom):
    python3 tools/import_art.py sheet SHEET.png map/tent map/well_1 map/campfire ...
  -> cuts every object out, makes the white background transparent, trims it and saves
     assets/map/tent.png, assets/map/well_1.png ... (longest side at most 512 px).
     Use "-" as a name to skip an object.

Seamless ground texture:
    python3 tools/import_art.py tile GRASS.png tiles/grass
  -> blends the edges so the picture repeats without seams and saves assets/tiles/grass.png (512 px).

Single object on white (inside rooms are kept bigger: up to 1024 px):
    python3 tools/import_art.py one PICTURE.png map/market_stall
    python3 tools/import_art.py one ROOM.png interiors/house

Everything listed in tools/art_sheets.json (sheets, single pictures and tiles from ../art-inbox/; missing files are skipped):
    python3 tools/import_art.py all

Bare-earth and road tiles (ground/…, road/…) lose the rim of grass the generator paints round them, get a crisp, slightly
irregular edge and become diamonds exactly twice as wide as tall (they lie on the ground grid).

Fence, border and ruined-wall sides (fences/…, edging/…, ruins/…) are turned so they run from lower left to upper right; the game mirrors
them for the other two sides of a diamond.

Drop shadows: the generator paints a light grey shadow meant for a white page. The tool turns it into a
see-through dark blue (SHADOW_COLOR below) so it darkens the grass instead of looking like a pale stain.

Needs Python 3 with Pillow and numpy (pip install pillow numpy). scipy is used when present.
Names follow the data ids, so the game picks the picture up by itself (see scripts/art.gd).
"""
import os
import sys

import numpy as np
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
ASSETS = os.path.join(os.path.dirname(HERE), "assets")
MAX_SIDE = 512
# drop shadows become a see-through dark blue that darkens whatever they fall on (None keeps the original grey)
SHADOW_COLOR = (22, 30, 74)
SHADOW_STRENGTH = 1.5
SHADOW_MAX = 0.5


def _label(mask):
    """Connected components (4-neighbour). Uses scipy if available, otherwise a small union-find."""
    try:
        from scipy import ndimage
        lab, n = ndimage.label(mask)
        return lab, n
    except ImportError:
        pass
    h, w = mask.shape
    lab = np.zeros((h, w), dtype=np.int32)
    parent = [0]

    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    nxt = 1
    for y in range(h):
        row = mask[y]
        for x in range(w):
            if not row[x]:
                continue
            up = lab[y - 1, x] if y > 0 else 0
            left = lab[y, x - 1] if x > 0 else 0
            if up == 0 and left == 0:
                parent.append(nxt)
                lab[y, x] = nxt
                nxt += 1
            elif up and left:
                a, b = find(up), find(left)
                lab[y, x] = min(a, b)
                if a != b:
                    parent[max(a, b)] = min(a, b)
            else:
                lab[y, x] = up or left
    roots = np.array([find(i) for i in range(nxt)])
    lab = roots[lab]
    uniq = np.unique(lab[lab > 0])
    remap = np.zeros(nxt, dtype=np.int32)
    remap[uniq] = np.arange(1, len(uniq) + 1)
    return remap[lab], len(uniq)


def _dilate(mask, r):
    try:
        from scipy import ndimage
        return ndimage.binary_dilation(mask, iterations=r)
    except ImportError:
        out = mask.copy()
        for _ in range(r):
            m = out.copy()
            m[1:, :] |= out[:-1, :]
            m[:-1, :] |= out[1:, :]
            m[:, 1:] |= out[:, :-1]
            m[:, :-1] |= out[:, 1:]
            out = m
        return out


def cut_background(img):
    """RGBA with the white background (connected to the border) made transparent and soft edges."""
    rgb = np.asarray(img.convert("RGB")).astype(np.int16)
    mn = rgb.min(axis=2)
    spread = rgb.max(axis=2) - mn
    near_white = (mn > 232) & (spread < 22)
    lab, n = _label(near_white)
    border = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    bg = np.isin(lab, list(border))
    # holes inside an object (between a tripod's legs, a fence's rails) that show the pure white background:
    # paper-white parts of the object itself (a tent, a bunny) are a little darker and stay
    for i in range(1, n + 1):
        if i in border:
            continue
        m = lab == i
        if m.sum() >= 250 and mn[m].mean() >= 249.5:
            bg |= m
    alpha = np.where(bg, 0, 255).astype(np.float32)
    # feather a 2 px band next to the background by how white it is
    band = _dilate(bg, 2) & ~bg
    soft = np.clip((255.0 - mn) / 40.0, 0.0, 1.0) * 255.0
    alpha[band] = np.minimum(alpha[band], soft[band])
    out_rgb = rgb.astype(np.float32)
    if SHADOW_COLOR is not None:
        # The generator draws a light grey drop shadow meant for a white page; on grass it looks like a pale stain.
        # A shadow is light grey AND touches the background without crossing the object's dark outline,
        # so grey parts of the object itself (stones, a well, a tent's folds) stay as they are.
        light_grey = (spread < 16) & (mn >= 135) & (mn <= 244) & ~bg
        glab, gn = _label(light_grey)
        touching = set(np.unique(glab[_dilate(bg, 2) & light_grey])) - {0}
        shadow = np.isin(glab, list(touching))
        shadow = shadow | (band & (spread < 16) & (mn >= 135))
        dark = np.clip((250.0 - mn) / 250.0, 0.0, 1.0)
        a = np.clip(dark * SHADOW_STRENGTH, 0.0, SHADOW_MAX) * 255.0
        alpha[shadow] = np.minimum(np.where(band[shadow], alpha[shadow], 255.0), a[shadow])
        out_rgb[shadow] = SHADOW_COLOR
    out = np.dstack([out_rgb.astype(np.uint8), alpha.astype(np.uint8)])
    return Image.fromarray(out, "RGBA"), ~bg


def rising_to_the_right(im):
    """Fence and border sides must run from lower left to upper right; mirror the picture if it runs the other way."""
    a = np.asarray(im)[..., 3] > 128
    h, w = a.shape
    ys = np.arange(h)[:, None]
    def mean_y(part):
        n = part.sum()
        return (ys * part).sum() / n if n else h / 2
    left, right = mean_y(a[:, : w // 3]), mean_y(a[:, 2 * w // 3:])
    return im if left >= right else im.transpose(Image.FLIP_LEFT_RIGHT)


def ground_tile(im, name):
    """Bare-earth tiles (ground/…) and road tiles (road/…) lie on the ground grid. The generator paints a rim of grass round
    them: cut a little further in so no green is left, give the edge a slightly irregular line (no feathering: a crisp edge),
    and make the diamond exactly twice as wide as it is tall."""
    from scipy import ndimage
    a = np.asarray(im.convert("RGBA")).astype(np.float32)
    r, g, b, al = a[..., 0], a[..., 1], a[..., 2], a[..., 3]
    inside = ((g - (r + b) / 2.0) < 22.0) & (al > 128)
    lab, n = ndimage.label(inside)
    if n > 1:
        sizes = ndimage.sum(inside, lab, range(1, n + 1))
        inside = lab == (1 + int(np.argmax(sizes)))
    inside = ndimage.binary_fill_holes(inside)
    dist = ndimage.distance_transform_edt(inside)
    h, w = inside.shape
    road = name.startswith("road/")
    inset = max(3.0, w * (0.012 if road else 0.03))
    amp = w * (0.006 if road else 0.022)
    noise = ndimage.gaussian_filter(np.random.RandomState(__import__('zlib').crc32(name.encode()) % (2 ** 31)).randn(h, w), sigma=max(2.0, w / 40.0))
    noise /= max(1e-6, noise.std())
    alpha = np.clip(dist - (inset + amp * noise) + 0.5, 0.0, 1.0) * 255.0
    a[..., 3] = np.minimum(al, alpha)
    out = Image.fromarray(a.astype(np.uint8), "RGBA")
    bbox = out.getbbox()
    if bbox:
        out = out.crop(bbox)
    return out.resize((out.width, max(1, out.width // 2)), Image.LANCZOS)


def save_sprite(im, name, max_side=MAX_SIDE):
    if name.startswith(("ground/", "road/")):
        im = ground_tile(im, name)
    bbox = im.getbbox()
    if bbox and name.startswith(("fences/", "edging/", "ruins/")):
        im = rising_to_the_right(im.crop(bbox))
        bbox = im.getbbox()
    if bbox:
        im = im.crop(bbox)
    pad = 6
    canvas = Image.new("RGBA", (im.width + pad * 2, im.height + pad * 2), (0, 0, 0, 0))
    canvas.paste(im, (pad, pad))
    im = canvas
    s = max_side / max(im.size)
    if s < 1:
        im = im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))), Image.LANCZOS)
    path = os.path.join(ASSETS, name + ".png")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    im.save(path, optimize=True)
    print("saved", os.path.relpath(path, os.path.dirname(ASSETS)), im.size)


def objects(sheet_path, names):
    img = Image.open(sheet_path)
    rgba, fg = cut_background(img)
    joined = _dilate(fg, 10)  # glue shadows and loose bits to their object
    lab, n = _label(joined)
    h, w = fg.shape
    comps = []
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i)
        if len(ys) < h * w * 0.004:
            continue
        comps.append((ys.min(), xs.min(), ys.max(), xs.max(), i))
    # reading order: group into rows by vertical centre, then left to right
    comps.sort(key=lambda c: (c[0] + c[2]) / 2)
    rows, cur = [], []
    for c in comps:
        cy = (c[0] + c[2]) / 2
        if cur and cy - (cur[-1][0] + cur[-1][2]) / 2 > h * 0.12:
            rows.append(cur)
            cur = []
        cur.append(c)
    if cur:
        rows.append(cur)
    ordered = [c for r in rows for c in sorted(r, key=lambda c: c[1])]
    print(f"{sheet_path}: found {len(ordered)} objects, {len(names)} names")
    for c, name in zip(ordered, names):
        if name == "-":
            continue
        y0, x0, y1, x1, li = c
        box = (max(0, x0 - 4), max(0, y0 - 4), min(w, x1 + 5), min(h, y1 + 5))
        piece = np.asarray(rgba.crop(box)).copy()
        # keep only this object's pixels (bits of a neighbour inside the box become transparent)
        mine = lab[box[1]:box[3], box[0]:box[2]] == li
        piece[..., 3] = np.where(mine, piece[..., 3], 0)
        save_sprite(Image.fromarray(piece, "RGBA"), name)
    if len(ordered) != len(names):
        print("WARNING: object count differs from the number of names — check the results")


def one(path, name):
    rgba, _ = cut_background(Image.open(path))
    save_sprite(rgba, name, 1024 if name.startswith("interiors/") else MAX_SIDE)


def tile(path, name, size=512):
    """Make a texture repeat seamlessly, then scale it. The picture is shifted by half its size, so its own edges meet in a
    cross through the middle; that cross is then covered with the unshifted picture along a ragged, softened line. (A plain
    cross-fade leaves blurry bands that show as streaks across the grass.)"""
    from scipy import ndimage
    im = np.asarray(Image.open(path).convert("RGB")).astype(np.float32)
    n = min(im.shape[0], im.shape[1])
    im = im[:n, :n]
    shifted = np.roll(np.roll(im, n // 2, axis=0), n // 2, axis=1)
    yy, xx = np.mgrid[0:n, 0:n]
    rs = np.random.RandomState(7)
    wob = ndimage.gaussian_filter(rs.randn(n, n), sigma=n / 40.0)
    wob /= max(1e-6, wob.std())
    half = n / 2.0
    width = n / 9.0 + wob * n / 22.0                  # how far from the middle lines the patch reaches (ragged)
    cross = (np.abs(xx - half) < width) | (np.abs(yy - half) < width)
    m = ndimage.gaussian_filter(cross.astype(np.float32), sigma=max(1.5, n / 400.0))[..., None]
    out = shifted * (1.0 - m) + im * m
    out_im = Image.fromarray(np.clip(out, 0, 255).astype(np.uint8), "RGB").resize((size, size), Image.LANCZOS)
    path_out = os.path.join(ASSETS, name + ".png")
    os.makedirs(os.path.dirname(path_out), exist_ok=True)
    out_im.save(path_out, optimize=True)
    print("saved", os.path.relpath(path_out, os.path.dirname(ASSETS)), out_im.size)


def all_from_list():
    import json
    root = os.path.dirname(HERE)
    inbox = os.path.join(os.path.dirname(root), "art-inbox")
    spec = json.load(open(os.path.join(HERE, "art_sheets.json"), encoding="utf-8"))
    def there(f):
        if os.path.exists(os.path.join(inbox, f)):
            return True
        print("skipped (not in art-inbox yet):", f)
        return False
    for sheet, names in spec["sheets"].items():
        if there(sheet):
            objects(os.path.join(inbox, sheet), names)
    for src, name in spec.get("singles", {}).items():
        if there(src):
            one(os.path.join(inbox, src), name)
    for src, name in spec.get("tiles", {}).items():
        if there(src):
            tile(os.path.join(inbox, src), name)


if __name__ == "__main__":
    if len(sys.argv) == 2 and sys.argv[1] == "all":
        all_from_list()
        sys.exit(0)
    if len(sys.argv) < 4:
        print(__doc__)
        sys.exit(1)
    mode, src, rest = sys.argv[1], sys.argv[2], sys.argv[3:]
    if mode == "sheet":
        objects(src, rest)
    elif mode == "one":
        one(src, rest[0])
    elif mode == "tile":
        tile(src, rest[0])
    else:
        print(__doc__)
