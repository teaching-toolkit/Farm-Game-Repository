extends RefCounted
class_name FarmUiRest
## Rest: the start page and the mental-arithmetic sums that give energy back (the number pad and its timer come from kits/learn/).

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")
const Fx = preload("res://game/farm/fx.gd")
const Pad = preload("res://kits/learn/number_pad_quiz.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

const MEDAL_WORDS := {"bronze": "🥉 Bronze: answer %d of its sums quick and right, twice each.",   # i18n
	"silver": "🥈 Silver: know all its sums by heart, quick every time.", "gold": "🥇 Gold: still quick a week after silver."}   # i18n

# ------------------------------------------------------------------ Rest

## Quick sums: the answer is typed on a number pad (or the keyboard) and sent with ✔. A timer runs for
## Rest: sums on the number pad (kits/learn/number_pad_quiz.gd asks, checks and remembers). A right answer gives energy:
## all of it when quick (the level's time — 2.5 s for a sum learned by heart), half when slow.
## The Rest buttons (the energy pill, the bed): the farmer first walks to the house with the farm scrolled to it, then the window opens
## (when he has arrived, but after 0.4 s at the earliest and 1.6 s at the latest, so that a far walk does not make anyone wait).
func go_rest() -> void:
	if M.modal.visible: return
	M.interior_back = ""        # Rest ends on the farm, not back in the house window
	M.sheets.close_sheet()
	var sid: String = M.mapview.map_sid("living")
	M.mapview.reveal(M.map.spot_rect(sid))
	M.feedback.play_act("rest", M.map.stand_point(sid))
	await M.get_tree().create_timer(0.4).timeout
	var waited := 0.4
	while M.map.avatar.moving and waited < 1.6:
		await M.get_tree().process_frame
		waited += M.get_process_delta_time()
	if not M.modal.visible: show_rest()

func show_rest() -> void:
	var box := M.modals.open_modal(tr("😴 Rest"))
	Sound.music("rest")
	M.feedback.play_act("rest", M.map.stand_point(M.mapview.map_sid("living")))
	var beds: Array = Spots.corner_art("living").filter(func(id): return G.nodes.has(id) and G.done(id))
	beds.reverse()
	var bed: Texture2D = Art.first("interior", beds)
	box.add_child(UI.header(bed if bed else Art.first("map", ["tent"]), "😴", 72))
	if G.S.get("cold", false): box.add_child(UI.label(tr("❄️ The house is cold — stack firewood to rest better."), 17, UI.RED, true))
	var er := UI.hbox(6)
	er.alignment = BoxContainer.ALIGNMENT_CENTER
	er.add_child(UI.label("⚡", 24))
	var eb := UI.stock_bar(float(G.S["energy"]), G.needs.energy_max(), UI.item_color("energy"), 420)
	UI.explain(eb, tr("⚡ Your energy: right sums fill it up."))
	er.add_child(eb)
	box.add_child(er)
	G.needs.math_record()
	# first a start page: where the child stands, the medals so far and the next one to win; the sums start with the button
	var start := _rest_start_page()
	box.add_child(start)
	var back := UI.soft_button(tr("⬅️ Back to the farm"), M.modals.close_modal, true, 17)
	box.add_child(back)
	M.rest_state = {"eb": eb, "box": box, "start": start, "back": back}
	M.modals.fit_modal.call_deferred()

## The Rest start page: category and title, the level and how far along it is, the section's medals and an empty slot
## for the next medal (what it takes), and the "Ready, set, go!" button.
func _rest_start_page() -> Control:
	var v := UI.vbox(8)
	var li: Dictionary = G.math.level_info(G.learn_record())
	if li.is_empty(): return v
	var pc := UI.card(Color("f3f7ea"))
	var pv := UI.vbox(6)
	pc.add_child(pv)
	var t := UI.label("%s %s — %s" % [li["category_emoji"], li["category"], li["rank"]], 20, UI.INK, true)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pv.add_child(t)
	var lt := UI.label(tr("%s %s · level %d of %d") % [li["section_emoji"], li["section"], li["pos"], li["count"]], 16, UI.MUTED, true)
	lt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pv.add_child(lt)
	var big := UI.label("%s %s" % [li["emoji"], li["name"]], 30, UI.INK, true)
	big.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pv.add_child(big)
	var pr := UI.hbox(8)
	pr.alignment = BoxContainer.ALIGNMENT_CENTER
	pr.add_child(UI.bar(float(li["got"]) / float(maxi(1, int(li["need"]))), 300, 16, UI.AMBER))
	pr.add_child(UI.label("%d / %d" % [li["got"], li["need"]], 16, UI.MUTED))
	pv.add_child(pr)
	# the medals of this section so far, then an empty slot for the next one
	var fl := HFlowContainer.new()
	fl.alignment = FlowContainer.ALIGNMENT_CENTER
	fl.add_theme_constant_override("h_separation", 10)
	fl.add_theme_constant_override("v_separation", 10)
	for cs in G.math.overview(G.learn_record()):
		for ss in cs["sections"]:
			if str(ss["name"]) != str(li["section"]) or not ss["levels"].any(func(e): return e["id"] == li["id"]): continue
			for lv in ss["levels"]:
				if not lv["bronze"]: continue
				var mt := M.album.medal_tile("🥇" if lv["gold"] else ("🥈" if lv["silver"] else "🥉"), lv, false)
				mt.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
				fl.add_child(mt)
	var nxt := "gold" if li["silver"] else ("silver" if li["bronze"] else "bronze")
	var slot := UI.card(Color(1, 1, 1, 0.6), UI.LINE)
	slot.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var sv := UI.vbox(2)
	slot.add_child(sv)
	var md := UI.label({"bronze": "🥉", "silver": "🥈", "gold": "🥇"}[nxt], 44)
	md.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	md.modulate = Color(1, 1, 1, 0.3)
	sv.add_child(md)
	var nl := UI.label(tr("Next: %s %s") % [li["emoji"], li["name"]], 13, UI.MUTED, true)
	nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nl.custom_minimum_size = Vector2(112, 0)
	sv.add_child(nl)
	fl.add_child(slot)
	pv.add_child(fl)
	var how := tr(str(MEDAL_WORDS[nxt]))
	if nxt == "bronze": how = how % int(li["need"])
	pv.add_child(UI.label(how, 16, UI.GREEN_DARK, true))
	if int(li["best"]) > 0: pv.add_child(UI.label(tr("🔥 Best streak so far: %d quick sums in a row") % int(li["best"]), 15, UI.MUTED, true))
	v.add_child(pc)
	var go := UI.button(tr("🏁 Ready, set, go!"), rest_go, true, UI.GREEN, 26)
	go.custom_minimum_size = Vector2(0, 72)
	v.add_child(go)
	return v

## "Ready … set … go!", then the sums.
func rest_go() -> void:
	if M.rest_state.is_empty() or not M.rest_state.has("start"): return
	var box: Control = M.rest_state["box"]
	var start: Control = M.rest_state["start"]
	var at := start.get_index()
	start.queue_free()
	M.rest_state.erase("start")
	var cd := UI.label(tr("Ready…"), 54, UI.GREEN_DARK)
	cd.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cd.custom_minimum_size = Vector2(0, 160)
	cd.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	box.add_child(cd)
	box.move_child(cd, at)
	M.rest_state["count"] = cd
	M.modals.fit_modal.call_deferred()
	for w in [tr("Set…"), tr("Go! 🏁")]:
		await M.get_tree().create_timer(0.6).timeout
		if M.rest_state.get("count") != cd: return            # the child left already
		cd.text = w
	await M.get_tree().create_timer(0.45).timeout
	if M.rest_state.get("count") != cd: return
	M.rest_state.erase("count")
	cd.queue_free()
	var pad = Pad.new()
	pad.setup(G.math, G.learn_record(), G.rng, {"scale": float(G.settings.get("restTimerScale", 1.0)), "streak": G.rewards.perk_on("perk_streak"),
		"colors": {"ink": UI.INK, "muted": UI.MUTED, "green": UI.GREEN, "green_dark": UI.GREEN_DARK, "red": UI.RED, "amber": UI.AMBER, "line": UI.LINE}})
	box.add_child(pad)
	box.move_child(pad, at)
	pad.before_next.connect(_rest_before_next)
	pad.answered.connect(_rest_answered)
	M.rest_state["pad"] = pad
	pad.next()
	M.modals.fit_modal.call_deferred()

func _rest_before_next() -> void:
	if not M.rest_state.has("pad"): return
	if float(G.S["energy"]) >= G.needs.energy_max() - 0.01: M.rest_state["pad"].stop(tr("Full of energy! Back to work."))
	M.modals.fit_modal.call_deferred()

## After each answer: energy, perks (lightning, streak), stars and a fanfare for medals and new levels.
func _rest_answered(res: Dictionary) -> void:
	G.needs.after_rest_answer(res["right"], res["quick"])
	var fb: Dictionary = res["fb"]
	if res["right"]:
		var gained: float = G.needs.rest_correct(res["quick"])
		var t := (tr("⚡ +%s  quick!") if res["quick"] else tr("⚡ +%s  (a bit slow: half)")) % M.widgets.num(gained)
		var txt := str(res["text"])
		res["text"] = t + (txt.substr(txt.find("\n")) if txt.contains("\n") else "")
		M.rest_state["eb"].have = float(G.S["energy"])
		M.rest_state["eb"].queue_redraw()
		if res["quick"] and G.rewards.perk_on("perk_lightning") and randf() < 1.0 / 3.0: _lightning()
	M.feedback.sfx("rest_right" if res["right"] else "rest_wrong")
	if not fb.get("medals", []).is_empty():
		M.feedback.sfx("medal")
		var fx = UI.Celebration.new()
		M.add_child(fx)
		fx.size = M.size
		fx.start("stars", M.rest_state["pad"].ans_box.get_global_rect().get_center())
		for m in fb["medals"]:
			if m["medal"] != "bronze": M.after_close.append(str(fb.get("comment", "")))
	elif fb.get("level_up", false): M.feedback.sfx("levelup")
	elif int(fb.get("streak", 0)) in [5, 10, 20, 30]: M.feedback.sfx("streak")
	M.modals.fit_modal.call_deferred()

## Lightning over the Rest window, down to the answer (perk "Lightning sums").
func _lightning() -> void:
	var lt = Fx.Lightning.new()
	M.add_child(lt)
	lt.position = Vector2.ZERO
	lt.size = M.size
	lt.start(M.rest_state["pad"].ans_box.get_global_rect().get_center())
	M.feedback.sfx("lightning")
