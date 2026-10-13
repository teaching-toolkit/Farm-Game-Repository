extends Node
## Headless play-test: a greedy bot plays the rules engine and reports progress.
## Run:  godot --headless --path . res://tests/bot.tscn -- [--chapter=5] [--seed=1] [--golden=FILE] [--save-at=3:FILE] [--report=FILE]
##   --seed=N        the same game every time (the rules engine's random numbers, clock and learning record; see Game.now)
##   --golden=FILE   writes one fingerprint line per step of time; tests/golden.sh compares it with tests/golden/
##   --save-at=C:FILE  writes the save when chapter C is reached (test fixtures, tests/fixtures/)
##   --report=FILE   writes the pacing of this run as JSON: per chapter the questions, Rest answers, card questions and actions, and the hours
##                   they take with the timing of meta.pacing (the progression explorer shows it; tools/update_explorer.sh makes it)
var G
var log_lines := []
var max_iters := 900
var target_chapter := 4
var flex := false
var accuracy := 1.0       # --accuracy=0.8: share of Time Quiz questions answered right at the first try (only those move time)
var asked := 0           # Time Quiz questions asked (with accuracy < 1 more than the steps of time)
var quiz_rng := RandomNumberGenerator.new()   # separate from the game's own random numbers
var trace := 0           # --trace=N prints what happens during the first N questions (to check the opening)
var pace_sum := {}      # chapter -> [sum of pace, questions]: tells meta.flex.basePace
var golden_path := ""
var golden := []        # fingerprint lines
var save_at := {}       # chapter -> file
var report_path := ""
var know_answers := 0    # knowledge card questions answered
var chapter_rows := []   # the pacing report: one row per chapter played
var _row := {}           # the chapter being played now

