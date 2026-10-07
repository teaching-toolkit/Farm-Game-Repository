extends Node
## Headless play-test: a greedy bot plays the rules engine and reports progress.
## Run:  godot --headless --path . res://tests/bot.tscn
var G
var log_lines := []
var max_iters := 900
var target_chapter := 4
var flex := false
var pace_sum := {}      # chapter -> [sum of pace, questions]: tells meta.flex.basePace

func _ready() -> void:
	G = get_node("/root/Game")
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--iters="): max_iters = int(a.substr(8))
		if a.begins_with("--chapter="): target_chapter = int(a.substr(10))
		if a == "--flex": flex = true
	G.reset_game()
	if flex: G.S["dynamic"] = true
	G.offer_cards.connect(func(c): G.pick_gift(c[0]))
	G.ask_name.connect(func(id, dn): G.set_pet_name(id, dn))
	var t0 := Time.get_ticks_msec()
	var it := 0
	while it < max_iters and G.chapter() < target_chapter:
		it += 1
		var st0: int = G.S["step"]
		_turn()
		if G.S["step"] != st0 and int(G.S["step"]) % 20 == 0 and G.S.has("pace"):
			print("pace_sample step %d goals %d unlocked %d chapter %d pace %.1f" % [G.S["step"], G.S["goals"], G.S["unlocked"].size(), G.chapter(), float(G.S["pace"])])
		if G.S["step"] != st0 and G.S.has("pace"):
			var ps: Array = pace_sum.get(G.chapter(), [0.0, 0])
			pace_sum[G.chapter()] = [float(ps[0]) + float(G.S["pace"]), int(ps[1]) + 1]
		if it % 200 == 0:
			print("iter %d step %d ch %d unlocked %d cards %d coins %d energy %d season %s" % [it, G.S["step"], G.chapter(), G.S["unlocked"].size(), G.cards_learned(), int(G.S["coins"]), int(G.S["energy"]), G.season()])
	print("DONE iters %d steps %d chapter %d unlocked %d cards %d goals %d coins %d ms %d" % [it, G.S["step"], G.chapter(), G.S["unlocked"].size(), G.cards_learned(), G.S["goals"], int(G.S["coins"]), Time.get_ticks_msec() - t0])
	var pets := []
	for p in ["pet_bunny", "pet_tortoise", "pet_goat", "pet_pony"]:
		if G.done(p): pets.append(p)
	var pc := {}
	for ch in pace_sum: pc[ch] = snappedf(float(pace_sum[ch][0]) / maxf(1.0, float(pace_sum[ch][1])), 0.1)
	print("pace by chapter (worth per question): ", pc, "  flex factors: ", G.S.get("flex", {}).values() if flex else "off")
	print("pets: ", pets, " album: ", G.S["album"].size(), " acorns: ", G.S["acorns"].keys(), " gifts: ", G.S["gift_owned"])
	var open := []
	for id in G.nodes:
		if G.is_open(id) and not G.nodes[id].get("optional", false): open.append(id + "(" + G.can_unlock(id)["why"].substr(0, 60) + ")")
	print("open main goals at end: ", open.slice(0, 12))
	var near := []
	for id in G.nodes:
		if G.done(id) or G.satisfied(id) or G.nodes[id].get("optional", false): continue
		var mr: Array = G.missing_reqs(id)
		if mr.size() == 1: near.append(id + " <- " + str(mr[0]))
	print("one step away: ", near.slice(0, 25))
	# why the open main goals are stuck: the missing things, how they are made, and what those recipes still lack
	for id in G.nodes:
		if not G.is_open(id) or G.nodes[id].get("optional", false): continue
		for x in G.missing_cost(G.node_cost(id)):
			var k: String = x["key"]
			var how := []
			for rid in G.recipes:
				if not G.recipes[rid]["outputs"].has(k): continue
				var lack := []
				for y in G.missing_cost(G.recipe_cost(rid, 1)): lack.append("%s %.0f/%.0f" % [y["key"], float(y["have"]), float(y["need"])])
				how.append("%s(open %s, station %s built %s, lacks %s)" % [rid, G.recipe_open(rid), G.recipes[rid]["station"], G.satisfied(G.recipes[rid]["station"]), lack])
			for cid in G.nodes:
				if G.nodes[cid]["type"] == "crop" and G.nodes[cid].get("yields", {}).has(k): how.append("crop %s done %s" % [cid, G.done(cid)])
			print("stuck: ", id, " needs ", k, " ", float(x["have"]), "/", float(x["need"]), " <- ", how)
	var orch := []
	for p in G.area("orchard"): orch.append(str(p["crop"]))
	print("orchard: crops possible ", G.crops_for("orchard"), " planted ", orch, "  walnut tree open ", G.done("crop_walnut"), " missing ", G.missing_reqs("crop_walnut"))
	var cs := {}
	for cid in G.card_ids: cs[G.card_status(cid)] = int(cs.get(G.card_status(cid), 0)) + 1
	print("cards by status: ", cs, " reading: ", G.S["reading"], " books: ", G.books_owned(), "/", G.g("bookSlots", 1))
	print("last log: ", G.S["log"].slice(-8))
	get_tree().quit()

