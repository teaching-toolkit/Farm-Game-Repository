extends Node
## UI smoke test: clicks through the opening like a child would.
const Spots = preload("res://game/farm/spots.gd")
var G
var M
var D      # the UI test driver: the tests talk to the screen only through it (tests/ui_driver.gd)

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	M = load("res://main.tscn").instantiate()
	add_child(M)
	D = preload("res://tests/ui_driver.gd").new(M)
	D.story_enabled(false)          # the story has its own section below; the rest of the test runs without its boxes
	await _frames(3)
	D.close_modal()
	# O1-O3: what is shown when. A new game has no coin and no album picture: the purse and the album button wait for them.
	var rv_hidden: bool = G.S["coins"] < 1.0 and not D.coins_shown() and not D.icon_shown("album") and not D.icon_shown("bag")
	var rv_new := []
	G.revealed.connect(func(id): rv_new.append(id))
	G.S["coins"] = 3.0
	G.S["album"].append({"id": "test", "text": "x", "emoji": "🏺"})
	G.changed.emit()
	await _frames(3)
	var rv_shown: bool = D.coins_shown() and D.icon_shown("album") and rv_new.has("coins") and rv_new.has("album") and G.S["revealed"].has("coins")
	G.inventory.add_item("stone", 3.0, true)       # the first packed thing shows the bag icon (and its thin bar)
	G.trip.pack("stone", 2)
	await _frames(3)
	var rv_bag: bool = D.icon_shown("bag") and rv_new.has("bag")
	G.trip.unpack_all()
	G.inventory.take("stone", 3.0)
	G.S["coins"] = 0.0
	G.changed.emit()
	await _frames(3)
	var rv_stays: bool = D.coins_shown()           # once shown, always shown
	G.S["album"].clear()
	print("reveal: hidden at the start %s, shown with the first coin and picture %s (told: %s), stays %s" % [rv_hidden, rv_shown, rv_new, rv_stays])
	if not (rv_hidden and rv_shown and rv_bag and rv_stays): print("FAIL reveal: see the line above")
	# the store's tile panel: pack one with 🎒 +1, the panel shows again with the new numbers, take it out again
	G.inventory.add_item("stone", 2.0, true)
	D.open_spot("storage")
	await _frames(2)
	D.item_panel("stone")
	await _frames(2)
	var tp_open: bool = D.modal_visible() and _modal_has("🎒 +1")
	_press_text("🎒 +1")
	await _frames(2)
	var tp_packed: bool = G.trip.packed("stone") == 1.0 and D.modal_visible() and _modal_has("↩ −1")
	_press_text("↩ −1")
	await _frames(2)
	var tp_back: bool = G.trip.packed("stone") == 0.0
	D.close_modal()
	D.close_sheet()
	G.inventory.take("stone", 2.0)
	print("store panel: opens %s, packs %s, unpacks %s" % [tp_open, tp_packed, tp_back])
	if not (tp_open and tp_packed and tp_back): print("FAIL store panel: see the line above")
	# M4: every thing has a weight (hidden): classes, a total
	var wt_ok: bool = G.inventory.weight_class("stone") == "heavy" and G.inventory.weight_of("stone") == 4.0 and G.inventory.weight_of("feather") == 0.1 and G.inventory.weight_class("straw") == "bulky"
	var load0: float = G.inventory.total_load()
	G.inventory.add_item("stone", 2.0, true)
	var wt_add: bool = is_equal_approx(G.inventory.total_load() - load0, 8.0)
	G.inventory.take("stone", 2.0)
	print("weights: classes %s, two stones add 8 load units %s" % [wt_ok, wt_add])
	if not (wt_ok and wt_add): print("FAIL weights: see the line above")
	# Phase 5.2: the story on screen: a two-page box (Next, Got it), then a bark as a speech bubble that stays; the scroll lists the box
	D.story_enabled(true)
	G.D["story"] = {
		"t_beat": {"kind": "beat", "chapter": 1, "when": [], "title": "Test beat", "pages": [{"text": "Page one for {player}."}, {"text": "Page two."}]},
		"t_bark": {"kind": "bark", "chapter": 1, "when": [], "text": "Bark hello."}}
	G.S["story_seen"].clear()
	G.changed.emit()
	await _frames(4)
	var st_box: bool = D.modal_visible() and _modal_has("Page one")
	var st_next := _press_text("Next")
	await _frames(2)
	var st_p2: bool = D.modal_visible() and _modal_has("Page two") and not _modal_has("Skip")
	var st_done := _press_text("Got it")
	await _frames(6)
	var st_closed: bool = not D.modal_visible() and G.story.seen("t_beat")
	var st_bubble: bool = D.bubbles() == 1 and G.story.seen("t_bark")
	var st_icon: bool = D.icon_shown("scroll")
	D.open_sheet("scroll")
	await _frames(2)
	var st_scroll := _press_text("Test beat")      # the scroll lists it; a tap reads it again, now with a Skip button
	await _frames(3)
	var st_again: bool = D.modal_visible() and _modal_has("Page one") and _modal_has("Skip") and G.story.pieces().size() == 2
	_press_text("Skip")
	await _frames(2)
	print("story: box %s, next %s, page 2 %s, closed %s, bubble %s, scroll icon %s, scroll lists it %s, read again with skip %s" % [st_box, st_next, st_p2, st_closed, st_bubble, st_icon, st_scroll, st_again])
	if not (st_box and st_next and st_p2 and st_done and st_closed and st_bubble and st_icon and st_scroll and st_again): print("FAIL story: see the line above")
	D.close_sheet()
	D.close_modal()
	D.clear_toasts()
	G.D["story"] = {}
	G.S["story_seen"].clear()
	G.S["revealed"].erase("scroll")
	D.story_enabled(false)
	var screen0: Vector2 = D.screen_size()
	var narrow_ok := true
	for w in [834.0, 744.0]:                       # iPad Pro 11" and iPad mini, upright
		D.set_screen_size(Vector2(w, 1194.0))
		await _frames(3)
		D.refresh()
		await _frames(3)
		if not D.hud_fits(): narrow_ok = false
	D.set_screen_size(screen0)
	await _frames(2)
	print("top bar fits 834 and 744 wide: ", narrow_ok)
	if not narrow_ok: print("FAIL top bar: wider than the screen")
	D.playback_speed(0.0)          # the farm catches up after a Time Quiz without waiting (the J4 check below runs at the real speed)
	# 1) open the book and pass the first card's quiz
	D.show_card("k_wheat")
	await _frames(2)
	await _click_through(func(): return G.done("k_wheat"))
	print("k_wheat learned: ", G.done("k_wheat"), " crop_wheat open: ", G.done("crop_wheat"))
	# 2) plant wheat in patch 1
	D.tap_patch("field", 0)
	await _frames(2)
	var planted := _press_text("🌱")
	await _frames(2)
	print("planted: ", planted, " patch: ", G.S["patches"][0]["crop"], " plants ", G.S["patches"][0]["plants"])
	# 2b) the whole field (J2): the patch's window has a "The whole field" section; one tap weeds every patch of the field
	G.S["energy"] = 20.0
	G.S["patches"][0]["weeds"] = 2.0
	D.tap_patch("field", 0)
	await _frames(2)
	var weeds_before := float(G.S["patches"][0]["weeds"])
	var wf_pressed := _press_text("Pick all weeds")
	await _frames(2)
	print("whole field: button pressed %s, weeds %s -> %s" % [wf_pressed, weeds_before, G.S["patches"][0]["weeds"]])
	if not wf_pressed or float(G.S["patches"][0]["weeds"]) >= 0.5: print("FAIL whole field: the weeds are still there")
	D.close_sheet()
	# 3) answer three Time Quiz questions
	var s0: int = G.S["step"]
	for k in range(3):
		D.show_time_quiz()
		await _frames(2)
		await _click_through(func(): return G.S["step"] > s0 + k, 250)   # only a right first try moves time
	print("time steps: ", G.S["step"] - s0)
	D.close_modal()
	# 4) rest a little: type the answer on the number pad, once quick and once too slow
	G.S["energy"] = 2.0
	D.show_rest()
	await _frames(2)
	var start_page: bool = D.rest_state().has("start") and not D.rest_state().has("pad")
	D.rest_go()
	await get_tree().create_timer(2.0).timeout      # ready … set … go!
	var e0: float = G.S["energy"]
	var pad = D.rest_state()["pad"]
	for ch in str(pad.question["answer"]): pad.key(ch)
	var e1: float = G.S["energy"]
	await get_tree().create_timer(0.9).timeout
	pad.timer.shift(30.0)                            # pretend the child took a long time
	for ch in str(pad.question["answer"]): pad.key(ch)
	var e2: float = G.S["energy"]
	D.close_modal()
	var wr: String = await _wrong_rest()
	print("rest energy: ", e0, " -> quick ", e1, " -> slow ", e2, "  (wrong-answer path: ", wr, ")  start page first: ", start_page)
	# J3: the Rest button first sends the farmer home, then the window opens
	D.go_rest()
	var rest_open_early: bool = D.modal_visible()
	await get_tree().create_timer(2.0).timeout
	print("go rest: window not yet open at once %s, open after the walk %s" % [not rest_open_early, D.modal_visible()])
	if rest_open_early or not D.modal_visible(): print("FAIL go rest: the window must open after the walk, not at once")
	D.close_modal()
	# J4: while the Time Quiz is open the farm keeps its old look; after it closes it catches up, and a tap jumps to the end
	D.playback_speed(1.0)
	var info0: String = D.info_text()
	D.show_time_quiz()
	await _frames(2)
	G.step_time()
	await _frames(3)
	var j4_held: bool = D.info_text() == info0 and D.playback_held()
	D.close_modal()
	await _frames(3)
	var j4_waiting: bool = D.info_text() == info0 and D.playback_playing()
	await get_tree().create_timer(3.8).timeout       # pause, rain (if it rained), the plants flicking, the last moment
	var j4_caught: bool = D.info_text() != info0 and not D.playback_playing()
	var info1: String = D.info_text()
	D.show_time_quiz()
	await _frames(2)
	G.step_time()
	D.close_modal()
	await _frames(3)
	D.tap_playback()
	await _frames(2)
	var j4_skipped: bool = D.info_text() != info1 and not D.playback_playing() and not D.playback_held()
	print("playback: held while open %s, old look while waiting %s, caught up %s, a tap skips %s" % [j4_held, j4_waiting, j4_caught, j4_skipped])
	if not (j4_held and j4_waiting and j4_caught and j4_skipped): print("FAIL playback: see the line above")
	D.playback_speed(0.0)
	await _frames(6)                 # refreshes still queued from the lines above must not cut the flick short
	# J4: a plant that moved on by two stages shows the one in between, 0.3 s each, and ends in the new state
	var fv0 = D.map().fields[0]
	var fp0: Dictionary = G.S["patches"][0]
	var fp0_saved: Dictionary = fp0.duplicate(true)
	fp0["crop"] = "crop_wheat"; fp0["plants"] = 1.0; fp0["growth"] = 0.0; fp0["ready"] = false
	fv0.refresh()
	fp0["growth"] = G.fields.grow_target(fp0); fp0["ready"] = true
	fv0.refresh(true)
	var seen := [str(fv0.patches[0].spec["stage"])]       # the stages the patch shows, in order, over the next second
	var t_flick := Time.get_ticks_msec()
	while Time.get_ticks_msec() - t_flick < 1000:
		await get_tree().process_frame
		var st_now := str(fv0.patches[0].spec["stage"])
		if seen[seen.size() - 1] != st_now: seen.append(st_now)
	print("flick: ", seen, "  (ms per frame about ", 1000.0 / maxf(1.0, float(Engine.get_frames_per_second())), ")")
	var fl_start: String = seen[0]
	var fl_mid: String = seen[1] if seen.size() > 2 else ""
	var fl_end: String = seen[seen.size() - 1]
	if not (fl_start == "sprout" and fl_mid == "grown" and fl_end == "ready"): print("FAIL flick: the plant must go sprout, grown, ready")
	for k in fp0_saved: fp0[k] = fp0_saved[k]
	fv0.refresh()
	# r9: a sum left unanswered (back to the farm) leaves no trace in the learning record
	D.show_rest()
	await _frames(1)
	var mr: Dictionary = G.math.rec(G.learn_record())
	var before_left := [int(mr.get("n", 0)), int(mr.get("turn", 0)), int(mr.get("since_new", 0)), mr["items"].size()]
	D.rest_go()
	await get_tree().create_timer(2.0).timeout
	var sum_shown: bool = not D.rest_state()["pad"].question.is_empty()
	D.close_modal()
	await _frames(2)
	var after_left := [int(mr.get("n", 0)), int(mr.get("turn", 0)), int(mr.get("since_new", 0)), mr["items"].size()]
	print("r9 rest left mid-sum: question shown %s, record %s -> %s (same: %s)" % [sum_shown, before_left, after_left, before_left == after_left])
	# 4b) water: fetch from the pond with the bucket; a locked place is a mystery; the road has a sheet
	var w0: float = G.S["water"]
	G.S["water"] = 0.0
	G.actions.perform("fetch_water", G.actions.farmer)
	print("fetch water: 0 -> ", G.S["water"], " (was ", w0, ")  mystery barn: ", D.mystery("barn"), "  road open: ", D.is_open("road"))
	D.open_spot("road")
	await _frames(2)
	D.open_spot("barn")
	await _frames(2)
	print("barn sheet title: ", D.sheet_title(), "  pond: ", D.is_open("pond"))
	D.close_sheet()
	# 4c) pests eat a share: put many pests on the farm, step time, and see the birds come when the pop-up closes
	G.S["patches"][0]["crop"] = "crop_wheat"
	G.S["patches"][0]["plants"] = 3.0
	G.S["patches"][0]["growth"] = 0.0
	G.S["patches"][0]["ready"] = false
	G.S["pests"] = 12.0
	var info: Dictionary = G.step_time()
	print("pests eat share: ", snappedf(float(info.get("eat_share", 0.0)), 0.001), " eaten: ", info.get("eaten", {}), " plants now ", snappedf(float(G.S["patches"][0]["plants"]), 0.01))
	D.play_fx()
	await _frames(5)
	# 4d) clearing in steps, straw cannot be sold, gathering arrives at once, later fields are a mystery
	var s0w: int = G.progression.step_index("clear_weeds")
	G.S["energy"] = 20.0
	G.progression.unlock("clear_weeds")
	G.inventory.add_item("straw", 3.0)
	G.trip.test_square()
	var sold: bool = G.trade.sell("straw", 1.0)
	G.trip.leave()
	var sticks0: float = G.inventory.count("stick")
	var gathered: bool = G.crafting.start_recipe("gather_sticks")
	var again: bool = G.crafting.start_recipe("gather_sticks")
	print("clear_weeds step ", s0w, " -> ", G.progression.step_index("clear_weeds"), "/", G.progression.steps_of("clear_weeds").size(), "  straw sold: ", sold,
		"  sticks ", sticks0, " -> ", G.inventory.count("stick"), " (gathered ", gathered, ", again right away: ", again, ")")
	# 4e) round 6: patches open after the weeds, no seeds no planting, yields average, building steps wait, gift cards, water, players
	var p0: int = G.progression.plots()
	G.S["energy"] = 20.0
	G.progression.unlock("clear_weeds")                      # step 2 of 5: the two new patches can be planted now
	var p1: int = G.progression.plots()
	var q_new: float = float(G.S["patches"][p1 - 1].get("quality", 1.0))
	G.S["seeds"]["crop_wheat"] = 0.0
	var plan0: Dictionary = G.fields.plant_plan("field", "crop_wheat")
	var tot := 0.0
	for _r in range(200): tot += float(G.fields.harvest_amounts(G.nodes["crop_wheat"], 1, 1.0, 1.0)["wheat"])
	G.S["unlocked"]["stick_fence"] = true
	G.inventory.add_item("stick", 20.0); G.inventory.add_item("straw", 20.0); G.inventory.add_item("rope", 5.0); G.S["coins"] = 1500.0; G.S["energy"] = 20.0
	G.S["unlocked"]["workbench"] = true; G.S["unlocked"]["clear_stumps"] = true; G.S["unlocked"]["k_birds"] = true; G.invalidate_caps()
	var st_ok: bool = G.progression.unlock("scarecrow_1")
	var why: String = str(G.progression.can_unlock("scarecrow_1").get("why", ""))
	var w_before: float = G.S["water"]
	G.step_time()
	var w_after: float = G.S["water"]
	for gid in ["gc_deep_pockets", "gc_spring_water", "gc_early_bird"]:
		G.S["gift_pending"].append({"from": "Test", "emoji": "💌", "text": "", "offer": [gid]})
		G.rewards.pick_gift(gid)
	print("r6: plots ", p0, " -> ", p1, " (new patch quality ", q_new, ")  no seeds -> plants ", plan0["plants"], "  wheat per plant ≈ ", snappedf(tot / 200.0, 0.01),
		"  scarecrow step ", st_ok, " then '", why, "'  water ", w_before, " -> ", w_after, " after a question  gift cards active ", G.S["gift_active"].size(), "/", G.S["gift_owned"].size(),
		"  celebrations queued ", D.celebrations().size(), "  slug ", G.slug("Mia Lou!"))
	D.tap_patch("field", 12)
	await _frames(1)
	print("later field patch opens: ", D.sheet_kind(), "  ruins_workshop at: ", Spots.spot_of(G, "ruins_workshop"), "  mystery workshop: ", D.mystery("workshop"))
	D.close_sheet()
	# 4f) round 7: Rest levels and repetition, market demand, prices, postcards, perks, the farmer
	G.L = {}
	var r0: Dictionary = G.needs.arith_info()
	for _i in range(5):
		var q: Dictionary = G.needs.rest_question()
		G.needs.rest_result(q, true, true)
	var r1: Dictionary = G.needs.arith_info(str(G.needs.rest_question()["level"]))
	var wrong_q: Dictionary = G.needs.rest_question()
	G.needs.rest_result(wrong_q, false, false)
	for _i in range(3):
		var q2: Dictionary = G.needs.rest_question()
		G.needs.rest_result(q2, false, false)
	var boosters := 0
	var back_soon := false
	for _i in range(6):
		var q3: Dictionary = G.needs.rest_question()
		if q3.get("booster", false): boosters += 1
		if q3["key"] == wrong_q["key"]: back_soon = true
		G.needs.rest_result(q3, true, false)
	var sizes := []
	var bad := []
	for id in G.math.levels:
		var p: Dictionary = G.math.pool(id)
		sizes.append("%s:%d" % [id, p["keys"].size()])
		for k in p["keys"]:
			var tk: Array = p["by"][k]
			if str(tk[0]) == "" or not str(tk[1]).contains("?"): bad.append(id + " " + k)
	print("r7 sums: level ", r0["name"], " -> ", r1["name"], " after 5 quick  struggling ", G.math.struggling(G.L["math"]),
		"  boosters in 6: ", boosters, "  wrong one back soon: ", back_soon, "  hint 32-17: '", G.math.pm_hint(32, "-", 17), "'  hint 7x8: '", G.math.task("7 × 8", "md.f07")[2],
		"'  medals ", G.math.medal_count(G.L), "  levels ", G.math.levels.size(), "  bad tasks ", bad.slice(0, 5))
	print("r7 pools: ", " ".join(sizes))
	G.inventory.add_item("carrot", 10.0, true)
	var c0: float = G.S["coins"]
	G.trip.test_square()
	G.trade.sell("carrot", 10.0)
	G.trip.leave()
	var got10: float = G.S["coins"] - c0
	var low: float = G.trade.demand_factor("carrot")
	for _i in range(10): G.step_time()
	print("r7 market: 10 carrots -> ", snappedf(got10, 0.1), " coins (full ", 10.0 * G.trade.full_price("carrot"), ")  price now ", snappedf(low, 0.01),
		" -> after 10 questions ", G.trade.demand_factor("carrot"), "  porridge ", G.inventory.value_of("porridge"), " vs 2 wheat ", 2.0 * G.inventory.value_of("wheat"),
		"  honey cake ", G.inventory.value_of("honey_cake"), "  worth porridge ", G.trade.recipe_worth("porridge"))
	var f0: int = G.rewards.friends().size()
	G.S["energy"] = 40.0
	G.S["unlocked"]["clear_weeds"] = true
	G.progression.unlock("sq_lost_goat")
	var f1: int = G.rewards.friends().size()
	G.S["postcards"] = []
	var pend0: int = G.S["gift_pending"].size()
	G.rewards.offer_gift("a test")
	var pc: Dictionary = G.rewards.postcard_pending()
	print("r7 postcards: friends ", f0, " -> ", f1, "  postcard from '", pc.get("from", ""), "' choices ", pc.get("offer", []).size(), " (pending ", pend0, " -> ", G.S["gift_pending"].size(), ")",
		"  butterflies perk ", G.rewards.perk_on("perk_butterflies"), "  shop gone: ", not G.has_method("buy_gift"))
	if not pc.is_empty(): G.rewards.pick_gift(pc["offer"][0])
	print("r7 album postcards ", G.S["postcards"].size(), "  celebrations queued ", D.celebrations())
	D.close_modal()
	D.celebrations().clear()
	var av = D.map().avatar
	var a0: Vector2 = av.feet
	var path: PackedVector2Array = D.map().find_path(a0, Vector2(600, 900))
	av.walk_to(Vector2(330, 330))
	await get_tree().create_timer(1.0).timeout
	print("r7 farmer: at ", a0, " path to the barn side ", path.size(), " points, walked to ", av.feet, " moving ", av.moving, "  in objects: ", av.get_parent() == D.map().objects)
	# 4h) round 8: quiz ids, 3-4 options, picture questions, translations; stoking; bigger loads; rooting out; dynamic prices
	var ids := {}
	var dup := 0
	for q in G.pack_questions:
		if ids.has(q.get("id", "")): dup += 1
		ids[q.get("id", "")] = true
	for cid in G.card_ids:
		for q in G.nodes[cid].get("questions", []):
			if ids.has(q.get("id", "")): dup += 1
			ids[q.get("id", "")] = true
	var opts := {}
	var pics := 0
	for i in range(60):
		var tq: Dictionary = G.knowledge.next_time_question()
		opts[tq["answers"].size()] = int(opts.get(tq["answers"].size(), 0)) + 1
		if tq.get("pictures", false): pics += 1
		assert(_atext_ok(tq), "answer missing")
	var picq: Dictionary = {}
	for q in G.pack_questions:
		if str(q.get("id", "")) == "PIC-004": picq = q
	var shown: Dictionary = G.knowledge.shuffled_q(picq, "", 0, false)
	var de: Dictionary = G.quiz.load_texts("res://data/i18n/quiz-de.json")
	var shown_de: Dictionary = G.quiz.present(picq, G.rng, 4, de)
	var con: Dictionary = {}
	for q in G.pack_questions:
		if str(q.get("id", "")) == "CON-001": con = q
	var con_q: Dictionary = G.knowledge.shuffled_q(con, "", 0, false)
	G.knowledge.time_result(shown, true)
	# J10: a question answered wrong at the first try comes back right after the next one
	var qa: Dictionary = G.knowledge.next_time_question()
	G.knowledge.retry_after_next(qa)
	var qb: Dictionary = G.knowledge.next_time_question()
	var qc: Dictionary = G.knowledge.next_time_question()
	print("r10 first-try rule: wrong one back after one other: ", qb.get("id", "") != qa.get("id", "") and qc.get("id", "") == qa.get("id", ""))
	print("r8 quiz: ", ids.size(), " ids, doubles ", dup, "  options per question ", opts, "  picture questions ", pics, "/60",
		"  PIC-004 pictures ", shown["pictures"], " img '", shown["img"], "' right '", shown["answers"][shown["correct"]]["text"], "'",
		"  German: '", shown_de["q"], "' / '", shown_de["answers"][shown_de["correct"]]["text"], "'",
		"  CON-001 filled to ", con_q["answers"].size(), "  record key PIC-004: ", G.learn_record()["quiz"]["items"].has("PIC-004"))
	D.show_time_quiz()
	await _frames(2)
	D.close_modal()
	D.show_question(D.modal_box(), shown, func(_ft): pass)
	await _frames(2)
	print("r8 picture buttons: ", D.modal_box().get_child_count(), " rows in the quiz box")
	D.close_modal()
	G.S["woodpile"] = 0.0
	G.inventory.add_item("stick", 10.0)
	G.S["unlocked"]["campfire"] = true; G.S["unlocked"]["tin_pot"] = true; G.invalidate_caps()
	var cook_rid := ""
	for rid in G.recipes:
		if G.crafting.recipe_fuel(rid) > 0.0 and G.crafting.recipe_open(rid) and cook_rid == "": cook_rid = rid
	var cooked_cold := false
	var stoked := 0.0
	if cook_rid != "":
		for k in G.recipes[cook_rid].get("inputs", {}): G.inventory.add_item(k, 5.0)
		G.S["energy"] = 20.0
		cooked_cold = G.crafting.start_recipe(cook_rid)
		stoked = G.crafting.stoke(G.crafting.recipe_fuel(cook_rid))
	print("r8 woodpile: ", cook_rid, " cooks with an empty woodpile: ", cooked_cold, "  stoked +", stoked, " -> woodpile ", G.S["woodpile"])
	var b0: int = G.crafting.recipe_batch("gather_sticks")
	G.S["unlocked"]["gathering_basket"] = true; G.invalidate_caps()
	var b1: int = G.crafting.recipe_batch("gather_sticks")
	G.S["running"].erase(G.crafting.chain_root("wild_edge"))
	G.S["energy"] = 20.0
	var st0: float = G.inventory.count("stick")
	var en0: float = G.S["energy"]
	G.crafting.start_recipe("gather_sticks")
	print("r8 carry: loads per tap ", b0, " -> ", b1, "  sticks +", G.inventory.count("stick") - st0, " for ", snappedf(en0 - float(G.S["energy"]), 0.01), " energy")
	var fib0: float = G.inventory.count("fiber")
	G.S["energy"] = 20.0
	G.crafting.do_polish("polish_rootout")
	print("r8 root out: fibre +", G.inventory.count("fiber") - fib0)
	G.S["dynamic"] = true
	G.S["pace"] = 20.0; G.S["pace_n"] = 30; G.S.erase("flex")
	var flex_open := ""
	for id in G.nodes:
		if flex_open != "" or not G.progression.is_open(id) or not (G.nodes[id]["type"] in G.pace.flex_cfg().get("types", [])): continue
		for k in G.nodes[id].get("cost", {}):
			if k != "energy" and float(G.nodes[id]["cost"][k]) >= 2.0: flex_open = id
	if flex_open != "":
		var base_c: Dictionary = G.nodes[flex_open]["cost"]
		var flex_c: Dictionary = G.pace.node_cost_base(flex_open)
		print("r8 dynamic prices: pace ratio ", snappedf(G.pace.pace_ratio(), 0.01), "  ", flex_open, " factor ", G.pace.flex_factor(flex_open), "  ", base_c, " -> ", flex_c, "  tip: ", G.pace.flex_tip(flex_open))
	else: print("r8 dynamic prices: no open goal to test")
	G.S["dynamic"] = false; G.S.erase("flex")
	# r9: the share of book reviews in the Time Quiz, set in Settings (5% steps, 0..100%)
	var rs0: float = G.pace.review_share()
	G.pace.set_review_share(0.52); var rs1: float = G.pace.review_share()
	G.pace.set_review_share(1.4); var rs2: float = G.pace.review_share()
	G.S.erase("review_share")
	print("r9 review share: start %.2f -> 0.52 gives %.2f, 1.4 gives %.2f, back to %.2f" % [rs0, rs1, rs2, G.pace.review_share()])
	# r9: sounds — every name the game plays exists in data/sounds.json; buses; switching music and effects
	var snd = get_node("/root/Sound")
	var names_missing := []
	for nm in ["tap", "open", "close", "right", "wrong", "rest_right", "rest_wrong", "harvest", "plant", "weed", "dig", "chop", "cook", "craft", "smith", "build", "water", "coin", "collect", "page", "book", "celebrate", "levelup", "medal", "tired", "lightning", "streak", "coin_shower", "confetti", "rainbow", "sparkle", "breeze", "chicken", "cow", "sheep", "goat", "pony", "bees", "cat", "birds"]:
		if not snd.has(nm): names_missing.append(nm)
		snd.play(nm)
	snd.music("farm", "spring"); snd.music("quiz"); snd.music("rest")
	var m0: bool = snd.music_on
	snd.set_music(false); snd.set_music(m0)
	print("r9 sounds: names missing %s, buses Music %d SFX %d" % [names_missing, AudioServer.get_bus_index("Music"), AudioServer.get_bus_index("SFX")])
	print("r9 grown-up lock: open at start %s, 'Farm ' %s, 'cow' %s" % [D.grownup_open(), D.password_ok("Farm "), D.password_ok("cow")])
	D.show_menu()
	await _frames(2)
	D.close_modal()
	D.set_grownup_open(true)
	D.show_menu()
	await _frames(2)
	D.close_modal()
	D.set_grownup_open(false)
	D.open_sheet("album")
	await _frames(2)
	D.close_sheet()
	# 5) visit every place on the map and every page
	var n := 0
	for sid in D.map().slots:
		D.open_spot(sid)
		await _frames(1)
		n += 1
	for k in ["spot:field", "goals", "album", "log"]:
		D.open_sheet(k)
		await _frames(1)
	D.press_goal()
	await _frames(2)
	print("places ok: ", n, " sheet open: ", D.sheet_visible(), " goal: ", D.goal_id(), " log: ", G.S["log"].slice(-3))
	# 6) buildings with an inside: pretend they stand, open each inside and one corner, and come back
	D.close_sheet()
	for b in ["cottage", "barn_1", "workshop_1"]:
		G.S["unlocked"][b] = true
	G.invalidate_caps()
	D.refresh()
	await _frames(2)
	var insides := []
	for parent in ["home", "barn", "workshop"]:
		D.open_spot(parent)
		await _frames(2)
		var opened: bool = D.modal_visible()
		var corners: Array = Spots.interior(parent)["members"]
		D.enter_corner(corners[1], parent)
		await _frames(2)
		var sheet_ok: bool = D.sheet_visible() and D.sheet_kind() == "spot:" + corners[1]
		D.close_sheet()
		await _frames(2)
		insides.append("%s inside:%s corner:%s back:%s" % [parent, opened, sheet_ok, D.modal_visible()])
		D.close_modal()
	print("insides: ", insides, " house visible: ", D.map().slots["home"].visible, " tent hidden: ", not D.map().slots["living"].visible)
	get_tree().quit()