func _ready() -> void:
	G = get_node("/root/Game")
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--iters="): max_iters = int(a.substr(8))
		if a.begins_with("--chapter="): target_chapter = int(a.substr(10))
		if a == "--flex": flex = true
		if a.begins_with("--trace="): trace = int(a.substr(8))
		if a.begins_with("--accuracy="): accuracy = clampf(float(a.substr(11)), 0.05, 1.0)
		if a.begins_with("--seed="): quiz_rng.seed = int(a.substr(7)) + 1
		if a.begins_with("--golden="): golden_path = a.substr(9)
		if a.begins_with("--report="): report_path = a.substr(9)
		if a.begins_with("--save-at="):
			var parts := a.substr(10).split(":", true, 1)
			if parts.size() == 2: save_at[int(parts[0])] = parts[1]
	G.reset_game()
	if flex: G.S["dynamic"] = true
	G.offer_cards.connect(func(c): G.rewards.pick_gift(c[0]))
	G.ask_name.connect(func(id, dn): G.progression.set_pet_name(id, dn))
	G.toast.connect(func(t): if int(G.S["step"]) < trace: print("  q%d  %s" % [G.S["step"], t]))
	var t0 := Time.get_ticks_msec()
	var it := 0
	_begin_chapter()
	while it < max_iters and G.chapter() < target_chapter:
		it += 1
		var st0: int = G.S["step"]
		_turn()
		if st0 < trace and G.S["step"] != st0:
			print("q%d -> energy %.1f water %.1f coins %.1f seeds %s plots %d wheat %.1f" % [G.S["step"], G.S["energy"], G.S["water"], G.S["coins"], G.S["seeds"], G.progression.plots(), G.inventory.count("wheat")])
		if G.S["step"] != st0 and golden_path != "": golden.append(_fingerprint())
		if G.chapter() != int(_row["chapter"]):
			_close_chapter(true)
			_begin_chapter()
		if save_at.has(G.chapter()):
			G.save_to(save_at[G.chapter()])
			print("saved chapter %d at step %d to %s" % [G.chapter(), G.S["step"], save_at[G.chapter()]])
			save_at.erase(G.chapter())
		if G.S["step"] != st0 and int(G.S["step"]) % 20 == 0 and G.S.has("pace"):
			print("pace_sample step %d goals %d unlocked %d chapter %d pace %.1f" % [G.S["step"], G.S["goals"], G.S["unlocked"].size(), G.chapter(), float(G.S["pace"])])
		if G.S["step"] != st0 and G.S.has("pace"):
			var ps: Array = pace_sum.get(G.chapter(), [0.0, 0])
			pace_sum[G.chapter()] = [float(ps[0]) + float(G.S["pace"]), int(ps[1]) + 1]
		if it % 200 == 0:
			print("iter %d step %d ch %d unlocked %d cards %d coins %d energy %d season %s" % [it, G.S["step"], G.chapter(), G.S["unlocked"].size(), G.progression.cards_learned(), int(G.S["coins"]), int(G.S["energy"]), G.seasons.season()])
	if "--stuck" in OS.get_cmdline_user_args():
		for id in G.nodes:
			if G.progression.is_open(id) and not G.done(id) and not G.nodes[id].get("optional", false):
				print("   open: %s (%s) %s" % [id, G.nodes[id]["type"], G.progression.can_unlock(id)["why"]])
	if "--trips" in OS.get_cmdline_user_args(): print("hand cart: %s, axles left %d" % [str(G.S["unlocked"].has("hand_cart")), int(G.inventory.count("axle"))])
	print("DONE iters %d steps %d chapter %d unlocked %d cards %d goals %d coins %d ms %d" % [it, G.S["step"], G.chapter(), G.S["unlocked"].size(), G.progression.cards_learned(), G.S["goals"], int(G.S["coins"]), Time.get_ticks_msec() - t0])
	_close_chapter(G.chapter() > int(_row["chapter"]))
	if report_path != "": _write_report()
	if golden_path != "":
		var gf := FileAccess.open(golden_path, FileAccess.WRITE)
		if gf: gf.store_string("\n".join(golden) + "\n")
		print("golden run: %d lines written to %s" % [golden.size(), golden_path])
	if accuracy < 1.0: print("Time Quiz questions asked %d for %d steps of time (first-try accuracy %.2f)" % [asked, G.S["step"], accuracy])
	var pets := []
	for p in G.pet_ids:
		if G.done(p): pets.append(p)
	var pc := {}
	for ch in pace_sum: pc[ch] = snappedf(float(pace_sum[ch][0]) / maxf(1.0, float(pace_sum[ch][1])), 0.1)
	print("pace by chapter (worth per question): ", pc, "  flex factors: ", G.S.get("flex", {}).values() if flex else "off")
	print("pets: ", pets, " album: ", G.S["album"].size(), " acorns: ", G.S["acorns"].keys(), " gifts: ", G.S["gift_owned"])
	var open := []
	for id in G.nodes:
		if G.progression.is_open(id) and not G.nodes[id].get("optional", false): open.append(id + "(" + G.progression.can_unlock(id)["why"].substr(0, 60) + ")")
	print("open main goals at end: ", open.slice(0, 12))
	var near := []
	for id in G.nodes:
		if G.done(id) or G.satisfied(id) or G.nodes[id].get("optional", false): continue
		var mr: Array = G.progression.missing_reqs(id)
		if mr.size() == 1: near.append(id + " <- " + str(mr[0]))
	print("one step away: ", near.slice(0, 25))
	# why the open main goals are stuck: the missing things, how they are made, and what those recipes still lack
	for id in G.nodes:
		if not G.progression.is_open(id) or G.nodes[id].get("optional", false): continue
		for x in G.pace.missing_cost(G.pace.node_cost(id)):
			var k: String = x["key"]
			var how := []
			for rid in G.recipes:
				if not G.recipes[rid]["outputs"].has(k): continue
				var lack := []
				for y in G.pace.missing_cost(G.crafting.recipe_cost(rid, 1)): lack.append("%s %.0f/%.0f" % [y["key"], float(y["have"]), float(y["need"])])
				how.append("%s(open %s, station %s built %s, lacks %s)" % [rid, G.crafting.recipe_open(rid), G.recipes[rid]["station"], G.satisfied(G.recipes[rid]["station"]), lack])
			for cid in G.nodes:
				if G.nodes[cid]["type"] == "crop" and G.nodes[cid].get("yields", {}).has(k): how.append("crop %s done %s" % [cid, G.done(cid)])
			print("stuck: ", id, " needs ", k, " ", float(x["have"]), "/", float(x["need"]), " <- ", how)
	var orch := []
	for p in G.fields.area("orchard"): orch.append(str(p["crop"]))
	print("orchard: crops possible ", G.fields.crops_for("orchard"), " planted ", orch, "  walnut tree open ", G.done("crop_walnut"), " missing ", G.progression.missing_reqs("crop_walnut"))
	var cs := {}
	for cid in G.card_ids: cs[G.knowledge.card_status(cid)] = int(cs.get(G.knowledge.card_status(cid), 0)) + 1
	print("cards by status: ", cs, " reading: ", G.S["reading"], " books: ", G.progression.books_owned(), "/", G.g("bookSlots", 1))
	print("last log: ", G.S["log"].slice(-8))
	get_tree().quit()

