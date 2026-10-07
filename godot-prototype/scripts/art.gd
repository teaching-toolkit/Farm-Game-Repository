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
##
## Uses ResourceLoader so it also works in exported builds (web, iPad), where the original PNG files are not shipped.

const ROOT := "res://assets/"
static var _cache := {}

static func tex(folder: String, key: String) -> Texture2D:
	var path := ROOT + folder + "/" + key + ".png"
	if _cache.has(path): return _cache[path]
	var t: Texture2D = null
	if ResourceLoader.exists(path):
		t = load(path) as Texture2D
	_cache[path] = t
	return t

static func first(folder: String, keys: Array) -> Texture2D:
	for k in keys:
		if str(k) == "": continue
		var t := tex(folder, str(k))
		if t != null: return t
	return null

static func clear_cache() -> void:
	_cache.clear()
