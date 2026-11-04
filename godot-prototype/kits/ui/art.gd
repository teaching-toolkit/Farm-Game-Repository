extends RefCounted
## Pictures by name. Put a PNG named after a data id into assets/<folder>/ and it replaces the emoji —
## no code change needed. Missing pictures simply return null and the game keeps showing the emoji.
##
##   assets/map/<node id>.png    buildings and places on the farm map (tent.png, well_1.png, coop_1.png …),
##                               or <spot id>.png as a fallback for the whole place (market.png, forest.png …),
##                               _lot.png for an empty building lot
##   assets/tiles/<name>.png     repeating ground: grass, path, soil, overgrown
##   assets/deco/<name>.png      trees, bushes, weeds, stones, fence pieces
##   assets/animals/<id>.png     animals and pets walking around (animal_chicken.png, pet_bunny.png …)
##   assets/crops/<crop id>.png  a crop on its patch (crop_wheat.png …) — optional
##   assets/story/<piece id>.webp  a painted story scene (lossy; see tools/import_story_pictures.py). Any folder may hold a .webp
##                               instead of a .png.
##
## Uses ResourceLoader so it also works in exported builds (web, iPad), where the original PNG files are not shipped.

const ROOT := "res://assets/"
static var _cache := {}

static func tex(folder: String, key: String) -> Texture2D:
	var path := ROOT + folder + "/" + key + ".png"
	if _cache.has(path): return _cache[path]
	var t: Texture2D = null
	for p in [path, ROOT + folder + "/" + key + ".webp"]:   # a .webp (story scenes) is used when there is no .png
		if ResourceLoader.exists(p):
			t = load(p) as Texture2D
			break
	_cache[path] = t
	return t

static func first(folder: String, keys: Array) -> Texture2D:
	for k in keys:
		if str(k) == "": continue
		var t := tex(folder, str(k))
		if t != null: return t
	return null

static var _icons := {}

## A small version of a picture, for icons next to names and amounts (cost rows, recipe tiles, the store, the bag): the first of
## `keys` found in `folder`, its empty border cut off, scaled down once to at most `px` pixels and kept (null when there is none,
## so the caller shows the emoji). Scaling down once looks smoother than drawing the big picture small, and costs nothing later.
static func icon(folder: String, keys: Array, px := 64) -> Texture2D:
	var ck := "%s|%s|%d" % [folder, ",".join(PackedStringArray(keys.map(func(k): return str(k)))), px]
	if _icons.has(ck): return _icons[ck]
	var out: Texture2D = null
	var t := first(folder, keys)
	if t != null:
		out = t
		var img: Image = t.get_image()
		if img != null:
			if img.is_compressed(): img.decompress()
			var used := img.get_used_rect()
			if used.size.x > 0 and used.size.y > 0 and used.size != img.get_size(): img = img.get_region(used)
			var k := float(px) / float(maxi(img.get_width(), img.get_height()))
			if k < 1.0: img.resize(maxi(1, int(round(img.get_width() * k))), maxi(1, int(round(img.get_height() * k))), Image.INTERPOLATE_CUBIC)
			out = ImageTexture.create_from_image(img)
	_icons[ck] = out
	return out

## A small picture with its colours shifted (the bronze coin is the gold coin, browner and darker): hue moved by `hue` (0..1),
## saturation and brightness multiplied. Made once and kept; null when the picture is missing.
static func shifted(folder: String, key: String, hue: float, sat := 1.0, val := 1.0, px := 64) -> Texture2D:
	var ck := "shift|%s|%s|%.3f|%.3f|%.3f|%d" % [folder, key, hue, sat, val, px]
	if _icons.has(ck): return _icons[ck]
	var base := icon(folder, [key], px)
	var out: Texture2D = base
	if base != null:
		var img: Image = base.get_image()
		if img != null:
			img = img.duplicate()
			if img.is_compressed(): img.decompress()
			img.convert(Image.FORMAT_RGBA8)
			for y in range(img.get_height()):
				for x in range(img.get_width()):
					var c := img.get_pixel(x, y)
					if c.a <= 0.0: continue
					img.set_pixel(x, y, Color.from_hsv(fposmod(c.h + hue, 1.0), clampf(c.s * sat, 0.0, 1.0), clampf(c.v * val, 0.0, 1.0), c.a))
			out = ImageTexture.create_from_image(img)
	_icons[ck] = out
	return out

static func clear_cache() -> void:
	_cache.clear()
	_icons.clear()
