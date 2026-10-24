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
	return {"bag": {}, "trips": 0, "trip": {"phase": "", "bought": 0.0}}

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

# ------------------------------------------------------------------ the trip

## "" at home, "walk" after *Go to the village* (the one Time Quiz question is open or waiting), "square" in the village.
func phase() -> String:
	return str(G.S["trip"].get("phase", ""))

func at_square() -> bool:
	return phase() == "square"

func walking() -> bool:
	return phase() == "walk"

## The trip as a chore of the actions system (rules/46-chores.json): the base energy, the errand multiplier (rucksacks, boots …), the rounding up and the
## minimum are in the data; what a better road saves is the amount (a factor on the base) and the requirements and the effect are here. The walk starts
## when the packed bag is confirmed (the interface asks exactly one Time Quiz question; arrive() follows).
func register_chores() -> void:
	G.actions.register("village_trip", _go_effect, _go_requires, _road_factor)

## What a better road saves: `roadSaving` per road level above 1, never below `roadFloor`.
func _road_factor(_who, _args: Dictionary) -> float:
	var e: Dictionary = data().get("energy", {})
	var road := int(round(G.g("roadLevel", 1.0)))
	return maxf(float(e.get("roadFloor", 0.4)), 1.0 - float(e.get("roadSaving", 0.15)) * float(road - 1))

func _go_requires(_who, _args: Dictionary) -> Array:
	if phase() != "": return [{"key": "on_the_way", "text": tr("You are on the way already.")}]
	return []

func _go_effect(_who, _args: Dictionary, _cost: Dictionary) -> Dictionary:
	G.S["trip"] = {"phase": "walk", "bought": 0.0}
	return {"gained": {}}

## The question was answered right at the first try: the village square opens.
func arrive() -> void:
	if phase() != "walk": return
	G.S["trip"] = {"phase": "square", "bought": 0.0}
	G.S["trips"] = int(G.S["trips"]) + 1
	G.save_game(); G.changed.emit()

## Back home: what was not sold stays in the store, the bag is empty again.
func leave() -> void:
	if phase() == "": return
	G.S["trip"] = {"phase": "", "bought": 0.0}
	G.S["bag"] = {}
	G.save_game(); G.changed.emit()

# ------------------------------------------------------------------ in the village

## How many of a thing are in the bag (a kind, "tag:…", counts everything of that kind).
func in_bag(k: String) -> float:
	if not k.begins_with("tag:"): return packed(k)
	var t := 0.0
	for item in G.inventory.tag_choices(k.substr(4)): t += packed(item)
	return t

## Does the bag hold what a cost asks for (coins, energy and water are not in the bag)?
func bag_covers(cost: Dictionary) -> bool:
	for k in cost:
		if k in ["coins", "energy", "water"]: continue
		if in_bag(k) + 0.0001 < float(cost[k]): return false
	return true

## What a cost took from the store leaves the bag too.
func spend_from_bag(cost: Dictionary) -> void:
	for k in cost:
		if k in ["coins", "energy", "water"]: continue
		var left := float(cost[k])
		var keys: Array = [k] if not k.begins_with("tag:") else G.inventory.tag_choices(k.substr(4))
		for item in keys:
			var use := minf(left, float(G.S["bag"].get(item, 0.0)))
			if use <= 0.0: continue
			var rest := float(G.S["bag"][item]) - use
			if rest >= 1.0: G.S["bag"][item] = rest
			else: G.S["bag"].erase(item)
			left -= use
			if left <= 0.0: break

## Sold things leave the bag.
func sold(k: String, n: float) -> void:
	spend_from_bag({k: n})

## The room left for what is bought (the same size as the way there, counted separately).
func buy_room() -> float:
	return maxf(0.0, capacity() - float(G.S["trip"].get("bought", 0.0)))

## How many of an item (or seeds: pass the seed weight) the room left takes.
func can_buy(weight: float) -> int:
	return int(floorf(buy_room() / maxf(weight, 0.01) + 0.0001))

func note_bought(load_units: float) -> void:
	G.S["trip"]["bought"] = float(G.S["trip"].get("bought", 0.0)) + load_units

## Packs what a cost asks for from the store (an order: *pack what it needs*). Whole units of the items; a kind ("tag:…") takes the cheapest first.
func can_pack_cost(cost: Dictionary) -> bool:
	var room_left := room()
	for k in cost:
		if k in ["coins", "energy", "water"]: continue
		var need := ceilf(float(cost[k]) - 0.0001) - in_bag(k)
		if need <= 0.0: continue
		var keys: Array = [k] if not k.begins_with("tag:") else G.inventory.tag_choices(k.substr(4))
		for item in keys:
			if need <= 0.0: break
			var avail := floorf(G.inventory.count(item) + 0.0001) - packed(item)
			var use := minf(avail, need)
			room_left -= use * G.inventory.weight_of(item)
			need -= use
		if need > 0.0: return false
	return room_left >= -0.0001

func pack_cost(cost: Dictionary) -> void:
	if not can_pack_cost(cost): return
	for k in cost:
		if k in ["coins", "energy", "water"]: continue
		var need := int(ceilf(float(cost[k]) - 0.0001) - in_bag(k))
		var keys: Array = [k] if not k.begins_with("tag:") else G.inventory.tag_choices(k.substr(4))
		for item in keys:
			if need <= 0: break
			need -= pack(item, need)

## Tests only: everything in the store is in the bag and the farmer stands on the village square.
func test_square() -> void:
	G.S["trip"] = {"phase": "square", "bought": 0.0}
	for k in G.S["inv"]: G.S["bag"][k] = floorf(G.inventory.count(k))
