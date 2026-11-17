extends RefCounted
class_name FarmTrodden
## Paths that wear in where the farmer walks (visible-work/08). The map's walker says "the farmer walked over this cell" (`wear`, once per cell
## and walk) and the map's ground asks how worn a cell is (`wear_of`, 0 to the cap) or which cells are worn (`worn`). The cells are the walking
## grid's (a cell is a Vector2i; this system knows nothing of where it lies). A count per cell, kept small: at most `cap * walksForTrack`, every
## change of season each cell forgets `fadePerSeason` walks and a cell at zero is dropped. DRAW ONLY: nothing in the rules reads it, the bot
## never walks, and the save key `trodden` ("x,y" to a count) is sparse: it appears with the first walk, an old save has none.
## Data: data/farm/rules/69-trodden.json.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns: none in a new game (sparse; the key "trodden" is made by the first walk).
func save_defaults() -> Dictionary:
	return {}

func data() -> Dictionary:
	return G.meta.get("trodden", {})

func _num(key: String, fallback: float) -> float:
	return float(data().get(key, fallback))

func _key(cell: Vector2i) -> String:
	return "%d,%d" % [cell.x, cell.y]

## The most walks a cell counts (the cap's share of a full track).
func top() -> int:
	return maxi(1, int(round(_num("cap", 0.85) * _num("walksForTrack", 300.0))))

## The farmer walked over this cell: one more walk on it, up to the cap.
func wear(cell: Vector2i) -> void:
	if not G.S.has("trodden"): G.S["trodden"] = {}
	var t: Dictionary = G.S["trodden"]
	var k := _key(cell)
	t[k] = mini(int(t.get(k, 0)) + 1, top())

## How worn this cell is: 0 (never walked, or forgotten) up to the cap.
func wear_of(cell: Vector2i) -> float:
	var t: Dictionary = G.S.get("trodden", {})
	return minf(float(int(t.get(_key(cell), 0))) / maxf(1.0, _num("walksForTrack", 300.0)), _num("cap", 0.85))

## The cells worn enough to show (from `showFrom`): {Vector2i: wear}.
func worn() -> Dictionary:
	var out := {}
	var t: Dictionary = G.S.get("trodden", {})
	var from := _num("showFrom", 0.12)
	for k in t:
		var p: PackedStringArray = str(k).split(",")
		if p.size() != 2: continue
		var c := Vector2i(int(p[0]), int(p[1]))
		var w := wear_of(c)
		if w >= from: out[c] = w
	return out

## One step of time: at the first step of a new season every cell forgets a few walks; the cells at zero are dropped (and with the last
## one the key is gone again).
func step(info: Dictionary) -> void:
	if not info.get("season", false) or not G.S.has("trodden"): return
	var t: Dictionary = G.S["trodden"]
	var fade := maxi(0, int(_num("fadePerSeason", 6.0)))
	for k in t.keys():
		var n := mini(int(t[k]), top()) - fade
		if n > 0: t[k] = n
		else: t.erase(k)
	if t.is_empty(): G.S.erase("trodden")
