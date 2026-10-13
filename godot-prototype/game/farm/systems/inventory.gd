extends RefCounted
class_name FarmInventory
## The store: what the farm holds (batches that remember the season they came in), putting things in and taking them out,
## tags, selling values, shelf life. Passive producers (woodlot, pets) fill it every step.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

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

func add_item(k: String, q: float, quiet := false) -> float:
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
	if arr.size() > 0 and int(arr[arr.size() - 1][0]) == sn:
		arr[arr.size() - 1][1] = float(arr[arr.size() - 1][1]) + put
	else:
		arr.append([sn, put])
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
	var left := q
	while left > 0.00001 and arr.size() > 0:
		var b = arr[0]
		var use := minf(float(b[1]), left)
		b[1] = float(b[1]) - use
		left -= use
		if float(b[1]) <= 0.00001: arr.pop_front()
	if arr.is_empty(): G.S["inv"].erase(k)
	return true

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

# ------------------------------------------------------------------ one Time Quiz answer

## Passive producers (woodlot, pets).
func step_producers(_info: Dictionary) -> void:
	for k in G.caps()["produces"]:
		add_item(k, float(G.caps()["produces"][k]), true)
