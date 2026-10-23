extends Node
## Wellbeing (TODO L1–L8, design document 5.1b): six parameters that move towards their targets, a dial on the energy numbers, a drain that
## grows with the load of the farm, a boost after helping. Frozen before chapter 2. Rules only.
## Run:  godot --headless --path . res://tests/well_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var W = G.well
	_check(not W.active() and W.max_mult() == 1.0 and W.rest_mult() == 1.0 and W.drain() == 0.0, "before chapter 2 nothing follows from the parameters")
	var info := {}
	var e0: float = G.S["energy"]
	W.step(info)
	_check(is_equal_approx(G.S["energy"], e0) and not info.has("well_delta"), "…and no question drains anything")
	G.S["unlocked"]["pet_bunny"] = true
	G.invalidate_caps()
	_check(W.active() and G.chapter() == 2, "chapter 2 switches it on")
	for p in W.params(): _check(is_equal_approx(W.value(p), 0.5), "%s starts at 0.5" % p)
	_check(is_equal_approx(W.max_mult(), 1.0) and is_equal_approx(W.rest_mult(), 1.0), "at 0.5 the dial is exactly the base")
	# parameters move towards their targets: slowly down, a little faster up
	var food0: float = W.value("food")
	W.step({})
	_check(W.target("food") < food0 and is_equal_approx(W.value("food"), food0 - float(W.data()["down"])), "food sinks by one step towards a lower target")
	for _i in range(200): W.step({})
	_check(is_equal_approx(W.value("food"), W.target("food")), "…and arrives at its target (%.2f)" % W.value("food"))
	# eating different dishes lifts the target
	var t0: float = W.target("food")
	for k in ["porridge", "bread", "soup", "pancakes"]: W.ate(k)
	_check(is_equal_approx(W.target("food"), t0 + 4.0 * float(W.data()["params"]["food"]["dishes"])), "four different dishes lift the target of food")
	W.ate("porridge")
	_check(W.distinct_dishes() == 4, "the same dish again is no new variety")
	var v0: float = W.value("food")
	W.step({})
	_check(is_equal_approx(W.value("food"), v0 + float(W.data()["up"])), "…and it recovers at the faster rate")
	# a bed lifts sleep's target
	var s0: float = W.target("sleep")
	G.S["unlocked"]["straw_bed"] = true
	G.invalidate_caps()
	_check(W.target("sleep") > s0, "a bed lifts the target of sleep (%.2f → %.2f)" % [s0, W.target("sleep")])
	# the dial
	G.S["well"]["v"]["sleep"] = 1.0
	_check(is_equal_approx(W.rest_mult(), 1.3), "the best sleep gives ×1.3 per Rest answer")
	G.S["well"]["v"]["sleep"] = 0.0
	_check(is_equal_approx(W.rest_mult(), 0.7), "the worst gives ×0.7")
	G.S["well"]["v"]["sleep"] = 0.5
	G.S["well"]["v"]["food"] = 1.0
	G.S["well"]["v"]["strength"] = 1.0
	_check(is_equal_approx(W.max_mult(), 1.3), "food and strength at 1 give ×1.3 on the energy maximum")
	for p in W.params(): G.S["well"]["v"][p] = 0.5
	# the drain follows the load of the farm and the mood
	var load0: float = W.farm_load()
	for aid in ["animal_chicken"]: G.S["animals"][aid]["count"] = 4
	_check(W.farm_load() > load0 and W.farm_load() < 1.0, "animals make the farm busier (%.2f → %.2f)" % [load0, W.farm_load()])
	var d_mid: float = W.drain()
	G.S["well"]["v"]["friends"] = 1.0; G.S["well"]["v"]["calm"] = 1.0; G.S["well"]["v"]["play"] = 1.0
	_check(W.drain() < 0.001 and d_mid > 0.0, "a good mood takes the drain away (%.2f → %.2f)" % [d_mid, W.drain()])
	for p in ["friends", "calm", "play"]: G.S["well"]["v"][p] = 0.0
	G.S["energy"] = G.needs.energy_max()
	var w0: float = G.S["energy"]
	W.step(info)
	_check(float(G.S["energy"]) < w0 and info.has("well_delta") and info["well_delta"] < 0.0, "a bad mood on a busy farm costs energy each question (%.2f)" % info.get("well_delta", 0.0))
	_check(W.drain() <= 1.5 * G.needs.rest_per_answer() + 0.001, "the drain is at most 1.5 right sums' worth")
	G.S["energy"] = 0.0
	W.step({})
	_check(G.S["energy"] == 0.0, "at zero energy the drain stops: no debt")
	# the boost after helping
	for p in ["friends", "calm", "play"]: G.S["well"]["v"][p] = 1.0
	G.S["energy"] = 1.0
	W.helped()
	_check(W.boost() > 0.0, "helping someone starts a boost")
	W.step({})
	_check(float(G.S["energy"]) > 1.0, "…which gives a little energy per question")
	G.S["step"] += 7
	_check(W.boost() == 0.0, "and ends after a few questions")
	# a party: three dishes, energy, a cooldown; the parameters jump
	G.S["inv"].clear()
	G.S["energy"] = 20.0
	for p in W.params(): G.S["well"]["v"][p] = 0.4
	_check(not G.actions.perform("throw_party", G.actions.farmer)["done"] and not G.actions.check("throw_party", G.actions.farmer)["ok"], "a party needs dishes")
	G.inventory.add_item("porridge", 2.0, true)
	G.inventory.add_item("bread", 1.0, true)
	_check(G.actions.check("throw_party", G.actions.farmer)["ok"], "three dishes (of any kind) are enough")
	_check(G.actions.perform("throw_party", G.actions.farmer)["done"] and is_equal_approx(G.S["energy"], 20.0 - float(W.data()["party"]["energy"])), "the party costs energy")
	_check(G.inventory.count("porridge") + G.inventory.count("bread") == 0.0, "…and the three dishes")
	_check(W.value("play") > 0.65 and W.value("friends") > 0.5 and W.boost() > 0.0, "play and friends jump up and there is a boost")
	G.inventory.add_item("bread", 3.0, true)
	_check(not G.actions.check("throw_party", G.actions.farmer)["ok"] and W.party_cooldown_left() > 0, "the next party has to wait")
	G.S["step"] += int(W.data()["party"]["cooldown"]) + 1
	_check(G.actions.check("throw_party", G.actions.farmer)["ok"], "…until the cooldown is over")
	# an invitation and a visit
	G.S["unlocked"]["sq_healer_honey"] = true
	_check(G.rewards.friends().size() >= 1, "a favour done makes a friend")
	G.S["well"]["invite"] = ""
	var got := false
	for _i in range(400):
		W.step({})
		if W.invite() != "": got = true; break
	_check(got, "now and then a friend invites you (%s)" % W.invite())
	G.S["energy"] = 10.0
	var e1: float = G.S["energy"]
	_check(G.actions.perform("visit_friend", G.actions.farmer)["done"] and is_equal_approx(G.S["energy"], e1 - float(W.data()["visit"]["energy"])), "the walk costs energy")
	var scene: String = W.visited()
	_check(scene != "" and not scene.contains("{name}") and W.invite() == "", "the visit has a little scene and the invitation is used up")
	# the face
	for p in W.params(): G.S["well"]["v"][p] = 0.9
	var happy: String = W.face()
	for p in W.params(): G.S["well"]["v"][p] = 0.1
	_check(happy == "😄" and W.face() == "😣", "the face follows the overall mood")
	_check(G.well.save_defaults().has("well"), "the save key has defaults")
	var rows := {}
	for cid in G.card_ids:
		if G.nodes[cid].has("wellRow"): rows[str(G.nodes[cid]["wellRow"])] = cid
	_check(rows.size() == W.params().size(), "every parameter has one card that opens its row (%d)" % rows.size())
	var all_in_book := true
	for p in rows: if not (G.nodes[rows[p]]["requires"] as Array).has("book_body"): all_in_book = false
	_check(all_in_book and G.nodes["book_body"]["type"] == "book", "the cards belong to the book Body and mind")
	print("WELL %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
