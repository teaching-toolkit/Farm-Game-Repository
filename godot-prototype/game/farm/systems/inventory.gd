extends RefCounted
class_name FarmInventory
## The store: what the farm holds (batches that remember the season they came in), putting things in and taking them out,
## tags, selling values, shelf life. Passive producers (woodlot, pets) fill it every step.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"inv": {}, "seen": {}}

# ------------------------------------------------------------------ inventory

func count(k: String) -> float:
	var t := 0.0
	for b in G.S["inv"].get(k, []): t += float(b[1])
	return t

func count_tag(t: String) -> float:
	var s := 0.0
	for k in G.tags.get(t, []): s += count(k)
	return s

func have(k: String) -> float:
	if k.begins_with("tag:"): return count_tag(k.substr(4))
	if k == "coins": return G.S["coins"]
	if k == "energy": return G.S["energy"]
	if k == "water": return G.S["water"]
	return count(k)

## Puts q of an item into the store (what does not fit is told to the map). A graded item (G.quality.graded) comes in at `grade`
## (-1: Proper); batches of the same season and grade merge. Returns what went in.
func add_item(k: String, q: float, quiet := false, grade := -1) -> float:
	if q <= 0.0 or not G.items.has(k): return 0.0
	var cap := G.needs.storage_cap()
	var room := cap - count(k)
	var put := q if (G.items[k].get("category", "") in ["keeper"]) else minf(q, maxf(0.0, room))
	if put < q - 0.001:
		G.overflow[k] = float(G.overflow.get(k, 0.0)) + q - put
		if not quiet: G.say(tr("🧺 Storage full: %d %s didn't fit. (Bigger store = more room.)") % [G.up(q - put), G.iname(k)])
	if put <= 0.0: return 0.0
	if not G.buying: G.produced += put * G.pace.flex_worth(k)
	if not G.S["inv"].has(k): G.S["inv"][k] = []
	var arr: Array = G.S["inv"][k]
	var sn := G.seasons.season_no()
	var gr := -1
	if G.quality.graded(k): gr = G.quality.default_grade() if grade < 0 else clampi(grade, 0, G.quality.max_grade())
	var merged := false
	for b in arr:
		if int(b[0]) == sn and (gr < 0 or batch_grade(b) == gr):
			b[1] = float(b[1]) + put
			merged = true
			break
	if not merged: arr.append([sn, put] if gr < 0 else [sn, put, gr])
	G.S["seen"][k] = true
	return put

## Tells the map what arrived (and what bounced off a full store).
func emit_gained(source: String, got: Dictionary) -> void:
	var lost := G.overflow
	G.overflow = {}
	G.gained.emit(source, got, lost)

func take(k: String, q: float) -> bool:
	if q <= 0.0: return true
	if k.begins_with("tag:"): return take_tag(k.substr(4), q)
	if k == "coins":
		if G.S["coins"] + 0.0001 < q: return false
		G.S["coins"] -= q; return true
	if count(k) + 0.0001 < q: return false
	var arr: Array = G.S["inv"][k]
	if G.quality.graded(k): _sort_for_use(arr)
	var left := q
	while left > 0.00001 and arr.size() > 0:
		var b = arr[0]
		var use := minf(float(b[1]), left)
		if not _track.is_empty() and G.quality.graded(k):
			_track["n"] = float(_track["n"]) + use
			_track["sum"] = float(_track["sum"]) + use * float(batch_grade(b))
		b[1] = float(b[1]) - use
		left -= use
		if float(b[1]) <= 0.00001: arr.pop_front()
	if arr.is_empty(): G.S["inv"].erase(k)
	return true

# ------------------------------------------------------------------ grades (TODO Y1)

## The grade of one batch ([season, qty] or [season, qty, grade]); a batch without one is Proper.
func batch_grade(b: Array) -> int:
	return int(b[2]) if b.size() > 2 else G.quality.default_grade()

## Oldest season first (it goes stale first), within a season the lowest grade first (the good ones are kept for selling).
func _sort_for_use(arr: Array) -> void:
	arr.sort_custom(func(a, b):
		if int(a[0]) != int(b[0]): return int(a[0]) < int(b[0])
		return batch_grade(a) < batch_grade(b))

## How many of an item there are of each grade: {grade: qty}.
func grades(k: String) -> Dictionary:
	var out := {}
	for b in G.S["inv"].get(k, []):
		var g := batch_grade(b)
		out[g] = float(out.get(g, 0.0)) + float(b[1])
	return out

## How many there are of a grade or better.
func count_min(k: String, grade: int) -> float:
	var t := 0.0
	for b in G.S["inv"].get(k, []):
		if batch_grade(b) >= grade: t += float(b[1])
	return t

## The grades of the next n whole units to sell, best first (what sell_total and sell go by).
func best_first(k: String, n: int) -> Array:
	var gs := grades(k)
	var order := gs.keys()
	order.sort()
	order.reverse()
	var out := []
	for g in order:
		for _i in range(int(floorf(float(gs[g]) + 0.0001))):
			if out.size() >= n: return out
			out.append(g)
	return out