## ------------------------------------------------------------------ the pacing report (--report=FILE)
func _begin_chapter() -> void:
	_row = {"chapter": G.chapter(), "step0": int(G.S["step"]), "rest0": int(G.S["stats"]["rest"]),
		"actions0": G.saves_requested - int(G.S["step"]), "know0": know_answers}

## Closes the row of the chapter that was being played. complete = its pet came home (the next chapter began).
func _close_chapter(complete: bool) -> void:
	var t: Dictionary = G.meta.get("pacing", {})
	var q: int = int(G.S["step"]) - int(_row["step0"])
	var rest: int = int(G.S["stats"]["rest"]) - int(_row["rest0"])
	var act: int = int(G.saves_requested) - int(G.S["step"]) - int(_row["actions0"])
	var know: int = know_answers - int(_row["know0"])
	var sec: float = float(q) * float(t.get("secondsPerStep", 25)) + float(act) * float(t.get("secondsPerAction", 3)) \
		+ float(rest) * float(t.get("secondsPerRest", 5)) + float(know) * float(t.get("secondsPerKnowledgeQuestion", 12))
	chapter_rows.append({"chapter": int(_row["chapter"]), "pet": str(G.D["chapters"][int(_row["chapter"]) - 1].get("pet", "")), "complete": complete,
		"questions": q, "restAnswers": rest, "knowledgeQuestions": know, "actions": act, "hours": snappedf(sec / 3600.0, 0.01)})

func _write_report() -> void:
	var t: Dictionary = G.meta.get("pacing", {})
	var total := 0.0
	var rows := []
	for r in chapter_rows:
		total += float(r["hours"])
		var row: Dictionary = r.duplicate()
		row["hoursTotal"] = snappedf(total, 0.01)
		rows.append(row)
	var seed_n := -1
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--seed="): seed_n = int(a.substr(7))
	var run := {"label": "bot, seed %d, accuracy %.2f" % [seed_n, accuracy], "seed": seed_n, "accuracy": accuracy, "stoppedAtStep": int(G.S["step"]),
		"reachedChapter": G.chapter(), "chapters": rows}
	var report := {"what": "Pacing of the greedy test bot playing the real rules engine (tests/bot.gd). Hours use the timing of meta.pacing. The bot is not a child: it always knows what it needs and works through the farm in sweeps. Trust the Time Quiz and Rest answers most; its actions are counted as one per saved change and include many small ones that a child would batch (Harvest all …).",
		"version": str(ProjectSettings.get_setting("application/config/version", "")), "dataVersion": str(G.meta.get("version", "")),
		"targetPetHours": G.meta.get("targets", {}).get("hours", {}), "timing": {"secondsPerStep": t.get("secondsPerStep", 25), "secondsPerAction": t.get("secondsPerAction", 3), "secondsPerRest": t.get("secondsPerRest", 5),
			"secondsPerKnowledgeQuestion": t.get("secondsPerKnowledgeQuestion", 12)}, "runs": [run]}
	var f := FileAccess.open(report_path, FileAccess.WRITE)
	if f: f.store_string(JSON.stringify(report, "\t") + "\n")
	print("pacing report written to ", report_path)

