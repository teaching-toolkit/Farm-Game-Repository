extends RefCounted
class_name FarmSkills
## Skills and ranks (TODO Y2): eight families (planting and harvesting, animal tending, cooking and baking, fibre and weaving,
## woodwork and construction, pottery and glass, smithing, healing and preserving). Every batch of a recipe, every planting and harvest
## and every collecting from animals counts one for its family; the batches give a rank (Beginner, Handy, Skilled, Expert, Master),
## and from Skilled on a rank also needs a card, a tool or a station. The numbers are data (data/farm/rules/48-skills.json).
## A rank brings fewer inputs, better chances of a higher grade (G.quality), less energy (Handy and up) and, for Masters, less time.
## Works from the start; shown from the first rank-up (G.reveal element "skills").

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"skills": {}, "skill_rank": {}}

func data() -> Dictionary:
	return G.meta.get("skills", {})

func families() -> Array:
	return data().get("families", {}).keys()

func family_name(f: String) -> String:
	return str(data().get("families", {}).get(f, {}).get("name", f))

func family_emoji(f: String) -> String:
	return str(data().get("families", {}).get(f, {}).get("emoji", ""))

## The family a station's recipes train ("" for none: the field edge, where things are only gathered).
func family_of_station(st: String) -> String:
	var root: String = G.crafting.chain_root(st) if G.nodes.has(st) else st
	return str(data().get("stations", {}).get(root, data().get("stations", {}).get(st, "")))

## The family an energy category trains (plant, harvest, animal).
func family_of_cat(cat: String) -> String:
	return str(data().get("jobs", {}).get(cat, ""))

func batches(f: String) -> int:
	return int(G.S["skills"].get(f, 0))

func ranks() -> Array:
	return data().get("ranks", [])

func rank_name(r: int) -> String:
	return str(ranks()[clampi(r, 0, ranks().size() - 1)].get("name", ""))

## The node a rank's gate asks for in a family ("" if the rank has no gate).
func gate_node(f: String, r: int) -> String:
	var g := str(ranks()[r].get("gate", "")) if r < ranks().size() else ""
	if g == "": return ""
	return str(data().get("gates", {}).get(f, {}).get(g, ""))

func gate_ok(f: String, r: int) -> bool:
	var node := gate_node(f, r)
	return node == "" or G.satisfied(node)

## The rank of a family now: the highest whose batches are done and whose gate (and every gate below) is open.
func rank(f: String) -> int:
	var n := batches(f)
	var r := 0
	for i in range(1, ranks().size()):
		if n < int(ranks()[i].get("batches", 0)) or not gate_ok(f, i): break
		r = i
	return r

## The sum of all ranks (the counter "skill_ranks": the first rank-up shows the skills).
func total_ranks() -> int:
	var t := 0
	for f in families(): t += rank(f)
	return t

func _effect(list: String, f: String) -> float:
	var arr: Array = data().get("effects", {}).get(list, [])
	return float(arr[clampi(rank(f), 0, arr.size() - 1)]) if arr.size() > 0 else 0.0

## What a rank leaves to pay of every input (1.0 = all of it).
func input_mult(f: String) -> float:
	if f == "": return 1.0
	var kind := str(data().get("families", {}).get(f, {}).get("kind", "craft"))
	var arr: Array = data().get("effects", {}).get("inputs", {}).get(kind, [])
	if arr.is_empty(): return 1.0
	return 1.0 - float(arr[clampi(rank(f), 0, arr.size() - 1)])

func energy_mult(f: String) -> float:
	if f == "": return 1.0
	var arr: Array = data().get("effects", {}).get("energy", [])
	return float(arr[clampi(rank(f), 0, arr.size() - 1)]) if arr.size() > 0 else 1.0

func time_mult(f: String) -> float:
	if f == "": return 1.0
	var arr: Array = data().get("effects", {}).get("time", [])
	return float(arr[clampi(rank(f), 0, arr.size() - 1)]) if arr.size() > 0 else 1.0

## What a rank adds to the expected grade (G.quality).
func grade_bonus(f: String) -> float:
	if f == "": return 0.0
	return _effect("grade", f)

# ------------------------------------------------------------------ practice

## One batch (or job) for a family; says so when it brings a new rank.
func practice(f: String) -> void:
	if f == "": return
	G.S["skills"][f] = batches(f) + 1
	check(f)

## Is there a rank the family has newly reached? (Also after a card, tool or station opens a gate.)
func check(f: String) -> void:
	var r := rank(f)
	var was := int(G.S["skill_rank"].get(f, 0))
	if r <= was: return
	G.S["skill_rank"][f] = r
	G.say(tr("🎖️ %s %s: %s") % [tr(rank_name(r)), tr("at %s") % tr(family_name(f)), effects_text(r)])
	G.rank_up.emit(f, r)

## A new game or a loaded farm: the ranks it already has are not announced.
func settle() -> void:
	for f in families(): G.S["skill_rank"][f] = rank(f)

func step(_info: Dictionary) -> void:
	for f in families(): check(f)

## One line on what a rank brings, for the note and the skills list.
func effects_text(r: int) -> String:
	var parts := []
	if r >= 1: parts.append(tr("less energy"))
	if r >= 1: parts.append(tr("fewer things needed"))
	parts.append(tr("better chances of Fancy"))
	if r >= ranks().size() - 1: parts.append(tr("faster"))
	return ", ".join(parts) + "."

## What the next rank of a family still asks for: {"rank", "name", "batches" (still to do), "gate" (a node id still to get or "")}.
func next_step(f: String) -> Dictionary:
	var r := rank(f)
	if r >= ranks().size() - 1: return {}
	var nxt := r + 1
	var need := maxi(0, int(ranks()[nxt].get("batches", 0)) - batches(f))
	var gate := gate_node(f, nxt)
	if gate != "" and G.satisfied(gate): gate = ""
	return {"rank": nxt, "name": rank_name(nxt), "batches": need, "gate": gate}