## All tree spots are taken: cut down a tree (of a kind planted twice) when a goal needs the fruit of a tree not planted yet.
func _maybe_cut_tree(a: String) -> void:
	var need_t := _needed_items()
	var planted := {}
	for q in G.area(a): planted[q["crop"]] = int(planted.get(q["crop"], 0)) + 1
	for c in G.crops_for(a):
		if planted.has(c): continue
		var wanted := false
		for y in G.nodes[c].get("yields", {}):
			if _deep_need(y, need_t) and G.count(y) < 1.0: wanted = true
		if not wanted: continue
		for j in range(G.area(a).size()):
			var cj: String = G.area(a)[j]["crop"]
			if cj != "" and int(planted.get(cj, 0)) > 1:
				G.cut_tree(a, j)
				return
		return

## Is item k needed by an open goal, directly or as an ingredient of something needed (two levels deep)?
func _deep_need(k: String, need: Dictionary) -> bool:
	if need.has(k): return true
	for n in need:
		for rid in G.recipes:
			if G.recipes[rid]["outputs"].has(n) and G.recipes[rid].get("inputs", {}).has(k): return true
	return false

func _rest() -> void:
	var guard := 0
	while G.S["energy"] < G.energy_max() - G.rest_per_answer() and guard < 40:
		G.rest_correct(); guard += 1

func _needed_items() -> Dictionary:
	var need := {}
	for id in G.nodes:
		if not G.is_open(id): continue
		var n = G.nodes[id]
		if n.get("optional", false) and n["type"] != "gear": continue
		var c: Dictionary = G.node_cost(id)
		for k in c:
			if k in ["coins", "energy", "water"]: continue
			need[k] = maxf(float(need.get(k, 0.0)), float(c[k]))
		for k in n.get("needs", {}): need[k] = maxf(float(need.get(k, 0.0)), 2.0)
	# expand through recipes three levels deep (what the needed things are made of)
	for depth in range(3):
		for k in need.keys():
			var item: String = k
			if k.begins_with("tag:"):
				var opts: Array = G.tags.get(k.substr(4), [])
				if opts.is_empty(): continue
				item = opts[0]
			if G.count(item) >= float(need[k]): continue
			for root in G.stations():
				for rid in G.station_recipes_for(root):
					if not G.recipe_open(rid): continue
					var r = G.recipes[rid]
					if not r["outputs"].has(item): continue
					for ik in r["inputs"]:
						need[ik] = maxf(float(need.get(ik, 0.0)), float(r["inputs"][ik]) * 2.0)
					for kk in r.get("keeps", []):
						if G.count(kk) < 1.0: need[kk] = maxf(float(need.get(kk, 0.0)), 1.0)
	for aid in G.nodes:
		if G.nodes[aid]["type"] == "animal" and G.done(aid):
			for fk in G.nodes[aid].get("feed", {}): need[fk] = maxf(float(need.get(fk, 0.0)), 6.0)
	for cid in G.card_ids:
		if G.card_status(cid) == "discover":
			for k in G.nodes[cid].get("discover", []):
				if not G.S["seen"].has(k): need[k] = maxf(float(need.get(k, 0.0)), 1.0)
	need["fertilizer_hint"] = 0
	return need