## One line per step of time: the main numbers in words (they should stay the same through a restructuring) and a
## short hash of the whole state (changes whenever the save layout changes, which is fine when on purpose).
func _fingerprint() -> String:
	var inv := {}
	for k in G.S["inv"]:
		if G.inventory.count(k) != 0.0: inv[k] = snappedf(G.inventory.count(k), 0.01)
	var unl: Array = G.S["unlocked"].keys()
	unl.sort()
	return "q%d ch%d coins %.2f energy %.2f water %.2f goals %d unlocked %d %s inv %s state %s" % [G.S["step"], G.chapter(),
		float(G.S["coins"]), float(G.S["energy"]), float(G.S["water"]), int(G.S["goals"]), unl.size(),
		",".join(unl).md5_text().substr(0, 8), JSON.stringify(inv, "", true).md5_text().substr(0, 8),
		JSON.stringify(G.S, "", true).md5_text().substr(0, 8)]

## All tree spots are taken: cut down a tree (of a kind planted twice) when a goal needs the fruit of a tree not planted yet.
func _maybe_cut_tree(a: String) -> void:
	var need_t := _needed_items()
	var planted := {}
	for q in G.fields.area(a): planted[q["crop"]] = int(planted.get(q["crop"], 0)) + 1
	for c in G.fields.crops_for(a):
		if planted.has(c): continue
		var wanted := false
		for y in G.nodes[c].get("yields", {}):
			if _deep_need(y, need_t) and G.inventory.count(y) < 1.0: wanted = true
		if not wanted: continue
		for j in range(G.fields.area(a).size()):
			var cj: String = G.fields.area(a)[j]["crop"]
			if cj != "" and int(planted.get(cj, 0)) > 1:
				G.fields.cut_tree(a, j)
				return
		return

## Is item k needed by an open goal, directly or as an ingredient of something needed (two levels deep)?
func _deep_need(k: String, need: Dictionary) -> bool:
	if need.has(k): return true
	for n in need:
		for rid in G.recipes:
			if G.recipes[rid]["outputs"].has(n) and G.recipes[rid].get("inputs", {}).has(k): return true
	return false

## The orders (deliveries) that are open, whose items the store holds.
func _ready_orders() -> Array:
	var out := []
	for id in G.nodes:
		if G.nodes[id]["type"] != "delivery" or G.done(id) or not G.progression.is_open(id): continue
		if not G.progression.missing_reqs(id).is_empty(): continue
		if G.pace.missing_cost(G.pace.node_cost(id)).is_empty(): out.append(id)
	return out

