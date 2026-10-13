extends RefCounted
## Rest: the sums on the number pad that give energy back, medals, lightning.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")
const Fx = preload("res://game/farm/fx.gd")
const Pad = preload("res://kits/learn/number_pad_quiz.gd")

var M
var G

const MEDAL_WORDS := {"bronze": "🥉 Bronze: answer %d of its sums quick and right, twice each.",   # i18n
	"silver": "🥈 Silver: know all its sums by heart, quick every time.", "gold": "🥇 Gold: still quick a week after silver."}   # i18n

## Quick sums: the answer is typed on a number pad (or the keyboard) and sent with ✔. A timer runs for
## Rest: sums on the number pad (kits/learn/number_pad_quiz.gd asks, checks and remembers). A right answer gives energy:
## all of it when quick (the level's time — 2.5 s for a sum learned by heart), half when slow.
## Rest (J3): the farmer first walks home (the tent or the house) and lies down; the Rest window opens when the farmer
## is there (at least half a second, at most 1.5 s, so a long walk does not keep the child waiting).
var _going_home := false
func _show_rest() -> void:
	if _going_home or M.modal.visible: return
	_going_home = true
	M.ui_acts._act("rest", M.map.stand_point(M.ui_map._map_sid("living")))
	var waited := 0.0
	while waited < 1.5:
		await M.get_tree().create_timer(0.1).timeout
		waited += 0.1
		var av = M.map.avatar if M.map else null
		if waited >= 0.5 and (av == null or not av.moving): break
	_going_home = false
	if not M.modal.visible: _open_rest()

## The Rest window itself (tests and screenshots open it straight away).
func _open_rest() -> void:
	var box = M.ui_modal._open_modal(M.tr("😴 Rest"))
	Sound.music("rest")
	var beds: Array = Spots.HOTSPOT_ART.get("living", []).filter(func(id): return G.nodes.has(id) and G.done(id))
	beds.reverse()
	var bed: Texture2D = Art.first("interior", beds)
	box.add_child(UI.header(bed if bed else Art.first("map", ["tent"]), "😴", 72))
	if G.S.get("cold", false): box.add_child(UI.label(M.tr("❄️ The house is cold — stack firewood to rest better."), 17, UI.RED, true))
	var er := UI.hbox(6)
	er.alignment = BoxContainer.ALIGNMENT_CENTER
	er.add_child(UI.label("⚡", 24))
	var eb := UI.stock_bar(float(G.S["energy"]), G.energy_max(), UI.item_color("energy"), 420)
	UI.explain(eb, M.tr("⚡ Your energy: right sums fill it up."))
	er.add_child(eb)
	box.add_child(er)
	G.math_record()
	# first a start page: where the child stands, the medals so far and the next one to win; the sums start with the button
	var start := _rest_start_page()
	box.add_child(start)
	var back := UI.soft_button(M.tr("⬅️ Back to the farm"), M.ui_modal._close_modal, true, 17)
	box.add_child(back)
	M._rest = {"eb": eb, "box": box, "start": start, "back": back}
	M.ui_modal.call_deferred("_fit_modal")

## The Rest start page: category and title, the level and how far along it is, the section's medals and an empty slot
## for the next medal (what it takes), and the "Ready, set, go!" button.
func _rest_start_page() -> Control:
	var v := UI.vbox(8)
	var li: Dictionary = G.math.level_info(G._learn())
	if li.is_empty(): return v
	var pc := UI.card(Color("f3f7ea"))
	var pv := UI.vbox(6)
	pc.add_child(pv)
	var t := UI.label("%s %s — %s" % [li["category_emoji"], li["category"], li["rank"]], 20, UI.INK, true)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pv.add_child(t)
	var lt := UI.label(M.tr("%s %s · level %d of %d") % [li["section_emoji"], li["section"], li["pos"], li["count"]], 16, UI.MUTED, true)
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
	for cs in G.math.overview(G._learn()):
		for ss in cs["sections"]:
			if str(ss["name"]) != str(li["section"]) or not ss["levels"].any(func(e): return e["id"] == li["id"]): continue
			for lv in ss["levels"]:
				if not lv["bronze"]: continue
				var mt = M.ui_menus._medal_tile("🥇" if lv["gold"] else ("🥈" if lv["silver"] else "🥉"), lv, false)
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
	var nl := UI.label(M.tr("Next: %s %s") % [li["emoji"], li["name"]], 13, UI.MUTED, true)
	nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nl.custom_minimum_size = Vector2(112, 0)
	sv.add_child(nl)
	fl.add_child(slot)
	pv.add_child(fl)
	var how = M.tr(str(MEDAL_WORDS[nxt]))
	if nxt == "bronze": how = how % int(li["need"])
	pv.add_child(UI.label(how, 16, UI.GREEN_DARK, true))
	if int(li["best"]) > 0: pv.add_child(UI.label(M.tr("🔥 Best streak so far: %d quick sums in a row") % int(li["best"]), 15, UI.MUTED, true))
	v.add_child(pc)
	var go := UI.button(M.tr("🏁 Ready, set, go!"), _rest_go, true, UI.GREEN, 26)
	go.custom_minimum_size = Vector2(0, 72)
	v.add_child(go)
	return v

