extends RefCounted
## Rewards: luck and lucky finds, postcards and gift cards, little jobs, golden acorns, perks. (Kit to be: rewards.)
## Split out of game.gd in R4 (12 Oct 2026). Everything else of the game is reached through G, the front door
## (the Game autoload), which still answers to every function name, so callers did not change.

var G

func luck() -> float:
	var l = G.g("luck", 0.0)
	for pid in G.pet_ids():
		if G.done(pid): l += float(G.farm_animals.get("luckPerPet", 0.05))
	for b in G.S["luck_boosts"]:
		if int(b[1]) > G.S["step"]: l += float(b[0])
	return l

func add_luck(amount: float, questions: int) -> void:
	G.S["luck_boosts"].append([amount, G.S["step"] + questions])

func _event(id: String) -> Dictionary:
	for e in G.meta.get("luck", {}).get("events", []):
		if e["id"] == id: return e
	return {}

func roll(e: Dictionary) -> bool:
	if e.is_empty(): return false
	var ch = e.get("chance", 0.0)
	if typeof(ch) == TYPE_STRING: return false
	return G.rng.randf() < float(ch) * (1.0 + G.luck())

func _weed_luck() -> void:
	if G.roll(G._event("weed_coin")): G.S["coins"] += 2.0; G.say(tr("🪙 A lost coin in the weeds!"))
	if G.roll(G._event("weed_seed")):
		var cs = G.crops_for("field")
		if cs.size() > 0:
			var c: String = cs[G.rng.randi_range(0, cs.size() - 1)]
			if not G.nodes[c].has("seedItem"): G.S["seeds"][c] = float(G.S["seeds"].get(c, 0.0)) + 1.0; G.say(tr("🌱 An old seed packet: +1 %s seed!") % G.nodes[c]["name"])
	if G.roll(G._event("weed_clover")): G.add_luck(0.3, 20); G.say(tr("🍀 A four-leaf clover! You feel lucky."))
	if G.roll(G._event("weed_relic")):
		G.add_item("relic", 1.0); G.S["album"].append({"id": "relic", "text": tr("An old relic you dug up while weeding"), "emoji": "🏺"}); G.say(tr("🏺 Something old in the soil: a relic for the album!"))
	if not G.S["acorns"].has("acorn_lucky") and G.roll(G._event("golden_acorn")):
		G.S["acorns"]["acorn_lucky"] = true; G._dirty(); G.say(tr("🌰✨ A golden acorn glints under a leaf! Energy max +3 for good."))

func _step_neighbour_gift(_info: Dictionary) -> void:
	if G.roll(G._event("neighbour_gift")):
		var opts := []
		for k in G.S["seen"]:
			if G.items.has(k) and G.items[k].get("category", "") in ["crop", "animal", "ingredient"]: opts.append(k)
		if opts.size() > 0:
			var k2: String = opts[G.rng.randi_range(0, opts.size() - 1)]
			G.add_item(k2, 2.0, true); G.say(tr("🧺 A neighbour drops off a little gift basket: %s×2") % G.iemoji(k2))

## Luck boosts that ran out are dropped.
func _step_luck_boosts(_info: Dictionary) -> void:
	var keep := []
	for b in G.S["luck_boosts"]:
		if int(b[1]) > G.S["step"]: keep.append(b)
	G.S["luck_boosts"] = keep

func gift_card(gid: String) -> Dictionary:
	for c in G.meta.get("giftCards", {}).get("pool", []):
		if c["id"] == gid: return c
	return {}

## The people you helped (finished side quests), each person once: [{"name", "emoji", "quest"}].
func friends() -> Array:
	var out := []
	var seen := {}
	for id in G.nodes:
		var n = G.nodes[id]
		if n["type"] != "sidequest" or not G.done(id): continue
		var f: Dictionary = n.get("friend", {})
		var nm := str(f.get("name", n["name"]))
		if seen.has(nm): continue
		seen[nm] = true
		out.append({"name": nm, "emoji": str(f.get("emoji", "💌")), "quest": id})
	return out

## What a friend heard of: "your new bunny", "your library growing", "all your work on the farm (24 jobs done!)".
func _news(kind: String, what := "") -> String:
	var t = str(G.meta.get("postcards", {}).get("news", {}).get(kind, tr("all your work on the farm")))
	return t.replace("{pet}", what).replace("{n}", str(int(G.S["goals"])))

