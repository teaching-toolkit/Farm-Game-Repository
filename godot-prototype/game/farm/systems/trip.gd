extends RefCounted
class_name FarmTrip
## The bag and the market trip (TODO M5, M6, M11): what is packed, how much the farmer can carry, what a trip costs.
## Packing does not take things out of the store: packed things stay there (marked) and can be unpacked for free; what is not sold
## on the trip simply stays. Data: data/farm/rules/49-trip.json. The trip itself (energy, the one question, the square) is below.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"bag": {}, "trips": 0}

func data() -> Dictionary:
	return G.meta.get("trip", {})

# ------------------------------------------------------------------ the bag

## How many load units the farmer can carry: what fits in the arms, or the best carrying thing owned.
func capacity() -> float:
	var cap := float(data().get("base", 10))
	for id in data().get("devices", {}):
		if G.nodes.has(id) and G.done(id): cap = maxf(cap, float(data()["devices"][id]))
	return cap

## The carrying thing that sets the capacity ("" while it is just the arms).
func device() -> String:
	var best := ""
	var cap := float(data().get("base", 10))
	for id in data().get("devices", {}):
		if G.nodes.has(id) and G.done(id) and float(data()["devices"][id]) > cap:
			cap = float(data()["devices"][id])
			best = id
	return best

## How many of an item are packed (never more than the store holds: eaten or stale things leave the bag by themselves).
func packed(k: String) -> float:
	return minf(floorf(float(G.S["bag"].get(k, 0.0)) + 0.0001), floorf(G.inventory.count(k) + 0.0001))

## Everything packed, as {item: whole units}.
func contents() -> Dictionary:
	var out := {}
	for k in G.S["bag"]:
		var q := packed(k)
		if q >= 1.0: out[k] = q
	return out

## The load of the bag, in load units.
func load_now() -> float:
	var t := 0.0
	for k in contents(): t += G.inventory.load_of(k, packed(k))
	return t

func room() -> float:
	return maxf(0.0, capacity() - load_now())

func is_empty() -> bool:
	return contents().is_empty()

## How many more of an item fit in the bag and are left in the store (whole units).
func can_pack(k: String) -> int:
	var w := G.inventory.weight_of(k)
	if w <= 0.0: return 0
	var left := floorf(G.inventory.count(k) + 0.0001) - packed(k)
	return maxi(0, int(minf(left, floorf(room() / w + 0.0001))))

## Puts up to q of an item into the bag. Returns how many went in.
func pack(k: String, q: int) -> int:
	if not G.items.has(k): return 0
	var n := mini(q, can_pack(k))
	if n <= 0: return 0
	G.S["bag"][k] = packed(k) + n
	G.changed.emit()
	return n

func unpack(k: String, q: int) -> int:
	var n := mini(q, int(packed(k)))
	if n <= 0: return 0
	var left := packed(k) - n
	if left >= 1.0: G.S["bag"][k] = left
	else: G.S["bag"].erase(k)
	G.changed.emit()
	return n

func unpack_all() -> void:
	G.S["bag"] = {}
	G.changed.emit()

## What is packed counts as a share of the store for the little bar under the bag icon.
func fill() -> float:
	var cap := capacity()
	return clampf(load_now() / cap, 0.0, 1.0) if cap > 0.0 else 0.0