func _turn() -> void:
	if G.S["energy"] < 8: _rest()
	# knowledge
	for cid in G.card_ids:
		var st = G.card_status(cid)
		if st == "quiz":
			for q in G.card_quiz(cid): G.record_card_answer(q, true)
			G.finish_card(cid, true)
		elif st == "readable" and G.S["reading"] == "":
			G.start_reading(cid)
	# water: carry some from the pond when it runs low (the bucket costs a little energy)
	var trips := 0
	while float(G.S["water"]) < G.water_cap() - G.fetch_amount() and G.S["energy"] > 6 and trips < 4:
		if not G.fetch_water(): break
		trips += 1
	# fields
	for i in range(G.S["patches"].size()):
		if not G.patch_usable("field", i): continue
		var p = G.S["patches"][i]
		if p["ready"]: G.harvest("field", i)
		if float(p["weeds"]) >= 3.0: G.weed(i)
		if float(p["stones"]) >= 2.0: G.pick_stones(i)
		if p["crop"] == "":
			var cs: Array = G.crops_for("field")
			if cs.size() > 0:
				var pick: String = cs[(i + G.S["step"]) % cs.size()]
				var need := _needed_items()
				var best := -1.0
				for c in cs:
					for y in G.nodes[c].get("yields", {}):
						var short := 0.0
						if need.has(y): short = float(need[y]) - G.count(y)
						for k in need:
							if k.begins_with("tag:") and (G.items[y].get("tags", []) as Array).has(k.substr(4)): short = maxf(short, float(need[k]) - G.count_tag(k.substr(4)))
						if short > best + 0.01 and short > 0.0: best = short; pick = c
				if G.seed_have(pick) < float(G.plants_per_patch("field")) and not G.nodes[pick].has("seedItem"):
					G.buy_seeds(pick, maxi(1, G.plants_per_patch("field") * 2))      # seeds come from the market now
				if G.plant_plan("field", pick)["plants"] >= 1: G.plant("field", i, pick)
	for a in ["orchard", "gh"]:
		for i in range(G.area(a).size()):
			var p = G.area(a)[i]
			if p["ready"]: G.harvest(a, i)
			if p["crop"] == "":
				var cs: Array = G.crops_for(a)
				if cs.is_empty(): continue
				# a tree whose fruit an open goal needs (walnuts for the pony's cake …), else take turns
				var pick: String = cs[i % cs.size()]
				var need_o := _needed_items()
				for c in cs:
					for y in G.nodes[c].get("yields", {}):
						if _deep_need(y, need_o) and G.count(y) < 3.0: pick = c
				if G.seed_have(pick) < 1.0 and not G.nodes[pick].has("seedItem"): G.buy_seeds(pick, 1)
				if G.plant_plan(a, pick)["plants"] >= 1: G.plant(a, i, pick)
			elif a == "orchard" and i == G.area(a).size() - 1:
				_maybe_cut_tree(a)
	# animals
	for aid in G.nodes:
		if G.nodes[aid]["type"] != "animal": continue
		if not G.missing_reqs(aid).is_empty(): continue
		var an = G.animal(aid)
		if int(an["count"]) < G.animal_cap(aid) and G.S["coins"] > 2.0 * float(G.nodes[aid].get("price", {}).get("coins", 0)): G.buy_animal(aid)
		if int(an["count"]) > 0:
			if G.muck_factor(aid) < 1.0: G.muck_out(aid)
			if G.S["step"] >= int(an["ready"]): G.collect_animal(aid)
	# make what open goals need, plus gather basics
	var need := _needed_items()
	for root in G.stations():
		for rid in G.station_recipes_for(root):
			if not G.recipe_open(rid): continue
			var r = G.recipes[rid]
			var useful := false
			for o in r["outputs"]:
				if need.has(o) and G.count(o) < float(need[o]) + 1.0: useful = true
				if G.items[o].has("fertilizer") and G.fert_points_have() < 12: useful = true
				for k in need:
					if k.begins_with("tag:") and (G.items[o].get("tags", []) as Array).has(k.substr(4)): useful = true
			if r["station"] == "wild_edge" and G.S["woodpile"] < 6: useful = true
			if useful:
				if G.recipe_fuel(rid) > float(G.S["woodpile"]) + 0.0001: G.stoke(G.recipe_fuel(rid))   # stoke the woodpile first
				G.start_recipe(rid)
	# money: sell surplus when coins are short for an open goal
	var coins_need := 0.0
	for id in G.nodes:
		if G.is_open(id): coins_need = maxf(coins_need, float(G.node_cost(id).get("coins", 0.0)))
	if G.S["coins"] < coins_need + 20:
		for k in G.S["inv"].keys():
			var keep := 6.0 + float(need.get(k, 0.0))
			if G.count(k) > keep and G.value_of(k) > 0: G.sell(k, G.count(k) - keep)
	# buy missing raw items from merchants
	for mid in G.nodes:
		if G.nodes[mid]["type"] != "merchant" or not G.done(mid): continue
		for k in G.nodes[mid].get("sells", {}):
			if need.has(k) and G.count(k) < float(need[k]) and (G.S["coins"] > 60 or not G.S["seen"].has(k)): G.buy_item(mid, k, 1)
		for k in G.nodes[mid].get("barter", {}):
			if need.has(k) and G.count(k) < 1: G.barter(mid, k)
	# unlock what we can: main goals first, then optional upgrades and gear, polish once
	for id in G.nodes:
		var n = G.nodes[id]
		if n["type"] == "animal" or n["type"] == "polish": continue
		if G.is_open(id) and G.can_unlock(id)["ok"]:
			if n.get("optional", false) and n["type"] == "sidequest" and G.S["energy"] < 15: continue
			G.unlock(id)
	for pid in G.polish_ids:
		if G.polish_open(pid) and G.polish_level(pid) < 1.0 and G.missing_cost(G.polish_cost(pid)).is_empty(): G.do_polish(pid)
	# eat a dish now and then
	for k in G.S["inv"].keys():
		if G.items[k].has("buff") and G.count(k) > 3 and G.S["buff"].is_empty(): G.eat(k)
	G.step_time()
