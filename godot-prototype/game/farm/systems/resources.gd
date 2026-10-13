extends RefCounted
## Resources: water fetched from the pond with the bucket. (Kit to be: resources; gathering spots join here later.)
## Split out of game.gd in R4 (12 Oct 2026). Everything else of the game is reached through G, the front door
## (the Game autoload), which still answers to every function name, so callers did not change.

var G

## How much one trip to the pond brings (the old bucket: 3; a carrying yoke adds more).
func fetch_amount() -> float:
	return G.g("fetchWater", float(G.meta.get("water", {}).get("fetchBase", 3.0)))

func fetch_cost() -> float:
	return G.ecost("gather", float(G.meta.get("water", {}).get("fetchEnergy", 1.0)))

func fetch_water() -> bool:
	var room = G.water_cap() - float(G.S["water"])
	if room < 0.5: G.say(tr("💧 Your water is full.")); return false
	var e = G.fetch_cost()
	if G.S["energy"] + 0.001 < e: G.say(tr("⚡ Too tired to carry water. Rest a little (tap ⚡).")); return false
	G.S["energy"] -= e
	var q = minf(room, G.fetch_amount())
	G.S["water"] = float(G.S["water"]) + q
	G.S["stats"]["fetch"] = int(G.S["stats"].get("fetch", 0)) + 1
	G._gained("water", {"water": q})
	G.save_game(); G.changed.emit()
	return true

## Water never comes by itself (it is carried); rain waters the fields: planting costs no water this question.
func _step_water(_info: Dictionary) -> void:
	if G.g("waterPerStep", 0.0) > 0.0: G.S["water"] = minf(G.water_cap(), float(G.S["water"]) + G.g("waterPerStep", 0.0))
