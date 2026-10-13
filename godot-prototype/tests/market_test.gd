extends Node
## Trust, reputation and season prices (TODO M8, M12). Rules only.
## Run:  godot --headless --path . res://tests/market_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var T = G.trust
	_check(T.reputation() == 0 and T.level("seed_1") == 0 and is_equal_approx(T.price_factor("seed_1"), 1.0), "at first nobody trusts the farm: the list price")
	G.S["goals"] = 30
	_check(T.reputation() == 2, "30 main goals done: the village is warming (level %d)" % T.reputation())
	var f0: float = T.price_factor("seed_1")
	_check(f0 < 1.0 and f0 >= float(T.data()["floor"]), "…and prices drop a little (%.2f)" % f0)
	G.S["unlocked"]["d_porridge"] = true
	_check(T.level("seed_1") == 1 and T.price_factor("seed_1") < f0, "a good turn for a trader raises their trust and lowers their prices")
	G.S["goals"] = 9999
	for d in ["d_porridge", "present_onion", "d_veg_soup", "present_lettuce", "present_beet", "d_stone_soup", "d_hearty_stew", "d_bread"]: G.S["unlocked"][d] = true
	for pid in T.data()["people"]:
		_check(T.price_factor(pid) >= float(T.data()["floor"]) - 0.0001 and T.price_factor(pid) <= 1.0, "%s: the price never goes below the floor or above the list price (%.2f)" % [pid, T.price_factor(pid)])
	_check(T.hearts("seed_2") == "♥♥♡" or T.hearts("seed_2") == "♥♥♥", "hearts for a trader (%s)" % T.hearts("seed_2"))
	# the price paid: buying seeds on the square costs the trusted price
	G.reset_game()
	G.S["goals"] = 30
	G.S["coins"] = 1000.0
	G.S["trip"] = {"phase": "square", "bought": 0.0}
	var list_price := float(G.nodes["crop_carrot"].get("seedCost", 0))
	var c0: float = G.S["coins"]
	G.trade.buy_seeds("crop_carrot", 2)
	var paid: float = c0 - G.S["coins"]
	_check(paid < 2.0 * list_price and paid > 1.5 * list_price, "two seeds cost less than the list price (%.1f of %.1f)" % [paid, 2.0 * list_price])
	# season prices: spring is the list price; winter pays more for crops; the news line says so
	G.reset_game()
	_check(is_equal_approx(G.trade.season_factor("carrot", "spring"), 1.0) and is_equal_approx(G.trade.season_factor("egg", "spring"), 1.0), "spring: the list price for the familiar things")
	_check(G.trade.season_factor("carrot", "winter") > 1.1 and G.trade.season_factor("carrot", "summer") < 1.0, "carrots pay more in winter and less in summer")
	var lines := []
	G.toast.connect(func(t): lines.append(t))
	G.trade.season_news("winter")
	_check(lines.size() == 1 and lines[0].contains("🪙"), "a news line at the change of season (%s)" % str(lines))
	# the price follows the season
	G.S["inv"].clear()
	G.inventory.add_item("carrot", 1.0, true)
	var sp: float = G.trade.full_price("carrot")
	G.S["step"] = G.seasons.season_len() * 3 + 1      # winter
	_check(G.seasons.season() == "winter" and G.trade.full_price("carrot") > sp, "the same carrot sells for more in winter")
	print("MARKET %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
