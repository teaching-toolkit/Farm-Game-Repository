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
	# interface-feel/09: the book box's sign (📖 a card to read, ❓ a card quiz) shows only for a card the library shows now
	var bk_saved: Array = [G.S["unlocked"].duplicate(true), G.S["read_done"].duplicate(true), G.S["reading"]]
	var bk_card := func(): return D.badge("library") in ["📖", "❓"]
	var bk_new: bool = bk_card.call() and G.knowledge.card_status("k_wheat") == "quiz"     # a new game: the first card's quiz waits
	for cid in G.card_ids:                         # every card of this chapter in the first book learned
		if G.nodes[cid]["requires"][0] == "book_basics" and int(G.nodes[cid].get("chapter", 1)) <= G.chapter(): G.S["unlocked"][cid] = true
	G.S["unlocked"].erase("k_hay")
	var bk_later: bool = G.knowledge.card_status("k_compost") == "readable" and int(G.nodes["k_compost"]["chapter"]) > G.chapter()
	G.S["unlocked"]["k_hay"] = true
	var bk_none: bool = not bk_card.call()          # only a later chapter's card (k_compost) could be read: no sign
	G.S["unlocked"].erase("k_hay")                 # a card of this chapter can be read: the sign
	var bk_one: bool = D.badge("library") == "📖"
	var bk_reading: bool = G.knowledge.start_reading("k_hay") and not bk_card.call()
	G.S["reading"] = ""
	G.S["read_done"]["k_hay"] = true               # read: its quiz waits
	var bk_quiz: bool = D.badge("library") == "❓"
	G.S["unlocked"]["k_hay"] = true                # learned: no sign
	var bk_gone: bool = not bk_card.call()
	G.S["unlocked"] = bk_saved[0]; G.S["read_done"] = bk_saved[1]; G.S["reading"] = bk_saved[2]
	G.invalidate_caps()
	G.changed.emit()
	await _frames(2)
	D.clear_toasts()
	print("book box sign: new game (first card's quiz) %s, a later chapter's card makes none %s (it is readable %s), a card to read %s, none while reading %s, quiz %s, gone when learned %s" % [bk_new, bk_none, bk_later, bk_one, bk_reading, bk_quiz, bk_gone])
	if not (bk_new and bk_later and bk_none and bk_one and bk_reading and bk_quiz and bk_gone): print("FAIL book box sign: see the line above")
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
	var tb_ok := true
	var tb_txt := []
	for w in [834.0, 744.0]:                       # iPad Pro 11" and iPad mini, upright
		D.set_screen_size(Vector2(w, 1194.0))
		await _frames(3)
		D.refresh()
		await _frames(3)
		if not D.hud_fits(): narrow_ok = false
		# interface-feel/06: the goal is symbol and name only, its text sized to fit; the season row right under the bars; no chapter line
		var gid: String = D.goal_id()
		var gt: String = D.goal_text()
		var name_only: bool = gid == "" or (gt.ends_with(str(G.nodes[gid]["name"])) and not gt.contains("⚡"))
		var sb: Rect2 = D.season_box()
		var bb: Rect2 = D.bars_box()
		var under: bool = sb.position.y >= bb.end.y - 1.0 and sb.position.y - bb.end.y < 12.0 and sb.position.x >= bb.position.x - 30.0 and sb.end.x <= bb.end.x + 1.0 and sb.size.x >= bb.size.x * 0.6
		tb_txt.append("%d: goal '%s' at %d px, season row %dx%d under bars %d wide" % [w, gt, D.goal_text_size(), sb.size.x, sb.position.y - bb.end.y, bb.size.x])
		if not (name_only and under and not D.info_shown() and D.goal_text_size() >= 11): tb_ok = false
	print("top bar layout: %s  %s" % [tb_ok, "; ".join(tb_txt)])
	if not tb_ok: print("FAIL top bar layout: see the line above")
	D.set_screen_size(screen0)
	await _frames(2)
	print("top bar fits 834 and 744 wide: ", narrow_ok)
	if not narrow_ok: print("FAIL top bar: wider than the screen")
	# interface-feel/05: one cube is one (no "×5"); a big amount grows the bar in rows and columns and still fits the top bar's room
	var UIk = preload("res://kits/ui/ui.gd")
	var cb_ok := true
	var cb_txt := []
	for n in [8.0, 30.0, 65.0, 100.0, 200.0, 450.0]:
		var cb = UIk.stock_bar(n * 0.5, n, Color.GOLD, 80.0)
		cb.max_h = 62.0
		add_child(cb)
		await _frames(1)
		var ms: Vector2 = cb.get_combined_minimum_size()
		var cells: int = cb.per_row * cb.rows
		var ok: bool = cb.unit == 1.0 and cells >= int(n) and cells - int(n) < cb.per_row and ms.y <= 62.0 + 0.5 and ms.x - cb._num_w <= 80.0 + 0.5
		cb_txt.append("%d=%dx%d@%d" % [n, cb.per_row, cb.rows, int(cb.cube)])
		if not ok: cb_ok = false
		cb.free()
	print("cube bars, one cube each, fit 80×62: %s %s" % [cb_ok, " ".join(cb_txt)])
	if not cb_ok: print("FAIL cube bars: see the line above")
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
	# interface-feel/10: he is inside while Rest is open, and comes out again after it closes
	var hid_inside: bool = D.farmer_hidden()
	D.close_modal()
	var still_inside: bool = D.farmer_hidden()
	await get_tree().create_timer(G.feel("rest.inside") + G.feel("rest.appear") + 0.5).timeout
	var back_out: bool = D.farmer_shown()
	print("rest farmer: hidden while resting %s, still inside just after closing %s, back and visible after %s" % [hid_inside, still_inside, back_out])
	if not hid_inside or not still_inside or not back_out: print("FAIL rest farmer: he must disappear while resting and come back afterwards")
	# a tap skips: during the walk it opens Rest at once, while he comes out it shows him at once
	D.go_rest()
	await _frames(2)
	var caught: bool = D.tap_rest_walk()
	var open_at_once: bool = D.modal_visible() and D.farmer_hidden()
	D.close_modal()
	await _frames(2)
	var caught2: bool = D.tap_rest_walk()
	var shown_at_once: bool = D.farmer_shown()
	await _frames(2)
	print("rest skip: tap on the walk opens Rest at once %s, tap while coming out shows him at once %s" % [caught and open_at_once, caught2 and shown_at_once])
	if not (caught and open_at_once and caught2 and shown_at_once): print("FAIL rest skip: a tap must skip the walk and the coming out")
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
	# time-question/06: the farm news is shown on the farm with a short line under it; after a walk it waits until the farm is seen
	D.clear_toasts()
	await _frames(2)
	D.playback_begin()
	G.step_time()
	D.playback_step({"rain": true, "removed": 2, "eat_share": 0.1})
	D.playback_postpone()                       # a right answer on a walk: the pop-up closes into a place
	D.open_sheet("forest")
	await _frames(3)
	var n6_waits: bool = D.playback_waiting() and not D.playback_held() and not _toast_has("Rain!")
	D.close_sheet()                             # back on the farm
	await _frames(3)
	var n6_plays: bool = D.playback_playing()
	await get_tree().create_timer(G.feel("playback.pause") + 0.3).timeout      # the short pause, then the rain with its line
	var n6_rain: bool = n6_plays and _toast_has("Rain!") and not _toast_has("scarecrow")
	D.tap_playback()                            # a tap: the lines not shown yet still come
	await _frames(2)
	var n6_all: bool = _toast_has("scarecrow chased off 2 pests") and _toast_has("Pests ate 10%") and not D.playback_waiting()
	print("farm news: a walk's news waits under the sheet %s, plays when the farm is seen %s, nothing lost on a tap %s" % [n6_waits, n6_rain, n6_all])
	if not (n6_waits and n6_rain and n6_all): print("FAIL farm news: see the line above")
	D.clear_toasts()
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
	var gathered: bool = G.actions.perform("recipe", G.actions.farmer, {"rid": "gather_sticks"})["done"]
	var again: bool = G.actions.perform("recipe", G.actions.farmer, {"rid": "gather_sticks"})["done"]
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
	D.clear_celebrations()
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
		var tq: Dictionary = G.timeq.next()
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
	G.timeq.record(shown, true)
	# J10: a question answered wrong at the first try comes back right after the next one
	var qa: Dictionary = G.timeq.next()
	G.timeq.record(qa, false)
	var qb: Dictionary = G.timeq.next()
	var qc: Dictionary = G.timeq.next()
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
		cooked_cold = G.actions.perform("recipe", G.actions.farmer, {"rid": cook_rid})["done"]
		stoked = G.crafting.stoke(G.crafting.recipe_fuel(cook_rid))
	print("r8 woodpile: ", cook_rid, " cooks with an empty woodpile: ", cooked_cold, "  stoked +", stoked, " -> woodpile ", G.S["woodpile"])
	var b0: int = G.crafting.recipe_batch("gather_sticks")
	G.S["unlocked"]["gathering_basket"] = true; G.invalidate_caps()
	var b1: int = G.crafting.recipe_batch("gather_sticks")
	G.S["running"].erase(G.crafting.chain_root("wild_edge"))
	G.S["energy"] = 20.0
	var st0: float = G.inventory.count("stick")
	var en0: float = G.S["energy"]
	G.actions.perform("recipe", G.actions.farmer, {"rid": "gather_sticks"})
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
	# parent-controls/01: the energy share of a slow right Rest answer (per farm, 10% steps, default 20%)
	var ss_e0 := float(G.S["energy"])
	var ss_default: float = G.needs.slow_share()
	var ss_gains := []
	for sh in [0.0, 0.2, 1.0]:
		G.needs.set_slow_share(sh)
		G.S["energy"] = 0.0
		ss_gains.append(G.needs.rest_correct(false))
	G.S["energy"] = 0.0
	var ss_quick: float = G.needs.rest_correct(true)
	G.needs.set_slow_share(0.34); var ss_snap: float = G.needs.slow_share()
	G.S.erase("rest_slow_share"); G.S["energy"] = ss_e0
	print("slow Rest share: default %.2f; slow answer at 0/20/100%% gives %s, a quick one %.2f; 0.34 snaps to %.2f" % [ss_default, str(ss_gains), ss_quick, ss_snap])
	if not (is_equal_approx(ss_default, 0.2) and is_equal_approx(ss_gains[0], 0.0) and is_equal_approx(ss_gains[1], 0.2 * ss_quick)
			and is_equal_approx(ss_gains[2], ss_quick) and is_equal_approx(ss_snap, 0.3)): print("FAIL slow Rest share: see the line above")
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
	# interface-feel/11: the testing buttons start off; the grown-up switch turns them on and off again (tests that want them switch them on)
	var ch_off0: bool = not G.cheats_visible() and not D.cheats_shown()
	var ch_on_pressed := _press_text("Testing buttons on the farm")
	await _frames(2)
	var ch_on: bool = G.cheats_visible() and D.cheats_shown()
	var ch_off_pressed := _press_text("Testing buttons on the farm")
	await _frames(2)
	var ch_off: bool = not G.cheats_visible() and not D.cheats_shown()
	print("testing buttons: off at the start %s, switched on %s, switched off %s" % [ch_off0, ch_on, ch_off])
	if not (ch_off0 and ch_on_pressed and ch_on and ch_off_pressed and ch_off): print("FAIL testing buttons: see the line above")
	D.close_modal()
	D.set_grownup_open(false)
	D.open_sheet("album")
	await _frames(2)
	D.close_sheet()
	# money-market/05: on the village square, closing a window keeps the farmer there; only 🏠 Back home goes home
	D.close_modal()
	D.close_sheet()
	G.trip.test_square()
	D.open_spot("market")
	await _frames(2)
	var sq_open: bool = D.sheet_visible() and D.sheet_kind() == "spot:market" and not D.sheet_close_shown()
	D.close_sheet()                                # the ✖ (hidden here) or any other way of closing the window
	await _frames(2)
	var sq_stays: bool = G.trip.at_square() and D.sheet_visible() and D.sheet_kind() == "spot:market"
	D.open_sheet("bag")
	await _frames(2)
	var sq_bag: bool = D.sheet_close_shown()
	D.close_sheet()                                # closing the bag comes back to the square
	await _frames(2)
	var sq_back: bool = G.trip.at_square() and D.sheet_visible() and D.sheet_kind() == "spot:market"
	var sq_home_pressed := _press_text("Back home")
	await _frames(2)
	var sq_home: bool = not G.trip.at_square() and not D.sheet_visible()
	print("square: opens without ✖ %s, closing keeps the square %s, the bag's ✖ %s and back to the square %s, Back home goes home %s" % [sq_open, sq_stays, sq_bag, sq_back, sq_home])
	if not (sq_open and sq_stays and sq_bag and sq_back and sq_home_pressed and sq_home): print("FAIL square: see the line above")
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
		if parent == "workshop":
			# interface-feel/08: no ghost symbols: a corner with nothing of it within reach is not drawn (G.reveal), and none is drawn faded
			var drawn: Dictionary = D.interior_corners()
			var ws_ok: bool = drawn.has("ws_build") and not drawn.has("ws_loom") and not drawn.has("ws_fire") and not drawn.values().has(true)
			for m in Spots.interior("workshop")["members"]:
				if drawn.has(m) != G.reveal.shown(m): ws_ok = false
			D.close_modal()
			var wb_saved: Array = [G.S["unlocked"].has("workbench"), G.S["unlocked"].has("ruins_workshop")]
			G.S["unlocked"].erase("workbench")          # as before the workbench (and its ruins cleared): its corner is not drawn
			G.S["unlocked"].erase("ruins_workshop")
			G.S["revealed"].erase("ws_bench")
			G.invalidate_caps()
			D.open_spot(parent)
			await _frames(2)
			var drawn1: Dictionary = D.interior_corners()
			D.close_modal()
			if wb_saved[1]: G.S["unlocked"]["ruins_workshop"] = true
			G.S["unlocked"]["workbench"] = true        # the workbench built: its corner comes into view, for good, not faded
			G.invalidate_caps()
			D.open_spot(parent)
			await _frames(2)
			var drawn2: Dictionary = D.interior_corners()
			if not wb_saved[0]: G.S["unlocked"].erase("workbench")
			G.invalidate_caps()
			var ws_more: bool = not drawn1.has("ws_bench") and drawn2.has("ws_bench") and not drawn2["ws_bench"] and not drawn2.has("ws_loom")
			print("workshop corners (id: faded): now %s, before the workbench %s, with it %s; only what is reached %s, the bench comes %s" % [drawn, drawn1, drawn2, ws_ok, ws_more])
			if not (ws_ok and ws_more): print("FAIL workshop corners: see the line above")
		var corners: Array = Spots.interior(parent)["members"]
		D.enter_corner(corners[1], parent)
		await _frames(2)
		var sheet_ok: bool = D.sheet_visible() and D.sheet_kind() == "spot:" + corners[1]
		D.close_sheet()
		await _frames(2)
		insides.append("%s inside:%s corner:%s back:%s" % [parent, opened, sheet_ok, D.modal_visible()])
		D.close_modal()
	print("insides: ", insides, " house visible: ", D.map().slots["home"].visible, " tent hidden: ", not D.map().slots["living"].visible)
	# the checks below change the farm (a step of time): they come last, so the lines above stay comparable with older runs
	# interruption-queue/03: a celebration that comes during the Time Quiz waits in line until the farm has caught up, then shows once
	D.playback_speed(1.0)
	D.show_time_quiz()
	await _frames(2)
	G.step_time()
	D.celebrate("workbench")
	D.celebrate("workbench")
	await _frames(3)
	var iq_quiz: bool = D.celebrations() == ["workbench"]
	D.close_modal()
	for _i in range(300):                      # until the farm starts to show the new state (after the pause and any rain)
		if not D.playback_held(): break
		await _frames(1)
	await _frames(3)
	var iq_catchup: bool = D.playback_playing() and not D.playback_held() and not D.modal_visible() and D.celebrations() == ["workbench"]
	D.tap_playback()
	await _frames(3)
	var iq_shown: bool = D.modal_visible() and D.celebrations().is_empty()
	D.close_modal()
	await _frames(3)
	var iq_once: bool = not D.modal_visible()
	D.playback_speed(0.0)
	print("interruptions: a celebration waits in line during the quiz %s, during the catch-up %s, shows after it %s, once %s" % [iq_quiz, iq_catchup, iq_shown, iq_once])
	if not (iq_quiz and iq_catchup and iq_shown and iq_once): print("FAIL interruptions: see the line above")
	# interruption-queue/04 (review): the start of a new game asks only for a story piece before its welcome; a celebration that
	# waits stays in line and comes after (it must not be shown and then covered by the welcome)
	D.story_enabled(false)                       # no bark may come in between (a bark does not wait for a celebration)
	D.show_menu()
	await _frames(2)
	D.celebrate("stone_axe")
	D.close_modal()
	var iq_story_only: bool = not D.story_pump() and not D.modal_visible() and D.celebrations() == ["stone_axe"]
	await _frames(3)
	var iq_after: bool = D.modal_visible() and D.celebrations().is_empty()
	D.close_modal()
	D.story_enabled(true)
	print("interruptions: the story pump shows only story and leaves a celebration in line %s, which comes at the end of the frame %s" % [iq_story_only, iq_after])
	if not (iq_story_only and iq_after): print("FAIL interruptions: see the line above")
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

func _toast_has(part: String) -> bool:
	for t in D.toast_texts():
		if str(t).contains(part): return true
	return false
