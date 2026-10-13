extends RefCounted
## Trade: the market, demand and prices, selling, seeds, merchants and barter. (Kit to be: items & trade.)
## Split out of game.gd in R4 (12 Oct 2026). Everything else of the game is reached through G, the front door
## (the Game autoload), which still answers to every function name, so callers did not change.

var G

## Recently sold units per item: the market pays less for lots of the same thing (meta.market) and forgets a little
## every question, so selling many different things pays best.
func market_sold() -> Dictionary:
	if not G.S.has("market"): G.S["market"] = {}
	return G.S["market"]

## Share of the full price the market pays for the next one (1.0 = full price).
func demand_factor(k: String, extra := 0.0) -> float:
	var mk: Dictionary = G.meta.get("market", {})
	if mk.is_empty(): return 1.0
	var over = float(G.market_sold().get(k, 0.0)) + extra - float(mk.get("fullPrice", 6)) + 1.0
	if over <= 0.0: return 1.0
	return maxf(float(mk.get("floor", 0.5)), 1.0 - float(mk.get("dropPerUnit", 0.1)) * over)

func full_price(k: String) -> float:
	return G.value_of(k) * (1.0 + G.g("sellBonusPct", 0.0) / 100.0)

## What the next one would sell for right now.
func sell_price(k: String) -> float:
	return G.full_price(k) * G.demand_factor(k)

## What n of them would bring together right now (the market pays less after the first few of the same thing).
func sell_total(k: String, n: int) -> float:
	var t := 0.0
	for i in range(n): t += G.full_price(k) * G.demand_factor(k, float(i))
	return t

func sell(k: String, q: float) -> bool:
	var n = minf(q, floorf(G.count(k) + 0.0001))
	if n < 1.0 or not G.sellable(k): return false
	G.take(k, n)
	var got := 0.0
	for i in range(int(n)):
		got += G.sell_price(k)
		G.market_sold()[k] = float(G.market_sold().get(k, 0.0)) + 1.0
	G.S["coins"] += got
	G._job("sell", k, n)
	var msg = tr("🪙 Sold %d %s for 🪙%d") % [int(n), G.iname(k), int(floorf(got + 0.0001))]
	if G.demand_factor(k) < 0.999: msg += tr(". The market has plenty of %s now — it pays less for a while. Different things sell best!") % G.iname(k)
	G.say(msg)
	G.perk_event("sell", {"item": k, "n": n, "coins": got})
	G.sold.emit(k, n, got)
	G.save_game(); G.changed.emit()
	return true

func _tick_market() -> void:
	var mk: Dictionary = G.meta.get("market", {})
	for k in G.market_sold().keys():
		var sold = float(G.market_sold()[k])
		G.market_sold()[k] = sold - maxf(float(mk.get("recoverPerQuestion", 1.0)), sold * float(mk.get("recoverShare", 0.0)))
		if float(G.market_sold()[k]) <= 0.0: G.market_sold().erase(k)

## What the inputs of a recipe would fetch at the market, and what its outputs fetch (full prices; things nobody buys count 0).
func recipe_worth(rid: String) -> Vector2:
	var r: Dictionary = G.recipes[rid]
	var a := 0.0
	for k in r["inputs"]:
		var q := float(r["inputs"][k])
		if k.begins_with("tag:"):
			var opts = G.tag_choices(k.substr(4))
			if not opts.is_empty(): a += G.value_of(opts[0]) * q
		elif G.sellable(k): a += G.value_of(k) * q
	var b := 0.0
	for k in r["outputs"]:
		if G.sellable(k): b += G.value_of(k) * float(r["outputs"][k]) * G.m("out:" + r["station"])
	return Vector2(a, b)

func buy_seeds(cid: String, q: int) -> bool:
	var c = float(G.nodes[cid].get("seedCost", 0)) * q
	if G.S["coins"] + 0.0001 < c: G.say(tr("🪙 Not enough coins.")); return false
	G.S["coins"] -= c
	G.S["seeds"][cid] = float(G.S["seeds"].get(cid, 0.0)) + q
	if G.roll(G._event("seed_bargain")): G.S["seeds"][cid] = float(G.S["seeds"][cid]) + 1.0; G.say(tr("🎁 The seed merchant adds one for free."))
	G.save_game(); G.changed.emit()
	return true

func buy_item(merchant: String, k: String, q: int) -> bool:
	var price = float(G.nodes[merchant].get("sells", {}).get(k, 0)) * q
	if G.S["coins"] + 0.0001 < price: G.say(tr("🪙 Not enough coins.")); return false
	G.S["coins"] -= price
	G._buying = true
	G.add_item(k, q)
	G._buying = false
	G.save_game(); G.changed.emit()
	return true

func barter(merchant: String, k: String) -> bool:
	var b: Dictionary = G.nodes[merchant].get("barter", {}).get(k, {})
	var c := {}
	for x in b: c[x] = float(b[x])
	if not G.pay(c): G.say(tr("Missing what the trader wants.")); return false
	var q = float(G.nodes[merchant].get("barterGives", {}).get(k, 1))
	G._buying = true
	G.add_item(k, q)
	G._buying = false
	G.say(tr("🤝 Traded for %s%s %s") % ["%d × " % int(q) if q > 1.0 else "", G.iemoji(k), G.iname(k)])
	G.save_game(); G.changed.emit()
	return true
