extends RefCounted
class_name FarmTrade
## Selling and buying: market demand and prices, seeds, merchants, barter, and eating.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"sold_kinds": {}, "market": {}}

# ------------------------------------------------------------------ market, food

## Recently sold units per item: the market pays less for lots of the same thing (meta.market) and forgets a little
## every question, so selling many different things pays best.
func market_sold() -> Dictionary:
	if not G.S.has("market"): G.S["market"] = {}
	return G.S["market"]

## Share of the full price the market pays for the next one (1.0 = full price).
func demand_factor(k: String, extra := 0.0) -> float:
	var mk: Dictionary = G.meta.get("market", {})
	if mk.is_empty(): return 1.0
	var over := float(market_sold().get(k, 0.0)) + extra - float(mk.get("fullPrice", 6)) + 1.0
	if over <= 0.0: return 1.0
	return maxf(float(mk.get("floor", 0.5)), 1.0 - float(mk.get("dropPerUnit", 0.1)) * over)

## What one unit of a grade would fetch before the market's demand: the item's value × the grade's price factor × the sell bonus.
func full_price(k: String, grade := -1) -> float:
	var f := 1.0
	if G.quality.graded(k): f = G.quality.price_factor(G.quality.default_grade() if grade < 0 else grade)
	return G.inventory.value_of(k) * f * (1.0 + G.g("sellBonusPct", 0.0) / 100.0)

## What the next one would sell for right now (the best grade goes first).
func sell_price(k: String) -> float:
	var gs := G.inventory.best_first(k, 1)
	return full_price(k, int(gs[0]) if gs.size() > 0 else -1) * demand_factor(k)

## What n of them would bring together right now (best grade first; the market pays less after the first few of the same thing).
func sell_total(k: String, n: int) -> float:
	var gs := G.inventory.best_first(k, n)
	var t := 0.0
	for i in range(n):
		t += full_price(k, int(gs[i]) if i < gs.size() else -1) * demand_factor(k, float(i))
	return t

## Selling, buying and bartering happen on the village square (a trip, G.trip), with what is in the bag.
func _at_square() -> bool:
	if G.trip.at_square(): return true
	G.say(tr("🏘️ That is done in the village: pack your bag and go."))
	return false

func sell(k: String, q: float) -> bool:
	if not _at_square(): return false
	var n := minf(q, floorf(G.trip.packed(k) + 0.0001))
	if n < 1.0 or not G.inventory.sellable(k): return false
	return _sell_units(k, n, 1.0)

## Sells n whole units to the travelling merchant at the gate (no trip, no packing): the village price less his cut, as much as his cart takes.
func sell_gate(k: String, q: float) -> bool:
	if not G.gate.here():
		G.say(tr("🛒 The merchant is not here."))
		return false
	var n := minf(q, float(G.gate.can_take(k)))
	if n < 1.0 or not G.gate.wants(k): return false
	if _sell_units(k, n, float(G.gate.data().get("cut", 0.85))):
		G.gate.put_in_cart(G.inventory.load_of(k, n))
		return true
	return false

## The selling itself: the best grade first, the market pays less for a pile of the same thing; `cut` is what a middleman keeps back.
func _sell_units(k: String, n: float, cut: float) -> bool:
	var gs := G.inventory.take_best(k, int(n))
	var got := 0.0
	for i in range(int(n)):
		got += full_price(k, int(gs[i]) if i < gs.size() else -1) * demand_factor(k) * cut
		market_sold()[k] = float(market_sold().get(k, 0.0)) + 1.0
	G.S["coins"] += got
	if cut >= 0.999: G.trip.sold(k, n)
	G.rewards.job_progress("sell", k, n)
	var msg := tr("🪙 Sold %d %s for %s") % [int(n), G.iname(k), G.money(got)]
	if demand_factor(k) < 0.999: msg += tr(". The market has plenty of %s now — it pays less for a while. Different things sell best!") % G.iname(k)
	G.say(msg)
	G.rewards.perk_event("sell", {"item": k, "n": n, "coins": got})
	G.sold.emit(k, n, got)
	G.save_game(); G.changed.emit()
	return true

