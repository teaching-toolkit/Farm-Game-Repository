extends RefCounted
class_name FarmLord
## The Lord's share (TODO M13): from chapter 3 the farm owes a share at the end of every season, counted on what the Lord assumes the farm
## gives (its patches and its producing buildings, not what it really gave). Pieter the night watchman waits at the gate until it is paid;
## while it is owed nothing can be bought with coins, but selling, making, farming, trips and barter go on. Data: data/farm/rules/53-lord.json.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"lord": {"owed": 0.0, "paid": 0.0, "shares": 0, "last_share": 0.0, "eased": false, "sold_mark": 0.0}}

func data() -> Dictionary:
	return G.meta.get("lord", {})

func _s() -> Dictionary:
	return G.S["lord"]

## Is the farm on the Lord's list yet?
func active() -> bool:
	return G.chapter() >= int(data().get("startChapter", 3))

func owed() -> float:
	return float(_s().get("owed", 0.0))

## Pieter waits at the gate as long as something is owed.
func here() -> bool:
	return owed() > 0.0001

## While something is owed, nothing can be bought with coins.
func blocks_coins() -> bool:
	return here()

## What pay_coins would answer, without paying (for grey buttons and cost checks).
func coin_refusal(amount: float, exempt := false) -> String:
	if not exempt and blocks_coins(): return "lord"
	if float(G.S["coins"]) + 0.0001 < amount: return "coins"
	return ""

## The one way coins leave the purse. Returns "" when paid, else the reason key: "lord" (the share is owed first) or "coins"
## (not enough). The coins fly to the payee (`paid`). The Lord's own share is exempt from the block (`exempt`). Says nothing: the caller words it.
func pay_coins(amount: float, exempt := false) -> String:
	var why := coin_refusal(amount, exempt)
	if why != "": return why
	G.S["coins"] -= amount
	G.paid.emit(amount)
	return ""

func fraction() -> float:
	if bool(_s().get("eased", false)): return float(data().get("easedFraction", 0.1))
	var f: Dictionary = data().get("fraction", {})
	var best := 0.0
	for k in f:
		if int(k) <= G.chapter(): best = maxf(best, float(f[k]))
	return best

## How many patches of this kind count (the ones that can be planted).
func _patches(a: String) -> int:
	if a == "field": return G.progression.plots()
	return G.fields.area(a).size()

## A building or station that produces or processes counts by its level: its place in the chain of upgrades.
func building_level(id: String) -> int:
	var n: Dictionary = G.nodes[id]
	var counts: bool = n.has("effects") and (n["effects"] as Dictionary).has("produces")
	if n["type"] == "station" and (data().get("stationCats", []) as Array).has(str(n.get("cat", ""))): counts = true
	if not counts: return 0
	var lv := 1
	var cur := str(n.get("replaces", ""))
	while cur != "" and lv < 10:
		lv += 1
		cur = str(G.nodes.get(cur, {}).get("replaces", ""))
	return lv

## What the Lord thinks the farm gives in a season.
func assumed() -> float:
	var t := 0.0
	var pv: Dictionary = data().get("patchValue", {})
	for a in ["field", "orchard", "gh"]: t += float(_patches(a)) * float(pv.get(a, 0))
	var levels := 0
	for id in G.S["unlocked"]:
		if not G.nodes.has(id) or G.superseded(id): continue
		levels += building_level(id)
	return t + float(levels) * float(data().get("buildingValue", 0))

## The share for one season, in bronze (rounded to whole 10).
func share_now() -> float:
	if not active(): return 0.0
	return roundf(assumed() * fraction() / 10.0) * 10.0

## What the farm sold since the last season ended (coins).
func sales_last_season() -> float:
	return float(G.S["stats"].get("sold_coins", 0.0)) - float(_s().get("sold_mark", 0.0))

## At the end of a season: the share falls due and Pieter comes to the gate. It is never more than `maxOfSales` of what the farm sold
## in the season that ended (but at least `floor` bronze), so a quiet season costs little.
func season_ended() -> void:
	var s := _s()
	var sales := sales_last_season()
	s["sold_mark"] = float(G.S["stats"].get("sold_coins", 0.0))
	if not active(): return
	var due := share_now()
	due = minf(due, maxf(float(data().get("floor", 200)), roundf(sales * float(data().get("maxOfSales", 0.25)) / 10.0) * 10.0))
	if due <= 0.0: return
	var cap := due * float(data().get("maxSeasons", 2))
	s["owed"] = minf(owed() + due, cap)
	s["last_share"] = due
	s["shares"] = int(s["shares"]) + 1
	G.say(tr("🏮 Pieter the night watchman is at your gate. The Lord's share is due: %s.") % G.money(owed()))

## Pay the Lord's share, all of it or what you have (amount < 0 means as much as possible).
func pay(amount := -1.0) -> bool:
	var o := owed()
	if o <= 0.0001: return false
	var a := minf(o, float(G.S["coins"])) if amount < 0.0 else minf(amount, minf(o, float(G.S["coins"])))
	if a <= 0.0001:
		G.say(tr("🪙 No coins to pay with. Sell something first: selling always works."))
		return false
	pay_coins(a, true)
	var s := _s()
	s["owed"] = maxf(0.0, o - a)
	s["paid"] = float(s["paid"]) + a
	if owed() <= 0.0001:
		s["owed"] = 0.0
		G.say(tr("🏮 Pieter nods, writes in his book and walks off into the dusk."))
	else:
		G.say(tr("🏮 Paid %s. Still owed: %s.") % [G.money(a), G.money(owed())])
	G.save_game(); G.changed.emit()
	return true