## Something big happened: a friend may hear of it and send a postcard with a gift. The more friends, the likelier,
## and the more gifts to choose from (as many as friends, 3 at most). The very first postcard always comes.
func _offer_gift(news := "") -> void:
	var fr = G.friends()
	if fr.is_empty(): return
	var cfg: Dictionary = G.meta.get("postcards", {})
	var first: bool = G.S.get("postcards", []).is_empty() and G.S["gift_pending"].is_empty()
	var chance := minf(1.0, float(cfg.get("chanceBase", 0.35)) + float(cfg.get("chancePerFriend", 0.2)) * fr.size())
	if not (first and cfg.get("firstSure", true)) and G.rng.randf() > chance: return
	var waiting := []
	for pc in G.S["gift_pending"]: waiting.append_array(pc.get("offer", []))
	var pool := []
	for c in G.meta.get("giftCards", {}).get("pool", []):
		if G.S["gift_owned"].has(c["id"]) or waiting.has(c["id"]): continue
		pool.append(c["id"])
	G.shuffle(pool)
	var offer := pool.slice(0, mini(int(cfg.get("choicesMax", 3)), fr.size()))
	if offer.is_empty(): return
	var f: Dictionary = fr[G.rng.randi_range(0, fr.size() - 1)]
	var msgs: Array = cfg.get("messages", [tr("Dear {player}, I heard about {news}! Here is a little something for your farm.")])
	var text = str(msgs[G.rng.randi_range(0, msgs.size() - 1)])
	text = text.replace("{player}", G.player if G.player != "" else "friend").replace("{news}", news if news != "" else tr("all your work on the farm"))
	text = text.substr(0, 1).to_upper() + text.substr(1)
	G.S["gift_pending"].append({"from": f["name"], "emoji": f["emoji"], "quest": f["quest"], "text": text, "offer": offer, "step": int(G.S["step"])})
	G.say(tr("📬 A postcard from %s!") % f["name"])
	G.offer_cards.emit(offer)

## The postcard waiting to be opened (or {}).
func postcard_pending() -> Dictionary:
	return G.S["gift_pending"][0] if G.S["gift_pending"].size() > 0 else {}

## Takes the gift gid from the first waiting postcard; the postcard goes into the album.
func pick_gift(gid: String) -> void:
	if G.S["gift_pending"].is_empty(): return
	var pc: Dictionary = G.S["gift_pending"].pop_front()
	G.S["gift_owned"].append(gid)
	if not G.S.has("postcards"): G.S["postcards"] = []
	G.S["postcards"].append({"from": pc.get("from", ""), "emoji": pc.get("emoji", "💌"), "quest": pc.get("quest", ""), "text": pc.get("text", ""), "gift": gid,
		"step": int(pc.get("step", G.S["step"]))})
	var c = G.gift_card(gid)
	G.say("💌 %s %s: %s" % [c.get("emoji", ""), c["name"], c.get("desc", "")])
	G._activate_new_gift(gid)
	G._dirty(); G.save_game(); G.changed.emit()

func gift_max() -> int:
	return int(G.meta.get("giftCards", {}).get("maxActive", 2))

func gift_is_active(gid: String) -> bool:
	return G.S.get("gift_active", []).has(gid)

## A new card works at once if there is room; otherwise it waits in the album until it is swapped in.
func _activate_new_gift(gid: String) -> void:
	if not G.S.has("gift_active"): G.S["gift_active"] = []
	if G.S["gift_active"].size() < G.gift_max(): G.S["gift_active"].append(gid)
	else: G.say(tr("🎴 Only %d cards work at a time — the new one waits in your album 🖼️ (swap it in there).") % G.gift_max())

## Put a card to work or let it rest (at most gift_max() work at the same time).
func toggle_gift(gid: String) -> bool:
	if not G.S["gift_owned"].has(gid): return false
	if G.gift_is_active(gid):
		G.S["gift_active"].erase(gid)
	elif G.S["gift_active"].size() >= G.gift_max():
		G.say(tr("🎴 Only %d cards can work at a time: put one to rest first.") % G.gift_max())
		return false
	else:
		G.S["gift_active"].append(gid)
	G._dirty(); G.save_game(); G.changed.emit()
	return true

func _refill_jobs() -> void:
	var jm = G.meta.get("jobs", {})
	var want := int(jm.get("slots", 3))
	var guard := 0
	while G.S["jobs"].size() < want and guard < 30:
		guard += 1
		var j = G._make_job()
		if not j.is_empty(): G.S["jobs"].append(j)