## A market trip when there is something to do in the village: pack (orders first, then the surplus that sells best per load),
## go (the walk is one question), then deliver, buy, barter, sell, and come home.
func _trip() -> void:
	var orders := _ready_orders()
	var sell_value := 0.0
	for k in want_sell: sell_value += G.inventory.value_of(k) * float(want_sell[k])
	# a trip costs a question and energy: not with empty pockets (seeds and goods cost coins), and not every turn
	var budget: float = float(G.S["coins"]) + sell_value
	var seeds_ok := false
	for cid in want_seeds:
		if budget >= 4.0 * float(G.nodes[cid].get("seedCost", 1)): seeds_ok = true
	var errands: bool = seeds_ok or not want_buy.is_empty() or not want_barter.is_empty() or not orders.is_empty()
	var sell_load := 0.0
	for k in want_sell: sell_load += G.inventory.load_of(k, float(want_sell[k]))
	var near_cap := false      # a full store wastes harvests: go before it overflows
	for k in want_sell:
		if G.inventory.count(k) >= G.needs.storage_cap() - 3.0: near_cap = true
	var selling: bool = sell_value >= 150.0 and (sell_load >= 0.6 * G.trip.capacity() or near_cap or G.S["step"] - last_trip >= 12)
	if not errands and not selling: return
	if orders.is_empty() and G.S["step"] - last_trip < 3: return
	if G.S["energy"] < float(G.trip.energy_cost()) + 6.0: return
	G.trip.unpack_all()
	for id in orders:
		var c: Dictionary = G.pace.node_cost(id)
		if G.trip.can_pack_cost(c): G.trip.pack_cost(c)
	var ks: Array = want_sell.keys()
	ks.sort_custom(func(a, b): return G.inventory.value_of(a) / maxf(0.05, G.inventory.weight_of(a)) > G.inventory.value_of(b) / maxf(0.05, G.inventory.weight_of(b)))
	for k in ks: G.trip.pack(k, int(want_sell[k]))
	if not G.trip.go(): return
	trips_done += 1
	if trips_done % 25 == 0 or trips_done < 6: print("trip %d at q%d ch%d: orders %d seeds %s buy %d barter %d sell %d coins %d" % [trips_done, G.S["step"], G.chapter(), orders.size(), str(want_seeds), want_buy.size(), want_barter.size(), int(sell_value), int(G.S["coins"])])
	last_trip = G.S["step"]
	asked += 1
	while accuracy < 1.0 and quiz_rng.randf() >= accuracy: asked += 1
	G.step_time()                       # the walk: one question answered right at the first try
	G.trip.arrive()
	for id in orders:
		if G.progression.can_unlock(id)["ok"]: G.progression.unlock(id)
	if "--trips" in OS.get_cmdline_user_args(): print("   q%d coins before %d, packed %s load %.1f/%d, want_sell %s" % [G.S["step"], int(G.S["coins"]), str(G.trip.contents()), G.trip.load_now(), int(G.trip.capacity()), str(want_sell)])
	for k in G.trip.contents().keys():          # sell first (coins for the shopping), what an order still needs stays
		if G.inventory.sellable(k) and not _held_for_order(k, orders): G.trade.sell(k, G.trip.packed(k))
	var seed_budget: float = float(G.S["coins"]) * 0.6 / maxf(1.0, float(want_seeds.size()))      # not all the coins on seeds, and not one crop only
	if "--trips" in OS.get_cmdline_user_args(): print("   q%d coins after selling %d (bag %s)" % [G.S["step"], int(G.S["coins"]), str(G.trip.contents())])
	for cid in want_seeds:
		var afford := int(floorf(seed_budget / maxf(1.0, float(G.nodes[cid].get("seedCost", 1)))))
		if afford >= 1: G.trade.buy_seeds(cid, mini(int(want_seeds[cid]), afford))
	for mid_k in want_buy:
		var need_n := ceili(float(_needed_items().get(mid_k[1], 1.0)) - G.inventory.count(mid_k[1]))
		var c0: float = G.inventory.count(mid_k[1])
		G.trade.buy_item(mid_k[0], mid_k[1], maxi(1, need_n))
		if "--trips" in OS.get_cmdline_user_args() and G.S["step"] > 280: print("   buy %s %d (need %d) had %.0f now %.0f room %d coins %d cap %d" % [mid_k[1], maxi(1, need_n), need_n, c0, G.inventory.count(mid_k[1]), G.trip.can_buy(G.inventory.weight_of(mid_k[1])), int(G.S["coins"]), int(G.needs.storage_cap())])
	for mid_k in want_barter:
		G.trade.barter(mid_k[0], mid_k[1])
	G.trip.leave()

## Is the item packed for an order that was not handed over (it should not be sold)?
func _held_for_order(k: String, orders: Array) -> bool:
	for id in orders:
		if not G.done(id) and G.pace.node_cost(id).has(k): return true
	return false

func _gate_cost(k: String) -> Dictionary:
	var c := {}
	var b: Dictionary = G.gate.data().get("barter", {}).get(k, {})
	for x in b.get("cost", {}): c[x] = float(b["cost"][x])
	return c

func _rest() -> void:
	var guard := 0
	while G.S["energy"] < G.needs.energy_max() - G.needs.rest_per_answer() and guard < 40:
		G.needs.rest_correct(); guard += 1

