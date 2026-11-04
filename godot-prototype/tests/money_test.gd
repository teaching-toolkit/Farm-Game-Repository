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
	# a coin cost in the cost rows: one cube per gold from a gold, per bronze below (no "×10": interface-feel/05), the sum as words
	var UI = preload("res://kits/ui/ui.gd")
	var have_fn := func(_k): return 0.0
	var emo_fn := func(_k): return "🪙"
	for t in [[225.0, 100.0, "2 🟡 25 🟤"], [60.0, 1.0, "60 🟤"], [12.0, 1.0, "12 🟤"]]:
		var row = UI.cost_row({"coins": t[0]}, {}, have_fn, emo_fn, {}, G.money)
		add_child(row)
		await get_tree().process_frame
		var cb = row.get_child(0).get_child(1)
		_check(cb.num_text == t[2] and cb.unit == t[1], "a cost of %d bronze: cubes of %d, text %s (got %s, unit %d)" % [t[0], t[1], t[2], cb.num_text, cb.unit])
		row.free()
	# interface-feel/07: 1000 gold = 1 diamond; coins stay counted in bronze, the split is only how they are shown
	_check(G.coins_split(0) == [0, 0, 0] and G.coins_split(235) == [0, 2, 35] and G.coins_split(99999.9) == [0, 999, 99], "split under a diamond: gold and bronze, rounded down")
	_check(G.coins_split(100000) == [1, 0, 0] and G.coins_split(123456) == [1, 234, 56] and G.coins_split(250000) == [2, 500, 0], "from 1000 gold: diamonds, then gold, then bronze")
	_check(G.money(100000) == "1 💎" and G.money(123456) == "1 💎 234 🟡 56 🟤" and G.money(100050) == "1 💎 50 🟤" and G.money(100000, true) == "1 💎 0 🟡 0 🟤", "diamonds as text (%s, %s)" % [G.money(123456), G.money(100050)])
	_check(G.money_up(99999.2) == "1 💎" and G.money(99999.9) == "999 🟡 99 🟤", "costs round up to the next diamond, stocks down")
	G.S["coins"] = 123456.0
	_check(G.purse_text() == "1 💎 234 🟡 56 🟤" and is_equal_approx(float(G.S["coins"]), 123456.0), "the purse with a diamond; the coins stay bronze")
	var purse = UI.Purse.new()
	add_child(purse)
	await get_tree().process_frame
	var rows_seen := []
	for t2 in [[0.0, ["bronze"]], [40.0, ["bronze"]], [200.0, ["gold"]], [235.0, ["gold", "bronze"]], [100000.0, ["diamond"]], [123456.0, ["diamond", "gold", "bronze"]]]:
		purse.set_coins(G.coins_split(t2[0]))
		rows_seen.append(purse.rows_shown())
		_check(purse.rows_shown() == t2[1], "the purse with %d bronze shows the rows %s (got %s)" % [t2[0], t2[1], purse.rows_shown()])
	purse.free()
	var row2 = UI.cost_row({"coins": 150000.0}, {}, have_fn, emo_fn, {}, G.money)
	add_child(row2)
	await get_tree().process_frame
	var cb2 = row2.get_child(0).get_child(1)
	_check(cb2.unit == 100000.0 and cb2.num_text == "1 💎 500 🟡", "a cost of 1500 gold: cubes of a diamond (got unit %d, %s)" % [cb2.unit, cb2.num_text])
	row2.free()
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
