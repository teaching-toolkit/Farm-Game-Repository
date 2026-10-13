extends Node
## The Lord's share (TODO M13): from chapter 3, due at the end of each season, blocks buying with coins until paid, never more than a
## quarter of the season's sales. Rules only.
## Run:  godot --headless --path . res://tests/lord_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var L = G.lord
	_check(not L.active() and L.share_now() == 0.0 and not L.here(), "before chapter 3 the farm is under nobody's eye")
	L.season_ended()
	_check(L.owed() == 0.0, "…and no share falls due")
	for p in ["pet_bunny", "pet_tortoise"]: G.S["unlocked"][p] = true
	G.invalidate_caps()
	_check(G.chapter() == 3 and L.active(), "chapter 3 puts the farm on the list")
	G.S["unlocked"]["clear_thistles"] = true
	G.S["unlocked"]["workbench"] = true
	var a0: float = L.assumed()
	G.S["unlocked"]["kiln"] = true
	_check(L.assumed() > a0, "a kiln (it processes) adds to what the Lord assumes (%d → %d)" % [a0, L.assumed()])
	G.S["unlocked"]["kiln_2"] = true
	_check(is_equal_approx(L.assumed(), a0 + 2.0 * float(L.data()["buildingValue"])), "an upgraded kiln counts by its level (the first kiln no longer counts)")
	# a season ends with good sales: the share is fraction x assumed, below the quarter of the sales
	G.S["stats"]["sold_coins"] = 1000000.0
	var due: float = L.share_now()
	_check(due > 0.0 and is_equal_approx(due, roundf(L.assumed() * L.fraction() / 10.0) * 10.0), "the share is the fraction of the assumed yield (%d)" % due)
	L.season_ended()
	_check(L.here() and is_equal_approx(L.owed(), due) and L.data()["fraction"].has("3"), "Pieter comes to the gate and the share is owed")
	# nothing can be bought with coins while it is owed
	G.S["coins"] = 5000.0
	_check(not G.pace.missing_cost({"coins": 100.0}).is_empty() and G.pace.missing_cost({"coins": 100.0})[0]["key"] == "lord", "a cost in coins is blocked")
	_check(G.pace.missing_cost({"stick": 0.0}).is_empty(), "a cost without coins is not")
	G.trip.test_square()
	_check(not G.trade.buy_seeds("crop_carrot", 1) and not G.trade.buy_item("seed_1", "wheat", 1), "seeds and wares cannot be bought")
	G.inventory.add_item("carrot", 3.0, true)
	G.trip.pack("carrot", 3)
	var c0: float = G.S["coins"]
	_check(G.trade.sell("carrot", 3.0) and G.S["coins"] > c0, "selling goes on")
	# paying: a part, then the rest
	var o: float = L.owed()
	_check(L.pay(100.0) and is_equal_approx(L.owed(), o - 100.0) and L.here(), "paying a part leaves the rest owed")
	G.S["coins"] = 50.0
	_check(L.pay() and is_equal_approx(G.S["coins"], 0.0) and L.here(), "paying what you have")
	_check(not L.pay(), "with no coins there is nothing to pay")
	G.S["coins"] = 1.0e6
	_check(L.pay() and not L.here() and L.owed() == 0.0, "paying all sends Pieter home")
	_check(G.pace.missing_cost({"coins": 100.0}).is_empty(), "and buying works again")
	_check(G.counter("lord_paid") > 0.0 and G.counter("lord_shares") == 1.0, "the story can ask about it")
	# a quiet season costs little: at most a quarter of what was sold (or the floor)
	G.S["stats"]["sold_coins"] = float(G.S["stats"]["sold_coins"]) + 400.0
	L.season_ended()
	var cap: float = maxf(float(L.data()["floor"]), roundf(400.0 * float(L.data()["maxOfSales"]) / 10.0) * 10.0)
	_check(is_equal_approx(L.owed(), minf(L.share_now(), cap)) and L.owed() <= cap, "after a quiet season the share is at most %d" % cap)
	# unpaid shares pile up, but only to maxSeasons seasons
	for _i in range(5):
		G.S["stats"]["sold_coins"] = float(G.S["stats"]["sold_coins"]) + 1000000.0
		L.season_ended()
	_check(L.owed() <= L.share_now() * float(L.data()["maxSeasons"]) + 0.01, "unpaid shares pile up to %d seasons' worth, not more (%d)" % [L.data()["maxSeasons"], L.owed()])
	# the story eases it
	var f0: float = L.fraction()
	G.S["lord"]["eased"] = true
	_check(L.fraction() < f0 or f0 <= float(L.data()["easedFraction"]), "once eased the fraction is lower")
	# an old save without the key gets the defaults
	_check(G.lord.save_defaults().has("lord"), "the save key has defaults")
	print("LORD %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