## "Ready … set … go!", then the sums.
func _rest_go() -> void:
	if M._rest.is_empty() or not M._rest.has("start"): return
	var box: Control = M._rest["box"]
	var start: Control = M._rest["start"]
	var at := start.get_index()
	start.queue_free()
	M._rest.erase("start")
	var cd := UI.label(M.tr("Ready…"), 54, UI.GREEN_DARK)
	cd.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cd.custom_minimum_size = Vector2(0, 160)
	cd.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	box.add_child(cd)
	box.move_child(cd, at)
	M._rest["count"] = cd
	M.ui_modal.call_deferred("_fit_modal")
	for w in [M.tr("Set…"), M.tr("Go! 🏁")]:
		await M.get_tree().create_timer(0.6).timeout
		if M._rest.get("count") != cd: return            # the child left already
		cd.text = w
	await M.get_tree().create_timer(0.45).timeout
	if M._rest.get("count") != cd: return
	M._rest.erase("count")
	cd.queue_free()
	var pad = Pad.new()
	pad.setup(G.math, G._learn(), G.rng, {"scale": float(G.settings.get("restTimerScale", 1.0)), "streak": G.perk_on("perk_streak"),
		"colors": {"ink": UI.INK, "muted": UI.MUTED, "green": UI.GREEN, "green_dark": UI.GREEN_DARK, "red": UI.RED, "amber": UI.AMBER, "line": UI.LINE}})
	box.add_child(pad)
	box.move_child(pad, at)
	pad.before_next.connect(_rest_before_next)
	pad.answered.connect(_rest_answered)
	M._rest["pad"] = pad
	pad.next()
	M.ui_modal.call_deferred("_fit_modal")

func _rest_before_next() -> void:
	if not M._rest.has("pad"): return
	if float(G.S["energy"]) >= G.energy_max() - 0.01: M._rest["pad"].stop(M.tr("Full of energy! Back to work."))
	M.ui_modal.call_deferred("_fit_modal")

## After each answer: energy, perks (lightning, streak), stars and a fanfare for medals and new levels.
func _rest_answered(res: Dictionary) -> void:
	G.after_rest_answer(res["right"], res["quick"])
	var fb: Dictionary = res["fb"]
	if res["right"]:
		var gained: float = G.rest_correct(res["quick"])
		var t = (M.tr("⚡ +%s  quick!") if res["quick"] else M.tr("⚡ +%s  (a bit slow: half)")) % M.ui_widgets._num(gained)
		var txt := str(res["text"])
		res["text"] = t + (txt.substr(txt.find("\n")) if txt.contains("\n") else "")
		M._rest["eb"].have = float(G.S["energy"])
		M._rest["eb"].queue_redraw()
		if res["quick"] and G.perk_on("perk_lightning") and randf() < 1.0 / 3.0: _lightning()
	M.ui_sounds._sfx("rest_right" if res["right"] else "rest_wrong")
	if not fb.get("medals", []).is_empty():
		M.ui_sounds._sfx("medal")
		var fx = UI.Celebration.new()
		M.add_child(fx)
		fx.size = M.size
		fx.start("stars", M._rest["pad"].ans_box.get_global_rect().get_center())
		for m in fb["medals"]:
			if m["medal"] != "bronze": M._after_close.append(str(fb.get("comment", "")))
	elif fb.get("level_up", false): M.ui_sounds._sfx("levelup")
	elif int(fb.get("streak", 0)) in [5, 10, 20, 30]: M.ui_sounds._sfx("streak")
	M.ui_modal.call_deferred("_fit_modal")

## Lightning over the Rest window, down to the answer (perk "Lightning sums").
func _lightning() -> void:
	var lt = Fx.Lightning.new()
	M.add_child(lt)
	lt.position = Vector2.ZERO
	lt.size = M.size
	lt.start(M._rest["pad"].ans_box.get_global_rect().get_center())
	M.ui_sounds._sfx("lightning")