func _atext_ok(q: Dictionary) -> bool:
	for a in q["answers"]:
		if str(a.get("text", "")) == "" and str(a.get("emoji", "")) == "": return false
	return q["correct"] >= 0 and q["correct"] < q["answers"].size()

func _frames(n: int) -> void:
	for _i in range(n): await get_tree().process_frame

func _buttons(node: Node, out: Array) -> void:
	for c in node.get_children():
		if c is Button and not c.disabled and c.visible: out.append(c)
		_buttons(c, out)

func _modal_has(t: String) -> bool:
	var found := false
	var stack: Array = [D.modal_box()]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n is Label and n.text.contains(t): found = true
		if n is Button and n.text.contains(t): found = true
		stack.append_array(n.get_children())
	return found

func _press_text(t: String) -> bool:
	var bs := []
	_buttons(D.modal_box(), bs)
	_buttons(D.content(), bs)
	for b in bs:
		if b.text.contains(t):
			b.emit_signal("pressed"); return true
	return false

func _click_through(goal: Callable, tries := 40) -> void:
	for _i in range(tries):
		if goal.call(): return
		var bs := []
		_buttons(D.modal_box(), bs)
		var pressed := false
		var nxt: Button = null
		for b in bs:
			if b.disabled: continue
			var t: String = b.text
			if t.begins_with("Next question"):
				nxt = b
				continue
			if t.begins_with("✖") or t.begins_with("🔊") or t.begins_with("Back") or t.begins_with("⬅️"): continue
			b.emit_signal("pressed"); pressed = true
			break
		if not pressed and nxt != null:   # a wrong first try does not move time: go on to the next question
			nxt.emit_signal("pressed"); pressed = true
		await _frames(2)
		if not pressed:
			await get_tree().create_timer(0.8).timeout

func _wrong_rest() -> String:
	D.show_rest()
	await _frames(1)
	D.rest_go()
	await get_tree().create_timer(2.0).timeout
	var before: float = G.S["energy"]
	var pad = D.rest_state()["pad"]
	pad.typed = "99999"              # surely wrong
	pad.enter()
	var ok: bool = float(G.S["energy"]) == before and str(pad.fb_lbl.text).begins_with("❌")
	D.close_modal()
	return "ok" if ok else "FAILED"
