extends RefCounted
class_name FarmReveal
## What is shown when (TODO O1–O3, design document §13.2): the engine runs from the start, but a button, a bar or a number appears
## only when the game says so (data/farm/rules/60-reveal.json). Once shown, always shown (S["revealed"]). An id that is not listed
## there is always shown. The conditions are the kit's language (kits/core/conditions.gd).

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"revealed": {}}

func rules() -> Dictionary:
	return G.meta.get("reveal", {}).get("elements", {})

## Is this part of the interface (or this system's numbers) shown yet? The first time its condition holds it is shown for good,
## and the interface is told (G.revealed) so it can say "New: …".
func shown(id: String) -> bool:
	var r: Dictionary = rules().get(id, {})
	if r.is_empty() or G.S["revealed"].has(id): return true
	if not G.cond_all(r.get("when", [])): return false
	G.S["revealed"][id] = true
	G.revealed.emit(id)
	return true

## A farm that was just loaded or started: everything whose condition already holds counts as shown, without a fuss.
func settle() -> void:
	for id in rules():
		if not G.S["revealed"].has(id) and G.cond_all(rules()[id].get("when", [])): G.S["revealed"][id] = true

## One step of time: things that appear with time or with what was done come out now, even if nobody looks at the screen.
func step(_info: Dictionary) -> void:
	for id in rules(): shown(id)
