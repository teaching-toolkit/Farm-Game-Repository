extends Node
## The animals' pens: the fence round a pen (upgrades/02). Three stages: broken at the start (the pen gives about 10 % less), mended (the first
## upgrade: normal), sturdy and painted (the second, which replaces the first: a little more). The same numbers for chickens, cows and sheep; the bees
## have no fence. The numbers are rules/10-farming.json "fence"; the stage comes from the two upgrades (nodes/15-pen-fences.json). Rules only, no screen.
## Run:  godot --headless --path . res://tests/animals_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

## [animal, the product measured (one without a luck event), the feed, the things the mend costs, the things the sturdy upgrade costs]
const PENS := [
	["animal_chicken", "feather", ["wheat", "straw"], ["stick", "rope"], ["stick", "rope", "log"]],
	["animal_cow", "milk", ["clover", "straw"], ["stick", "rope"], ["plank", "rope"]],
	["animal_sheep", "wool", ["clover", "straw"], ["stick", "rope"], ["plank", "nails"]],
]

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	G.meta["moments"]["perStep"] = 100000      # a dozen collections in one step
	for e in G.meta["luck"]["events"]: e["chance"] = 0.0      # no extra egg or fleece to blur the numbers
	var fe: Dictionary = G.meta["fence"]
	var broken := float(fe["broken"])
	var sturdy := 1.0 + float(fe["sturdyBonus"])
	_check(broken > 0.85 and broken < 0.95 and sturdy > 1.02 and sturdy < 1.10, "the numbers are about 10 %% less and a small bonus (%s, %s)" % [broken, sturdy])
	for pen in PENS: _pen(pen, broken, sturdy)
	_bees()
	_old_saves()
	print("ANIMALS %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

## One fenced pen through its three stages: what the pen gives, and the upgrades that move it on.
func _pen(pen: Array, broken: float, sturdy: float) -> void:
	var aid: String = pen[0]
	var item: String = pen[1]
	var A = G.animals
	var up1 := "pen_fence_%s_1" % A.animal_key(aid)
	var up2 := "pen_fence_%s_2" % A.animal_key(aid)
	G.reset_game()
	for id in G.nodes:      # the shears and the like are not what is tested here
		if G.nodes[id]["type"] in ["tool", "building"] and not id.begins_with("pen_fence"): G.S["unlocked"][id] = true
	G.S["unlocked"][aid] = true
	G.invalidate_caps()
	var n: Dictionary = G.nodes[aid]
	var normal: float = float(n["produces"][item]) * 2.0 * G.m("out:" + aid) * float(G.seasons.smod("out", {}).get(aid, 1.0))
	_check(n.get("fenced", false) and G.nodes.has(up1) and G.nodes.has(up2), "%s has a fence and two upgrades for it" % aid)
	_check(A.fence_stage(aid) == 0 and is_equal_approx(A.fence_factor(aid), broken), "%s: a new farm's fence is broken (stage 0, factor %s)" % [aid, A.fence_factor(aid)])
	_check(is_equal_approx(_haul(aid, item, pen[2]), normal * broken), "%s: the broken fence gives 10 %% less (%s of %s)" % [aid, _haul(aid, item, pen[2]), normal])
	# the first upgrade: open now, the second not before it; materials of the chapter, an upgrade nobody has to buy
	_check(G.progression.is_open(up1) and not G.progression.is_open(up2), "%s: the mend is open, the sturdy fence waits for it" % aid)
	_check(G.nodes[up1].get("optional", false) and G.nodes[up2].get("optional", false), "…and neither is on the main path")
	_check(_costs_only(up1, pen[3]) and _costs_only(up2, pen[4]), "%s: the mend costs %s, the sturdy fence %s" % [aid, str(pen[3]), str(pen[4])])
	_check(not _buy(up2), "the sturdy fence cannot be bought before the mend")
	_check(_buy(up1) and G.done(up1), "%s: the mend is bought" % aid)
	_check(A.fence_stage(aid) == 1 and is_equal_approx(A.fence_factor(aid), 1.0), "%s: mended is stage 1, factor 1" % aid)
	_check(is_equal_approx(_haul(aid, item, pen[2]), normal), "%s: a mended fence gives the normal (%s)" % [aid, _haul(aid, item, pen[2])])
	_check(not G.progression.is_open(up1) and G.progression.is_open(up2), "…the sturdy fence is open now, the mend is not offered again")
	_check(_buy(up2) and G.done(up2), "%s: the sturdy fence is bought" % aid)
	_check(A.fence_stage(aid) == 2 and G.superseded(up1) and is_equal_approx(A.fence_factor(aid), sturdy), "%s: sturdy and painted is stage 2 and replaces the mend (factor %s)" % [aid, A.fence_factor(aid)])
	_check(is_equal_approx(_haul(aid, item, pen[2]), normal * sturdy), "%s: a sturdy fence gives a little more (%s)" % [aid, _haul(aid, item, pen[2])])
	_check(not G.progression.is_open(up1) and not G.progression.is_open(up2), "%s: nothing is left to buy at this fence" % aid)

## The bees have no fence: no upgrade for them, no change in what they give, whatever the other pens have.
func _bees() -> void:
	var A = G.animals
	G.reset_game()
	G.meta["moments"]["perStep"] = 100000
	for e in G.meta["luck"]["events"]: e["chance"] = 0.0
	for id in G.nodes:
		if G.nodes[id]["type"] in ["tool", "building"] and not id.begins_with("pen_fence"): G.S["unlocked"][id] = true
	for id in G.nodes: if id.begins_with("pen_fence"): G.S["unlocked"][id] = true
	G.S["unlocked"]["animal_bees"] = true
	G.invalidate_caps()
	_check(not G.nodes["animal_bees"].get("fenced", false), "the bees have no fence")
	for id in G.nodes: if id.begins_with("pen_fence"): _check(not G.nodes[id].get("requires", []).has("animal_bees"), "%s is not a fence upgrade for the bees" % id)
	_check(A.fence_stage("animal_bees") == 0 and is_equal_approx(A.fence_factor("animal_bees"), 1.0), "the bees: factor 1, whatever the fences of the other pens are")
	var n: Dictionary = G.nodes["animal_bees"]
	var normal: float = float(n["produces"]["honeycomb"]) * 2.0 * G.m("out:animal_bees") * float(G.seasons.smod("out", {}).get("animal_bees", 1.0))
	var f: Dictionary = G.fields.area("field")[0]
	f["crop"] = "crop_clover"      # a flowering crop: the bees may be collected from
	_check(is_equal_approx(_haul("animal_bees", "honeycomb", []), normal), "the bees give the normal (%s of %s)" % [_haul("animal_bees", "honeycomb", []), normal])

## A save from before the fences has none of them: every fenced pen is broken; mended and sturdy fences survive a save and a load.
func _old_saves() -> void:
	var A = G.animals
	G.reset_game()
	var old: Dictionary = G.S.duplicate(true)
	old["unlocked"]["animal_chicken"] = true
	old["unlocked"]["animal_cow"] = true
	G.Saves.write("user://animals_test.json", old)
	_check(G.load_game("user://animals_test.json"), "an old save loads")
	for aid in ["animal_chicken", "animal_cow", "animal_sheep"]:
		_check(A.fence_stage(aid) == 0 and is_equal_approx(A.fence_factor(aid), float(G.meta["fence"]["broken"])), "…%s has a broken fence" % aid)
	G.S["unlocked"]["pen_fence_cow_1"] = true
	G.S["unlocked"]["pen_fence_chicken_1"] = true
	G.S["unlocked"]["pen_fence_chicken_2"] = true
	G.invalidate_caps()
	G.save_to("user://animals_test.json")
	G.reset_game()
	_check(G.load_game("user://animals_test.json") and A.fence_stage("animal_chicken") == 2 and A.fence_stage("animal_cow") == 1 and A.fence_stage("animal_sheep") == 0, "the fences a farm has come back from a save (sturdy, mended, broken)")
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://animals_test.json"))

## What two animals of this kind give of `item` at one collection with feed in the store (the pen is clean and ready; nothing else is changed).
func _haul(aid: String, item: String, feed: Array) -> float:
	G.S["animals"][aid] = {"count": 2, "ready": 0, "muck": 0.0}
	G.S["energy"] = G.needs.energy_max()
	G.S["water"] = 50.0
	for k in (feed if not feed.is_empty() else ["wheat", "straw"]): G.inventory.add_item(k, 50.0, true)
	G.S["inv"].erase(item)
	var rep: Dictionary = G.actions.perform("collect_animal", G.actions.farmer, {"aid": aid})
	if not rep["done"]: print("   collecting failed: ", rep["failed"], " ", rep["message"])
	return float(rep["gained"].get(item, 0.0)) if rep["done"] else -1.0

## Does buying this upgrade work (it gets the materials and the energy first)?
func _buy(id: String) -> bool:
	for k in G.nodes[id]["cost"]: G.inventory.add_item(k, 60.0, true)
	G.S["energy"] = G.needs.energy_max()
	if not G.progression.can_unlock(id)["ok"]: return false
	return G.progression.unlock(id)

## The cost of an upgrade is made of these things, and energy: all of them there.
func _costs_only(id: String, things: Array) -> bool:
	var c: Dictionary = G.nodes[id]["cost"]
	var keys := c.keys()
	keys.erase("energy")
	keys.sort()
	var want := things.duplicate()
	want.sort()
	return keys == want and c.has("energy")

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