func _needed_items() -> Dictionary:
	var need := {}
	for id in G.nodes:
		if not G.progression.is_open(id): continue
		var n = G.nodes[id]
		if n.get("optional", false) and n["type"] != "gear" and id != "hand_cart": continue      # (the first cart carries the trips: worth the axle)
		var c: Dictionary = G.pace.node_cost(id)
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
			if G.inventory.count(item) >= float(need[k]): continue
			for root in G.crafting.stations():
				for rid in G.crafting.station_recipes_for(root):
					if not G.crafting.recipe_open(rid): continue
					var r = G.recipes[rid]
					if not r["outputs"].has(item): continue
					for ik in r["inputs"]:
						need[ik] = maxf(float(need.get(ik, 0.0)), float(r["inputs"][ik]) * 2.0)
					for kk in r.get("keeps", []):
						if G.inventory.count(kk) < 1.0: need[kk] = maxf(float(need.get(kk, 0.0)), 1.0)
	for aid in G.nodes:
		if G.nodes[aid]["type"] == "animal" and G.done(aid):
			for fk in G.nodes[aid].get("feed", {}): need[fk] = maxf(float(need.get(fk, 0.0)), 6.0)
	for cid in G.card_ids:
		if G.knowledge.card_status(cid) == "discover":
			for k in G.nodes[cid].get("discover", []):
				if not G.S["seen"].has(k): need[k] = maxf(float(need.get(k, 0.0)), 1.0)
	for bk in G.gate.data().get("barter", {}):          # what the merchant asks for his axle must be made in time
		if need.has(bk):
			for x in G.gate.data()["barter"][bk]["cost"]:
				if x != "coins": need[x] = maxf(float(need.get(x, 0.0)), float(G.gate.data()["barter"][bk]["cost"][x]))
	need["fertilizer_hint"] = 0
	return need

# What the bot wants from the village this turn (seeds to plant, things the goals need, orders to deliver, surplus to sell); the trip comes at the end of the turn.
var want_seeds := {}
var want_buy := []        # [merchant, item]
var _last_shares := 0
var _sold_mark := 0.0
var want_barter := []     # [merchant, item]
var want_sell := {}       # item -> units
var last_trip := -99      # the step of the last trip
var trips_done := 0

