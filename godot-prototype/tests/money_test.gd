extends Node
## Money (TODO M1, M2, D3): bronze and gold as text, the purse, old saves, the prices in the data. Rules only.
## Run:  godot --headless --path . res://tests/money_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	_check(G.money(0) == "0 🟤" and G.money(35) == "35 🟤" and G.money(99.9) == "99 🟤", "under a gold: bronze only, whole bronze rounded down")
	_check(G.money(100) == "1 🟡" and G.money(235) == "2 🟡 35 🟤" and G.money(1205) == "12 🟡 5 🟤", "from a gold up: gold and the bronze left over (nothing left: only gold)")
	_check(G.money(35, true) == "0 🟡 35 🟤" and G.money(200, true) == "2 🟡 0 🟤", "both: always gold and bronze")
	_check(G.money_up(34.2) == "35 🟤" and G.money_up(99.5) == "1 🟡", "costs round up")
	# the purse shows bronze only until the child has had a gold, then both
	G.S["coins"] = 40.0
	_check(G.purse_text() == "40 🟤", "a poor farmer: bronze only (%s)" % G.purse_text())
	G.S["coins"] = 250.0
	_check(G.purse_text() == "2 🟡 50 🟤", "250 bronze: 2 🟡 50 🟤")
	G.S["coins"] = 30.0
	_check(G.purse_text() == "0 🟡 30 🟤", "…and from then on both, even with 30 left (%s)" % G.purse_text())
	# old saves: coins become bronze
	var old: Dictionary = {"coins": 12.0}
	G.upgrade_save_v3(old)
	_check(is_equal_approx(float(old["coins"]), 180.0), "an old save's 12 coins are 180 bronze (×15)")
	# a coin cost in the cost rows: cubes of a gold (or of 10 bronze), the sum as words
	var UI = preload("res://kits/ui/ui.gd")
	var have_fn := func(_k): return 0.0
	var emo_fn := func(_k): return "🪙"
	for t in [[225.0, 100.0, "2 🟡 25 🟤"], [60.0, 10.0, "60 🟤"], [12.0, 1.0, "12 🟤"]]:
		var row = UI.cost_row({"coins": t[0]}, {}, have_fn, emo_fn, {}, G.money)
		add_child(row)
		await get_tree().process_frame
		var cb = row.get_child(0).get_child(1)
		_check(cb.num_text == t[2] and cb.unit == t[1], "a cost of %d bronze: cubes of %d, text %s (got %s, unit %d)" % [t[0], t[1], t[2], cb.num_text, cb.unit])
		row.free()
	# the data
	var cur: Dictionary = G.meta.get("currency", {})
	_check(bool(cur.get("rescaled", false)) and int(cur.get("bronzePerGold", 0)) == 100 and int(cur.get("factor", 0)) == 15, "the currency is in the data (100 bronze = 1 gold)")
	_check(G.inventory.value_of("egg") == 65.0 and G.inventory.value_of("carrot") == 30.0 and G.inventory.value_of("bread") == 200.0, "familiar things have realistic prices (egg 65 Rp, carrot 30 Rp, bread 2 Fr)")
	_check(G.inventory.value_of("pizza") <= 1500.0 and G.inventory.value_of("cheese_board") <= 2500.0, "the dishes made from dishes no longer cost the earth (pizza %d, cheese board %d)" % [G.inventory.value_of("pizza"), G.inventory.value_of("cheese_board")])
	# buying to resell never pays: a merchant sells above 1.3 × what the thing is worth
	var bad := []
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		for k in n.get("sells", {}):
			if float(n["sells"][k]) < 1.3 * G.inventory.value_of(k): bad.append("%s sells %s for %d (worth %d)" % [id, k, n["sells"][k], G.inventory.value_of(k)])
	_check(bad.is_empty(), "no merchant sells below 1.3 × the worth %s" % str(bad))
	# a seed costs less than what it brings (the first carrot crop pays)
	var carrot_seed := float(G.nodes["crop_carrot"].get("seedCost", 0))
	_check(carrot_seed > 0.0 and carrot_seed <= 3.0 * G.inventory.value_of("carrot"), "a carrot seed (%d) is cheap against the carrots it gives" % carrot_seed)
	# selling really pays in bronze
	G.S["inv"].clear()
	G.S["coins"] = 0.0
	G.inventory.add_item("egg", 3.0, true)
	G.trip.test_square()
	G.trade.sell("egg", 3.0)
	_check(is_equal_approx(float(G.S["coins"]), 195.0), "three eggs sell for 195 bronze (1 🟡 95 🟤): %s" % G.money(G.S["coins"]))
	print("MONEY %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