func tick_market(_info := {}) -> void:
	var mk: Dictionary = G.meta.get("market", {})
	for k in market_sold().keys():
		var sold := float(market_sold()[k])
		market_sold()[k] = sold - maxf(float(mk.get("recoverPerQuestion", 1.0)), sold * float(mk.get("recoverShare", 0.0)))
		if float(market_sold()[k]) <= 0.0: market_sold().erase(k)

## What the inputs of a recipe would fetch at the market, and what its outputs fetch (full prices; things nobody buys count 0).
func recipe_worth(rid: String) -> Vector2:
	var r: Dictionary = G.recipes[rid]
	var a := 0.0
	for k in r["inputs"]:
		var q := float(r["inputs"][k])
		if k.begins_with("tag:"):
			var opts := G.inventory.tag_choices(k.substr(4))
			if not opts.is_empty(): a += G.inventory.value_of(opts[0]) * q
		elif G.inventory.sellable(k): a += G.inventory.value_of(k) * q
	var b := 0.0
	for k in r["outputs"]:
		if G.inventory.sellable(k): b += G.inventory.value_of(k) * float(r["outputs"][k]) * G.m("out:" + r["station"])
	return Vector2(a, b)

func buy_seeds(cid: String, q: int) -> bool:
	if not _at_square(): return false
	var room := G.trip.can_buy(G.inventory.seed_weight())
	if room < q:
		if room < 1: G.say(tr("🎒 No room to carry that home.")); return false
		q = room
	var c := float(G.nodes[cid].get("seedCost", 0)) * q
	if G.S["coins"] + 0.0001 < c: G.say(tr("🪙 Not enough coins.")); return false
	G.S["coins"] -= c
	G.S["seeds"][cid] = float(G.S["seeds"].get(cid, 0.0)) + q
	G.trip.note_bought(G.inventory.seed_weight() * q)
	if G.rewards.roll(G.rewards.luck_event("seed_bargain")): G.S["seeds"][cid] = float(G.S["seeds"][cid]) + 1.0; G.say(tr("🎁 The seed merchant adds one for free."))
	G.save_game(); G.changed.emit()
	return true

func buy_item(merchant: String, k: String, q: int) -> bool:
	if not _at_square(): return false
	var room := G.trip.can_buy(G.inventory.weight_of(k))
	var shelf := int(floorf(G.needs.storage_cap() - G.inventory.count(k) + 0.0001))      # what the store at home can still take
	if shelf < q:
		if shelf < 1: G.say(tr("🧺 Your store is full of that.")); return false
		q = shelf
	if room < q:
		if room < 1: G.say(tr("🎒 No room to carry that home.")); return false
		q = room
	var price := float(G.nodes[merchant].get("sells", {}).get(k, 0)) * q
	if G.S["coins"] + 0.0001 < price: G.say(tr("🪙 Not enough coins.")); return false
	G.S["coins"] -= price
	G.buying = true
	G.inventory.add_item(k, q)
	G.buying = false
	G.trip.note_bought(G.inventory.weight_of(k) * q)
	G.save_game(); G.changed.emit()
	return true

func barter(merchant: String, k: String) -> bool:
	if not _at_square(): return false
	var b: Dictionary = G.nodes[merchant].get("barter", {}).get(k, {})
	var c := {}
	for x in b: c[x] = float(b[x])
	if not G.pace.pay(c): G.say(tr("Missing what the trader wants.")); return false
	var q := float(G.nodes[merchant].get("barterGives", {}).get(k, 1))
	G.trip.note_bought(G.inventory.weight_of(k) * q)
	G.buying = true
	G.inventory.add_item(k, q)
	G.buying = false
	G.say(tr("🤝 Traded for %s%s %s") % ["%d × " % int(q) if q > 1.0 else "", G.iemoji(k), G.iname(k)])
	G.save_game(); G.changed.emit()
	return true

func eat(k: String) -> bool:
	var b = G.items[k].get("buff", null)
	if b == null or G.inventory.count(k) < 1.0: return false
	G.inventory.take(k, 1.0)
	G.S["buff"] = {"mult": float(b["energy"]), "until": G.S["step"] + int(b["questions"]), "item": k}
	G.say((tr("😋 Yum! Work costs %d%% less energy for %d question.") if int(b["questions"]) == 1 else tr("😋 Yum! Work costs %d%% less energy for %d questions.")) % [int(round((1.0 - float(b["energy"])) * 100)), int(b["questions"])])
	G.save_game(); G.changed.emit()
	return true