func _turn() -> void:
	want_seeds = {}; want_buy = []; want_barter = []; want_sell = {}
	if G.S["energy"] < 8: _rest()
	# knowledge
	for cid in G.card_ids:
		var st = G.knowledge.card_status(cid)
		if st == "quiz":
			for q in G.knowledge.card_quiz(cid):
				G.knowledge.record_card_answer(q, true)
				know_answers += 1
			G.knowledge.finish_card(cid, true)
		elif st == "readable" and G.S["reading"] == "":
			G.knowledge.start_reading(cid)
	# water: carry some from the pond when it runs low (the bucket costs a little energy)
	var trips := 0
	while float(G.S["water"]) < G.needs.water_cap() - G.fields.fetch_amount() and G.S["energy"] > 6 and trips < 4:
		if not G.fields.fetch_water(): break
		trips += 1
	# fields
	for i in range(G.S["patches"].size()):
		if not G.fields.patch_usable("field", i): continue
		var p = G.S["patches"][i]
		if p["ready"]: G.fields.harvest("field", i)
		if float(p["weeds"]) >= 3.0: G.fields.weed(i)
		if float(p["stones"]) >= 2.0: G.fields.pick_stones(i)
		if p["crop"] == "":
			var cs: Array = G.fields.crops_for("field")
			if cs.size() > 0:
				var pick: String = cs[(i + G.S["step"]) % cs.size()]
				var need := _needed_items()
				var best := -1.0
				for c in cs:
					for y in G.nodes[c].get("yields", {}):
						var short := 0.0
						if need.has(y): short = float(need[y]) - G.inventory.count(y)
						for k in need:
							if k.begins_with("tag:") and (G.items[y].get("tags", []) as Array).has(k.substr(4)): short = maxf(short, float(need[k]) - G.inventory.count_tag(k.substr(4)))
						if short > best + 0.01 and short > 0.0: best = short; pick = c
				if cs.has("crop_wheat") and G.inventory.count("wheat") < 3.0 * G.fields.plants_per_patch("field") + 4.0 and G.fields.seed_have("crop_wheat") >= 1.0: pick = "crop_wheat"      # the grain is the seed: grow enough of it
				if G.fields.seed_have(pick) < float(G.fields.plants_per_patch("field")) and not G.nodes[pick].has("seedItem"):
					want_seeds[pick] = maxi(int(want_seeds.get(pick, 0)), maxi(1, G.fields.plants_per_patch("field") * 8))      # seeds come from the village now: a bulk, a trip costs a question
				if G.fields.plant_plan("field", pick)["plants"] >= 1: G.fields.plant("field", i, pick)
	for a in ["orchard", "gh"]:
		for i in range(G.fields.area(a).size()):
			var p = G.fields.area(a)[i]
			if p["ready"]: G.fields.harvest(a, i)
			if p["crop"] == "":
				var cs: Array = G.fields.crops_for(a)
				if cs.is_empty(): continue
				# a tree whose fruit an open goal needs (walnuts for the pony's cake …), else take turns
				var pick: String = cs[i % cs.size()]
				var need_o := _needed_items()
				for c in cs:
					for y in G.nodes[c].get("yields", {}):
						if _deep_need(y, need_o) and G.inventory.count(y) < 3.0: pick = c
				if G.fields.seed_have(pick) < 1.0 and not G.nodes[pick].has("seedItem"): want_seeds[pick] = maxi(int(want_seeds.get(pick, 0)), 1)
				if G.fields.plant_plan(a, pick)["plants"] >= 1: G.fields.plant(a, i, pick)
			elif a == "orchard" and i == G.fields.area(a).size() - 1:
				_maybe_cut_tree(a)
	# animals
	for aid in G.nodes:
		if G.nodes[aid]["type"] != "animal": continue
		if not G.progression.missing_reqs(aid).is_empty(): continue
		var an = G.animals.animal(aid)
		if int(an["count"]) < G.animals.animal_cap(aid) and G.S["coins"] > 2.0 * float(G.nodes[aid].get("price", {}).get("coins", 0)): G.animals.buy_animal(aid)
		if int(an["count"]) > 0:
			if G.animals.muck_factor(aid) < 1.0: G.animals.muck_out(aid)
			if G.S["step"] >= int(an["ready"]): G.animals.collect_animal(aid)
	if int(G.S["lord"]["shares"]) != _last_shares and "--lord" in OS.get_cmdline_user_args():
		_last_shares = int(G.S["lord"]["shares"])
		var sold: float = float(G.S["stats"].get("sold_coins", 0.0))
		print("   LORD q%d ch%d: share %d (assumed %d, %d%%), sold since last share %d, coins %d" % [G.S["step"], G.chapter(), int(G.S["lord"]["last_share"]), int(G.lord.assumed()), int(G.lord.fraction() * 100), int(sold - _sold_mark), int(G.S["coins"])])
		_sold_mark = sold
	if G.lord.here():      # Pieter waits at the gate: the Lord's share comes first (sell what is needed to pay it)
		G.lord.pay()
	# make what open goals need, plus gather basics
	var need := _needed_items()
	var coins_short := false      # money for a goal is short: then crafts that sell are worth making too
	for id in G.nodes:
		if G.progression.is_open(id) and float(G.pace.node_cost(id).get("coins", 0.0)) > float(G.S["coins"]) - 300.0: coins_short = true
	for root in G.crafting.stations():
		for rid in G.crafting.station_recipes_for(root):
			if not G.crafting.recipe_open(rid): continue
			var r = G.recipes[rid]
			var useful := false
			for o in r["outputs"]:
				if need.has(o) and G.inventory.count(o) < float(need[o]) + 1.0: useful = true
				if G.items[o].has("fertilizer") and G.fields.fert_points_have() < 12: useful = true
				for k in need:
					if k.begins_with("tag:") and (G.items[o].get("tags", []) as Array).has(k.substr(4)): useful = true
			if r["station"] == "wild_edge" and G.S["woodpile"] < 6: useful = true
			if coins_short and r["station"] != "wild_edge":       # a craft that sells for more than its stuff is worth (and the store has room)
				for o in r["outputs"]:
					if G.items[o].get("category", "") == "craft" and G.inventory.count(o) < 4.0 and G.inventory.value_of(o) >= 100.0: useful = true
			if useful:
				if G.crafting.recipe_fuel(rid) > float(G.S["woodpile"]) + 0.0001: G.crafting.stoke(G.crafting.recipe_fuel(rid))   # stoke the woodpile first
				G.crafting.start_recipe(rid)
	# money: sell surplus when coins are short for an open goal
	var coins_need := 0.0
	for id in G.nodes:
		if G.progression.is_open(id): coins_need = maxf(coins_need, float(G.pace.node_cost(id).get("coins", 0.0)))
	if G.S["coins"] < coins_need + 300:
		for k in G.S["inv"].keys():
			var keep := 6.0 + float(need.get(k, 0.0))
			if k == "wheat": keep = maxf(keep, 3.0 * G.fields.plants_per_patch("field") + 4.0)      # seed for the next sowing
			if G.inventory.count(k) > keep and G.inventory.sellable(k): want_sell[k] = floorf(G.inventory.count(k) - keep)
	# buy missing raw items from merchants
	for mid in G.nodes:
		if G.nodes[mid]["type"] != "merchant" or not G.done(mid): continue
		for k in G.nodes[mid].get("sells", {}):
			if need.has(k) and G.inventory.count(k) < float(need[k]) and (G.S["coins"] > 900 or not G.S["seen"].has(k)) and G.inventory.count(k) < G.needs.storage_cap() - 0.5: want_buy.append([mid, k])
		for k in G.nodes[mid].get("barter", {}):
			if need.has(k) and G.inventory.count(k) < 1: want_barter.append([mid, k])
	# unlock what we can: main goals first, then optional upgrades and gear, polish once
	for id in G.nodes:
		var n = G.nodes[id]
		if n["type"] == "animal" or n["type"] == "polish": continue
		if G.progression.is_open(id) and G.progression.can_unlock(id)["ok"]:
			if n.get("optional", false) and n["type"] == "sidequest" and G.S["energy"] < 15: continue
			G.progression.unlock(id)
	if G.gate.here():      # the travelling merchant at the gate buys without a trip
		for k in want_sell.keys():
			var before: float = G.inventory.count(k)
			if G.gate.wants(k): G.trade.sell_gate(k, float(want_sell[k]))
			want_sell[k] = float(want_sell[k]) - (before - G.inventory.count(k))
			if float(want_sell[k]) < 1.0: want_sell.erase(k)
		for bk in G.gate.data().get("barter", {}):          # …and trades an axle for the first cart
			if "--trips" in OS.get_cmdline_user_args() and need.has(bk): print("   q%d gate here, axle needed; coins %d baskets %d missing %s" % [G.S["step"], int(G.S["coins"]), int(G.inventory.count("wicker_basket")), str(G.pace.missing_cost(_gate_cost(bk)))])
			if need.has(bk) and G.inventory.count(bk) < 1.0 and G.pace.missing_cost(_gate_cost(bk)).is_empty(): G.trade.barter_gate(bk)
	_trip()
	for pid in G.polish_ids:
		if G.crafting.polish_open(pid) and G.crafting.polish_level(pid) < 1.0 and G.pace.missing_cost(G.crafting.polish_cost(pid)).is_empty(): G.crafting.do_polish(pid)
	# eat a dish now and then
	for k in G.S["inv"].keys():
		if G.items[k].has("buff") and G.inventory.count(k) > 3 and G.S["buff"].is_empty(): G.trade.eat(k)
	# only a right first try moves time: with --accuracy below 1 some questions are asked without moving it
	asked += 1
	while accuracy < 1.0 and quiz_rng.randf() >= accuracy: asked += 1
	G.step_time()
