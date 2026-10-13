extends RefCounted
class_name FarmGate
## The travelling merchant at the farm's gate (TODO M7): comes now and then (more often with a better road), stays a few questions, buys
## in bulk without a trip and without energy, a little cheaper than the village (his cut). His cart has room for so much and fills as you sell.
## Data: data/farm/rules/50-gate.json.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"gate": {"here": false, "until": 0, "cart": 0.0, "visits": 0}}

func data() -> Dictionary:
	return G.meta.get("gate", {})

func here() -> bool:
	return bool(G.S["gate"].get("here", false))

func road_level() -> int:
	return int(round(G.g("roadLevel", 1.0)))

## The chance that he turns up at the end of a question: only where a cart can come at all, more with a better road.
func arrival_chance() -> float:
	var d := data()
	if road_level() < int(d.get("minRoad", 2)): return 0.0
	return float(d.get("chance", 0.07)) + float(d.get("perRoadLevel", 0.03)) * float(road_level() - int(d.get("minRoad", 2)))

## How much his cart holds, in load units.
func cart_size() -> float:
	var d: Dictionary = data().get("cart", {})
	return float(d.get("base", 30)) + float(d.get("perRoadLevel", 15)) * float(maxi(0, road_level() - 1))

func cart_room() -> float:
	return maxf(0.0, cart_size() - float(G.S["gate"].get("cart", 0.0)))

func fill() -> float:
	return clampf(float(G.S["gate"].get("cart", 0.0)) / maxf(1.0, cart_size()), 0.0, 1.0)

## Does he buy this kind of thing?
func wants(k: String) -> bool:
	return G.inventory.sellable(k) and (data().get("cats", []) as Array).has(str(G.items.get(k, {}).get("category", "")))

## What he pays for the next n: the village price less his cut.
func price(k: String, n := 1) -> float:
	return G.trade.sell_total(k, n) * float(data().get("cut", 0.85))

## How many of an item his cart still takes.
func can_take(k: String) -> int:
	return int(minf(floorf(G.inventory.count(k) + 0.0001), floorf(cart_room() / maxf(0.01, G.inventory.weight_of(k)) + 0.0001)))

func put_in_cart(load_units: float) -> void:
	G.S["gate"]["cart"] = float(G.S["gate"].get("cart", 0.0)) + load_units

## Every question: he leaves when his stay is over; else he may come.
func step(_info := {}) -> void:
	var g: Dictionary = G.S["gate"]
	if here():
		if int(G.S["step"]) >= int(g.get("until", 0)):
			g["here"] = false
			g["cart"] = 0.0
			G.say(tr("🛒 The travelling merchant moved on."))
		return
	if G.rng.randf() < arrival_chance():
		g["here"] = true
		g["cart"] = 0.0
		g["until"] = int(G.S["step"]) + int(data().get("stay", 3))
		g["visits"] = int(g.get("visits", 0)) + 1
		G.say(tr("🛒 The travelling merchant is at your gate! He buys a lot at once — a little cheaper than the village."))