func _make_job() -> Dictionary:
	var temps: Array = G.meta.get("jobs", {}).get("templates", [])
	if temps.is_empty(): return {}
	var t = temps[G.rng.randi_range(0, temps.size() - 1)]
	var n = G.rng.randi_range(int(t["n"][0]), int(t["n"][1]))
	var item := ""
	var label := ""
	match t["type"]:
		"harvest":
			var cs = G.crops_for("field")
			if cs.is_empty(): return {}
			var c: String = cs[G.rng.randi_range(0, cs.size() - 1)]
			item = G.nodes[c]["yields"].keys()[0]; label = G.iname(item)
		"make":
			var opts := []
			for root in G.stations():
				for rid in G.station_recipes_for(root):
					if G.recipe_open(rid) and float(G.recipes[rid].get("energy", 0)) > 0: opts.append(rid)
			if opts.is_empty(): return {}
			item = opts[G.rng.randi_range(0, opts.size() - 1)]
			label = str(G.recipes[item].get("name", G.iname(G.recipes[item]["outputs"].keys()[0])))
		"collect":
			var an := []
			for aid in G.S["animals"]:
				if int(G.S["animals"][aid]["count"]) > 0: an.append(aid)
			if an.is_empty(): return {}
			item = an[G.rng.randi_range(0, an.size() - 1)]; label = G.nodes[item]["name"]; n = 1
		"stones":
			var any := false
			for p in G.S["patches"]:
				if float(p["stones"]) >= 1.0: any = true
			if not any and G.season() != "winter": return {}
	for j in G.S["jobs"]:
		if j["type"] == t["type"] and j["item"] == item: return {}
	var text: String = str(t["text"]).replace("{n}", str(n)).replace("{item}", label)
	return {"type": t["type"], "item": item, "n": n, "got": 0.0, "text": text}

func _job(type: String, item: String, q: float) -> void:
	var finished := []
	for j in G.S["jobs"]:
		if j["type"] != type: continue
		if j["item"] != "" and j["item"] != item: continue
		j["got"] = float(j["got"]) + q
		if float(j["got"]) + 0.0001 >= float(j["n"]): finished.append(j)
	for j in finished:
		G.S["jobs"].erase(j)
		var jm = G.meta.get("jobs", {})
		var coins = float(jm.get("rewardCoinsPerChapter", 4)) * G.chapter()
		G.S["coins"] += coins
		var rl: Array = jm.get("rewardLuck", [0.1, 10])
		G.add_luck(float(rl[0]), int(rl[1]))
		G.say(tr("📋 Little job done: %s → 🪙%d and a bit of luck ☘️") % [j["text"], int(coins)])
	if finished.size() > 0: G._refill_jobs()

func _check_acorns() -> void:
	var ac = G.meta.get("acorns", {})
	for a in ac.get("list", []):
		var id: String = a["id"]
		if G.S["acorns"].has(id): continue
		var ok = G.cond(str(a["when"]))
		if ok:
			G.S["acorns"][id] = true
			G._dirty()
			G.say(tr("🌰✨ Golden Acorn: %s! Energy max +%d for good.") % [a["name"], int(ac.get("energyMaxEach", 3))])
	G._check_perks()

func perk_def(id: String) -> Dictionary:
	for p in G.meta.get("perks", {}).get("list", []):
		if p["id"] == id: return p
	return {}

func perks() -> Dictionary:
	if not G.S.has("perks"): G.S["perks"] = {}
	return G.S["perks"]

func perk_owned(id: String) -> bool:
	return G.perks().has(id)

## Owned and switched on (the album has a switch for each).
func perk_on(id: String) -> bool:
	return bool(G.perks().get(id, false))

func toggle_perk(id: String) -> void:
	if not G.perk_owned(id): return
	G.perks()[id] = not G.perk_on(id)
	G.save_game(); G.changed.emit()

func give_perk(id: String) -> void:
	if G.perk_owned(id) or G.perk_def(id).is_empty(): return
	G.perks()[id] = true
	var p = G.perk_def(id)
	G.say(tr("✨ New perk: %s %s!") % [p.get("emoji", ""), p["name"]])
	G.celebrate.emit("perk:" + id)

func _check_perks() -> void:
	for p in G.meta.get("perks", {}).get("list", []):
		if G.perk_owned(p["id"]) or str(p.get("when", "")) == "": continue
		if G.cond(str(p["when"])): G.give_perk(p["id"])

## Something happened that perks count (things sold …).
func perk_event(kind: String, data := {}) -> void:
	if kind == "sell":
		if not G.S.has("sold_kinds"): G.S["sold_kinds"] = {}
		G.S["sold_kinds"][str(data.get("item", ""))] = true
	G._check_perks()