## Takes n whole units, the best grade first (selling). Returns their grades.
func take_best(k: String, n: int) -> Array:
	var picked := best_first(k, n)
	var arr: Array = G.S["inv"].get(k, [])
	for g in picked:
		for b in arr:
			if batch_grade(b) == g and float(b[1]) > 0.00001:
				b[1] = float(b[1]) - 1.0
				break
	var keep := []
	for b in arr:
		if float(b[1]) > 0.00001: keep.append(b)
	if keep.is_empty(): G.S["inv"].erase(k)
	elif G.S["inv"].has(k): G.S["inv"][k] = keep
	return picked

## What taking q of an item (or of a kind: "tag:…") would use up: Vector2(units, sum of their grades). Nothing is taken.
func peek_grades(k: String, q: float) -> Vector2:
	if not k.begins_with("tag:"):
		if not G.quality.graded(k): return Vector2.ZERO
		var arr: Array = G.S["inv"].get(k, []).duplicate(true)
		_sort_for_use(arr)
		var left := q
		var n := 0.0
		var sum := 0.0
		for b in arr:
			if left <= 0.00001: break
			var use := minf(float(b[1]), left)
			n += use; sum += use * float(batch_grade(b)); left -= use
		return Vector2(n, sum)
	var left2 := q
	var v := Vector2.ZERO
	for item in tag_choices(k.substr(4)):
		var h := count(item)
		if h <= 0.0: continue
		var use2 := minf(h, left2)
		v += peek_grades(item, use2)
		left2 -= use2
		if left2 <= 0.00001: break
	return v

var _track := {}      # while a recipe pays for its inputs: how many graded units were used and their grades added up

## Starts counting the grades of what is taken (a recipe's inputs) …
func start_track() -> void:
	_track = {"n": 0.0, "sum": 0.0}

## … and ends it: the average grade of what was used, or -1 when nothing graded was.
func stop_track() -> float:
	var avg := -1.0
	if float(_track.get("n", 0.0)) > 0.0: avg = float(_track["sum"]) / float(_track["n"])
	_track = {}
	return avg

func tag_choices(t: String) -> Array:
	var c: Array = G.tags.get(t, []).duplicate()
	c.sort_custom(func(a, b): return float(G.items[a].get("value", 0)) < float(G.items[b].get("value", 0)))
	return c

func take_tag(t: String, q: float) -> bool:
	if count_tag(t) + 0.0001 < q: return false
	var left := q
	for k in tag_choices(t):
		var h := count(k)
		if h <= 0.0: continue
		var use := minf(h, left)
		take(k, use); left -= use
		if left <= 0.00001: break
	return true

## Can it be sold at the market? (Items with "noSell" — straw — are not wanted by anyone.)
func sellable(k: String) -> bool:
	return value_of(k) > 0.0 and not G.items.get(k, {}).get("noSell", false)

func value_of(k: String) -> float:
	return float(G.items.get(k, {}).get("value", 0))

func shelf_life(k: String) -> int:
	var f = G.meta.get("freshness", {})
	if f.is_empty(): return -1
	var sl = f.get("shelfLife", {})
	var life := int(sl.get("default", -1))
	if sl.get("items", {}).has(k): life = int(sl["items"][k])
	elif G.items.get(k, {}).get("category", "") == "dish": life = int(sl.get("dishExceptions", {}).get(k, sl.get("dishes", 1)))
	if life < 0: return -1
	return life + int(round(G.g("shelfLife", 0.0)))

func stale_soon(k: String) -> float:
	var life := shelf_life(k)
	if life < 0: return 0.0
	var t := 0.0
	for b in G.S["inv"].get(k, []):
		if G.seasons.season_no() - int(b[0]) >= life: t += float(b[1])
	return t

# ------------------------------------------------------------------ weight (TODO M4)

## The weight class of an item, "feather" … "heavy" (rules/45-weight.json: the item's own entry, else its category's).
func weight_class(k: String) -> String:
	var w: Dictionary = G.meta.get("weights", {})
	if w.get("items", {}).has(k): return str(w["items"][k])
	return str(w.get("byCategory", {}).get(str(G.items.get(k, {}).get("category", "")), "normal"))

## What one of it weighs, in load units (a normal thing is 1). Works from the start; shown and limited from the first market trip on.
func weight_of(k: String) -> float:
	return float(G.meta.get("weights", {}).get("classes", {}).get(weight_class(k), 1.0))

## What one seed weighs.
func seed_weight() -> float:
	var w: Dictionary = G.meta.get("weights", {})
	return float(w.get("classes", {}).get(str(w.get("seed", "feather")), 0.1))

## What n of an item weigh together.
func load_of(k: String, n: float) -> float:
	return weight_of(k) * n

## Everything in the store and every seed, in load units.
func total_load() -> float:
	var t := 0.0
	for k in G.S["inv"]: t += load_of(k, count(k))
	for c in G.S["seeds"]: t += seed_weight() * float(G.S["seeds"][c])
	return t

# ------------------------------------------------------------------ one Time Quiz answer

## Passive producers (woodlot, pets).
func step_producers(_info: Dictionary) -> void:
	for k in G.caps()["produces"]:
		add_item(k, float(G.caps()["produces"][k]), true)
