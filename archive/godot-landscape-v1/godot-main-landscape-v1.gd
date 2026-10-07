extends Control
## Farm Quiz Game — prototype UI. Everything is built in code; emojis stand in for art.
const UI = preload("res://scripts/ui.gd")
const FieldView = preload("res://scripts/field_view.gd")

var G
var bg: ColorRect
var lbl_coins: Label
var lbl_water: Label
var btn_energy: Button
var lbl_season: Label
var lbl_step: Label
var lbl_status: Label
var field
var field_title: Label
var field_status: RichTextLabel
var fieldcard: PanelContainer
var jobs_box: VBoxContainer
var tabbar: HFlowContainer
var scroll: ScrollContainer
var content: VBoxContainer
var toasts: VBoxContainer
var modal: Control
var modal_box: VBoxContainer
var cur_tab := 0
var field_idx := 0
var area_name := "field"
var _queued := false
var shot_path := ""
var shot_frames := 0
var step_at := -1
const TABS := [["goals", "🎯 Goals"], ["make", "🏭 Make"], ["animals", "🐔 Animals"], ["pantry", "🧺 Pantry"], ["market", "🛒 Market"],
	["library", "📚 Library"], ["gear", "🎒 Gear & Polish"], ["album", "🖼️ Album"], ["log", "📜 Log"]]

func _ready() -> void:
	G = get_node("/root/Game")
	_setup_theme()
	_build()
	G.changed.connect(_queue_refresh)
	G.toast.connect(_toast)
	G.offer_cards.connect(_show_gift)
	G.ask_name.connect(_show_name)
	field.patch_pressed.connect(_on_patch)
	_parse_args()
	_refresh()
	if G.S["gift_pending"].size() > 0: _show_gift(G.S["gift_pending"][0])
	elif G.S["step"] == 0 and not G.done("k_wheat"): _show_welcome()

func _setup_theme() -> void:
	var th := Theme.new()
	var sf := SystemFont.new()
	sf.font_names = PackedStringArray(["Nunito", "Avenir Next", "Helvetica Neue", "Segoe UI", "Noto Sans", "DejaVu Sans", "Arial"])
	var emoji := FontFile.new()
	if emoji.load_dynamic_font("res://fonts/NotoColorEmoji.ttf") == OK:
		sf.fallbacks = [emoji]
	th.default_font = sf
	th.default_font_size = 16
	theme = th

func _parse_args() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--shot="): shot_path = a.substr(7)
		elif a.begins_with("--tab="): cur_tab = int(a.substr(6)); _build_tabs()
		elif a.begins_with("--demo="):
			for _i in range(int(a.substr(7))): G.cheat_max()
		elif a == "--quiz": call_deferred("_show_time_quiz")
		elif a == "--rest": call_deferred("_show_rest")
		elif a.begins_with("--card="): call_deferred("_show_card", a.substr(7))
		elif a.begins_with("--patch="): call_deferred("_on_patch", "field", int(a.substr(8)))
		elif a.begins_with("--pests="): G.S["pests"] = float(a.substr(8))
		elif a.begins_with("--stepat="): step_at = int(a.substr(9))

func _process(_d: float) -> void:
	if shot_path != "":
		shot_frames += 1
		if shot_frames == step_at: G.step_time()
		if shot_frames == 40:
			var img := get_viewport().get_texture().get_image()
			img.save_png(shot_path)
			print("saved ", shot_path)
			get_tree().quit()

# ------------------------------------------------------------------ layout
func _build() -> void:
	bg = ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = UI.BG
	add_child(bg)
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]: margin.add_theme_constant_override("margin_" + side, 10)
	add_child(margin)
	var root := UI.vbox(8)
	margin.add_child(root)
	# --- top bar
	var topcard := UI.card(UI.PAPER)
	root.add_child(topcard)
	var top := UI.hbox(14)
	topcard.add_child(top)
	lbl_coins = UI.label("", 20); top.add_child(lbl_coins)
	lbl_water = UI.label("", 20); top.add_child(lbl_water)
	btn_energy = UI.button("", _show_rest, true, UI.BLUE, 18)
	btn_energy.tooltip_text = "Rest: answer sums to get energy back (sleep, food, a sip of water)."
	top.add_child(btn_energy)
	lbl_season = UI.label("", 17); top.add_child(lbl_season)
	lbl_step = UI.label("", 15, UI.MUTED); top.add_child(lbl_step)
	lbl_status = UI.label("", 15, UI.MUTED); top.add_child(lbl_status)
	top.add_child(UI.spacer())
	top.add_child(UI.button("❓ Time Quiz", _show_time_quiz, true, UI.GREEN, 20))
	if G.settings.get("showCheatButton", true):
		var cb := UI.button("⏩ Cheat", _cheat, true, UI.AMBER, 14)
		cb.tooltip_text = "Testing only: lets time pass until everything growing or cooking is done, then fills energy and water."
		top.add_child(cb)
		top.add_child(UI.button("🪙+100", func(): G.cheat_coins(100), true, UI.AMBER, 14))
	top.add_child(UI.soft_button("⚙️", _show_menu))
	# --- body
	var body := UI.hbox(10)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(body)
	var left := UI.vbox(6)
	left.size_flags_stretch_ratio = 1.0
	left.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(left)
	var fh := UI.hbox(6)
	left.add_child(fh)
	fh.add_child(UI.soft_button("◀", _prev_field))
	field_title = UI.label("", 19)
	fh.add_child(field_title)
	fh.add_child(UI.soft_button("▶", _next_field))
	fh.add_child(UI.spacer())
	fh.add_child(UI.soft_button("🌾", _set_area.bind("field")))
	fh.add_child(UI.soft_button("🍎", _set_area.bind("orchard")))
	fh.add_child(UI.soft_button("🪴", _set_area.bind("gh")))
	fieldcard = UI.card(Color("dfe9c9"), Color("b9c99a"))
	fieldcard.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left.add_child(fieldcard)
	field = FieldView.new()
	fieldcard.add_child(field)
	field_status = UI.rich("", 14)
	left.add_child(field_status)
	var qa := UI.hbox(6)
	left.add_child(qa)
	qa.add_child(UI.soft_button("🌿 Weed all", func(): G.weed_field(field_idx)))
	qa.add_child(UI.soft_button("🪨 Pick stones", _pick_all))
	qa.add_child(UI.soft_button("🧺 Harvest all", _harvest_all))
	var jc := UI.card()
	left.add_child(jc)
	jobs_box = UI.vbox(4)
	jc.add_child(jobs_box)
	# right: tabs
	var right := UI.vbox(6)
	right.size_flags_stretch_ratio = 1.0
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(right)
	tabbar = HFlowContainer.new()
	tabbar.add_theme_constant_override("h_separation", 4)
	tabbar.add_theme_constant_override("v_separation", 4)
	right.add_child(tabbar)
	_build_tabs()
	var rc := UI.card()
	rc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_child(rc)
	scroll = ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rc.add_child(scroll)
	content = UI.vbox(8)
	scroll.add_child(content)
	# toasts and modal layer
	toasts = UI.vbox(4)
	toasts.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	toasts.position = Vector2(16, 0)
	toasts.custom_minimum_size = Vector2(560, 0)
	toasts.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(toasts)
	modal = Control.new()
	modal.set_anchors_preset(Control.PRESET_FULL_RECT)
	modal.visible = false
	add_child(modal)
	var dim := ColorRect.new()
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.1, 0.08, 0.05, 0.45)
	modal.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	modal.add_child(center)
	var mcard := UI.card(UI.PAPER, UI.LINE)
	mcard.custom_minimum_size = Vector2(640, 0)
	center.add_child(mcard)
	var msc := ScrollContainer.new()
	msc.custom_minimum_size = Vector2(620, 0)
	msc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	mcard.add_child(msc)
	modal_box = UI.vbox(10)
	msc.add_child(modal_box)

func _build_tabs() -> void:
	_clear(tabbar)
	for i in range(TABS.size()):
		var b: Button
		if i == cur_tab: b = UI.button(TABS[i][1], _tab_pressed.bind(i), true, UI.GREEN_DARK, 15)
		else: b = UI.soft_button(TABS[i][1], _tab_pressed.bind(i), true, 15)
		tabbar.add_child(b)

func _tab_pressed(i: int) -> void:
	cur_tab = i
	_build_tabs()
	_rebuild_tab()
	scroll.scroll_vertical = 0

func _queue_refresh() -> void:
	if _queued: return
	_queued = true
	call_deferred("_refresh")

func _refresh() -> void:
	_queued = false
	var S: Dictionary = G.S
	lbl_coins.text = "🪙 %d" % G.down(S["coins"])
	lbl_water.text = "💧 %d/%d%s" % [G.down(S["water"]), G.down(G.water_cap()), " 🌧️" if S.get("rain", false) else ""]
	btn_energy.text = "⚡ %d/%d  😴 Rest" % [G.down(S["energy"]), G.down(G.energy_max())]
	var nxt: String = G.SEASON_NAMES[(G.season_no() + 1) % 4]
	lbl_season.text = "%s %s · %d to %s" % [G.season_emoji(), G.season().capitalize(), G.questions_left_in_season(), nxt]
	var ch: Dictionary = G.D["chapters"][G.chapter() - 1]
	lbl_step.text = "Q %d · Ch %d %s" % [S["step"], G.chapter(), ch["name"]]
	var st := []
	if G.buff_mult() < 1.0: st.append("😋 −%d%% energy" % int(round((1.0 - G.buff_mult()) * 100)))
	if S.get("cold", false): st.append("❄️🏠 cold house")
	if G.luck() >= 0.2: st.append("🍀")
	lbl_status.text = "  ".join(st)
	bg.color = UI.SEASON_BG.get(G.season(), UI.BG)
	# field header
	var names: Array = G.field_names()
	field_idx = clampi(field_idx, 0, maxi(0, names.size() - 1))
	if area_name == "field":
		field_title.text = "%s %d/%d" % [names[field_idx], field_idx + 1, names.size()]
	else:
		field_title.text = "🍎 Orchard" if area_name == "orchard" else "🪴 Greenhouse"
	field.area_name = area_name
	field.field_index = field_idx
	field.refresh()
	var sc := "none — build a scarecrow" if G.pest_scare() <= 0.0 else "chases %s per question" % _num(G.pest_scare())
	field_status.text = "[color=#5d5444]🐦 Pests on the farm: [b]%d[/b] (about %s arrive per question) · Scarecrow: %s · Fence: %d%% kept out · 🪵 Woodpile %d/%d[/color]" % [G.down(S["pests"]), _num(G.pest_arrivals()), sc, int(round(G.pest_block() * 100)), G.down(S["woodpile"]), G.down(G.woodpile_cap())]
	_refresh_jobs()
	_rebuild_tab()

func _refresh_jobs() -> void:
	_clear(jobs_box)
	jobs_box.add_child(UI.label("📋 Little jobs (a few coins and a bit of luck)", 15, UI.MUTED))
	for j in G.S["jobs"]:
		var h := UI.hbox(6)
		h.add_child(UI.label("• " + str(j["text"]), 15))
		h.add_child(UI.spacer())
		h.add_child(UI.label("%d/%d" % [G.down(float(j["got"])), int(j["n"])], 15, UI.MUTED))
		jobs_box.add_child(h)

func _clear(c: Node) -> void:
	for k in c.get_children():
		c.remove_child(k)
		k.queue_free()

func _prev_field() -> void:
	area_name = "field"; field_idx = maxi(0, field_idx - 1); field.show_area("field", field_idx); _refresh()

func _next_field() -> void:
	area_name = "field"; field_idx = mini(G.field_names().size() - 1, field_idx + 1); field.show_area("field", field_idx); _refresh()

func _set_area(a: String) -> void:
	area_name = a; field.show_area(a, field_idx); _refresh()

func _pick_all() -> void:
	for i in range(field_idx * 9, field_idx * 9 + 9):
		if i < G.S["patches"].size() and G.patch_usable("field", i) and float(G.S["patches"][i]["stones"]) >= 0.5:
			if not G.pick_stones(i): break

func _harvest_all() -> void:
	var arr: Array = G.area(area_name)
	var start := field_idx * 9 if area_name == "field" else 0
	var n := 9 if area_name == "field" else arr.size()
	for i in range(start, mini(start + n, arr.size())):
		if arr[i]["ready"]:
			if not G.harvest(area_name, i): break

func _cheat() -> void:
	G.cheat_max()

func _toast(t: String) -> void:
	var p := UI.card(Color(1, 0.98, 0.9, 0.96), UI.LINE)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var l := UI.label(t, 15, UI.INK, true)
	l.custom_minimum_size = Vector2(520, 0)
	p.add_child(l)
	toasts.add_child(p)
	while toasts.get_child_count() > 4:
		var old := toasts.get_child(0)
		toasts.remove_child(old); old.queue_free()
	var fr := fieldcard.get_global_rect()
	toasts.position = Vector2(fr.position.x + 8, fr.end.y - 10 - toasts.get_combined_minimum_size().y)
	var tw := create_tween()
	tw.tween_interval(3.8)
	tw.tween_property(p, "modulate:a", 0.0, 0.6)
	tw.tween_callback(_free_if_valid.bind(p))

func _free_if_valid(n: Node) -> void:
	if is_instance_valid(n): n.queue_free()

# ------------------------------------------------------------------ modal helpers
func _open_modal(title: String) -> VBoxContainer:
	_clear(modal_box)
	var h := UI.hbox(8)
	h.add_child(UI.label(title, 22))
	h.add_child(UI.spacer())
	h.add_child(UI.soft_button("✖ Close", _close_modal))
	modal_box.add_child(h)
	modal.visible = true
	call_deferred("_fit_modal")
	return modal_box

func _fit_modal() -> void:
	var h := modal_box.get_combined_minimum_size().y + 8.0
	var msc: ScrollContainer = modal_box.get_parent()
	msc.custom_minimum_size = Vector2(620, clampf(h, 120.0, size.y - 90.0))
	get_tree().create_timer(0.05).timeout.connect(_fit_modal_again)

func _fit_modal_again() -> void:
	var h := modal_box.get_combined_minimum_size().y + 8.0
	var msc: ScrollContainer = modal_box.get_parent()
	msc.custom_minimum_size = Vector2(620, clampf(h, 120.0, size.y - 90.0))

func _close_modal() -> void:
	modal.visible = false
	_clear(modal_box)
	_queue_refresh()
	if G.S["gift_pending"].size() > 0: call_deferred("_show_gift", G.S["gift_pending"][0])

func _speak(text: String) -> void:
	if DisplayServer.has_method("tts_get_voices"):
		var voices := DisplayServer.tts_get_voices_for_language("en")
		if voices.size() > 0:
			DisplayServer.tts_stop()
			DisplayServer.tts_speak(text, voices[0])

## One multiple-choice question. Wrong picks grey out and show why; the right pick calls on_done(first_try).
func _question(box: VBoxContainer, q: Dictionary, on_done: Callable) -> void:
	var qh := UI.hbox(8)
	var ql := UI.label(str(q["q"]), 22, UI.INK, true)
	qh.add_child(ql)
	qh.add_child(UI.soft_button("🔊", _speak.bind(str(q["q"]) + ". " + ". ".join(q["answers"].map(func(x): return str(x))))))
	box.add_child(qh)
	var feedback := UI.label("", 16, UI.MUTED, true)
	var buttons := []
	var state := {"first": true, "done": false}
	for i in range(q["answers"].size()):
		var b := UI.button(str(q["answers"][i]), Callable(), true, Color("6c8fb3"), 19)
		b.custom_minimum_size = Vector2(0, 48)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		buttons.append(b)
		box.add_child(b)
	box.add_child(feedback)
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_answer_pressed.bind(i, q, buttons, feedback, state, on_done))
	call_deferred("_fit_modal")

func _answer_pressed(i: int, q: Dictionary, buttons: Array, feedback: Label, state: Dictionary, on_done: Callable) -> void:
	if state["done"]: return
	var b: Button = buttons[i]
	if i == int(q["correct"]):
		state["done"] = true
		b.add_theme_stylebox_override("disabled", UI.box(UI.GREEN, 10, Color(0, 0, 0, 0), 0, 10))
		for x in buttons: x.disabled = true
		var why := str(q.get("why", ""))
		feedback.text = "✅ Right! " + why
		feedback.add_theme_color_override("font_color", UI.GREEN_DARK)
		on_done.call(state["first"])
		call_deferred("_fit_modal")
	else:
		state["first"] = false
		b.disabled = true
		b.add_theme_stylebox_override("disabled", UI.box(Color("d9a89c"), 10, Color(0, 0, 0, 0), 0, 10))
		var hint := str(q.get("wrong_text", ""))
		if hint == "": hint = "Not quite. " + str(q.get("why", ""))
		feedback.text = "❌ " + hint + "  Try again!"
		feedback.add_theme_color_override("font_color", UI.RED)

# ------------------------------------------------------------------ Time Quiz
func _show_time_quiz() -> void:
	var q: Dictionary = G.next_time_question()
	var box := _open_modal("❓ Time Quiz")
	box.add_child(UI.label(str(q.get("source", "")) + "   ·   every right answer moves farm time one step", 14, UI.MUTED))
	var qbox := UI.vbox(8)
	box.add_child(qbox)
	var after := UI.hbox(8)
	box.add_child(after)
	_question(qbox, q, _time_answered.bind(q, after))

func _time_answered(first_try: bool, q: Dictionary, after: HBoxContainer) -> void:
	if q.get("review", false): G.record_card_answer(q, first_try)
	var info: Dictionary = G.step_time()
	var msg := "⏳ Time moves on: question %d." % G.S["step"]
	if info.get("rain", false): msg += " 🌧️ It rained."
	if int(info.get("removed", 0)) > 0: msg += " 🧍 The scarecrow chased off %d pest%s." % [int(info["removed"]), "" if int(info["removed"]) == 1 else "s"]
	after.add_child(UI.label(msg, 15, UI.MUTED, true))
	var row := UI.hbox(8)
	row.add_child(UI.button("Next question ▶", _show_time_quiz, true, UI.GREEN, 18))
	row.add_child(UI.soft_button("Back to the farm", _close_modal))
	modal_box.add_child(row)

# ------------------------------------------------------------------ Rest
func _show_rest() -> void:
	var box := _open_modal("😴 Rest")
	box.add_child(UI.label("Sleep, a snack, a sip of water… Every right sum gives back about %s ⚡ (a better bed, pillow, bottle and home give more)." % _num(G.rest_per_answer()), 15, UI.MUTED, true))
	if G.S.get("cold", false): box.add_child(UI.label("❄️ The house is cold — stack firewood to rest better.", 15, UI.RED, true))
	var eb := UI.bar(float(G.S["energy"]) / G.energy_max(), 560, 16, UI.BLUE)
	box.add_child(eb)
	var el := UI.label("⚡ %d / %d" % [G.down(G.S["energy"]), G.down(G.energy_max())], 18)
	box.add_child(el)
	var qbox := UI.vbox(8)
	box.add_child(qbox)
	_rest_next(qbox, eb, el)

func _rest_next(qbox: VBoxContainer, eb: ProgressBar, el: Label) -> void:
	_clear(qbox)
	if float(G.S["energy"]) >= G.energy_max() - 0.01:
		qbox.add_child(UI.label("⚡ Full of energy! Back to work.", 20, UI.GREEN_DARK))
		return
	var q: Dictionary = G.rest_question()
	q["why"] = ""
	_question(qbox, q, _rest_answered.bind(qbox, eb, el))

func _rest_answered(first_try: bool, qbox: VBoxContainer, eb: ProgressBar, el: Label) -> void:
	var gained := 0.0
	if first_try: gained = G.rest_correct()
	eb.value = float(G.S["energy"]) / G.energy_max()
	el.text = "⚡ %d / %d   %s" % [G.down(G.S["energy"]), G.down(G.energy_max()), ("+" + _num(gained)) if gained > 0.0 else "(first try counts — next one!)"]
	get_tree().create_timer(0.7).timeout.connect(_rest_next.bind(qbox, eb, el))

# ------------------------------------------------------------------ knowledge cards
func _show_card(cid: String) -> void:
	var n: Dictionary = G.nodes[cid]
	var box := _open_modal("%s %s" % [n.get("emoji", "📖"), n["name"]])
	var page := str(n.get("page", n.get("desc", "")))
	var ph := UI.hbox(8)
	ph.add_child(UI.label(page, 18, UI.INK, true))
	ph.add_child(UI.soft_button("🔊 Read aloud", _speak.bind(page)))
	box.add_child(ph)
	var unl := []
	for u in n.get("unlocks", []):
		if G.nodes.has(u): unl.append(G.nodes[u].get("emoji", "") + " " + G.nodes[u]["name"])
		elif G.recipes.has(u): unl.append("🍳 " + str(G.recipes[u].get("name", G.iname(G.recipes[u]["outputs"].keys()[0]))))
	if unl.size() > 0: box.add_child(UI.label("Knowing this lets you: " + ", ".join(unl), 15, UI.MUTED, true))
	if G.done(cid):
		box.add_child(UI.label("✅ You already know this card.", 17, UI.GREEN_DARK))
		return
	var qs: Array = G.card_quiz(cid)
	var nrev := 0
	for q in qs:
		if q["review"]: nrev += 1
	box.add_child(UI.label("Quiz: %d new question%s%s. You can try again if you miss." % [qs.size() - nrev, "" if qs.size() - nrev == 1 else "s", (" + %d from cards you learned before" % nrev) if nrev > 0 else ""], 15, UI.MUTED, true))
	var qbox := UI.vbox(8)
	box.add_child(qbox)
	box.add_child(UI.button("Start the quiz ▶", _card_q.bind(cid, qs, 0, qbox, {"all_first": true}), true, UI.GREEN, 18))

func _card_q(cid: String, qs: Array, idx: int, qbox: VBoxContainer, acc: Dictionary) -> void:
	var last := modal_box.get_child(modal_box.get_child_count() - 1)
	if last is Button: modal_box.remove_child(last); last.queue_free()
	_clear(qbox)
	if idx >= qs.size():
		G.finish_card(cid, acc["all_first"])
		qbox.add_child(UI.label("🎓 You learned \"%s\"!" % G.nodes[cid]["name"], 22, UI.GREEN_DARK))
		qbox.add_child(UI.soft_button("Back to the farm", _close_modal))
		return
	var q: Dictionary = qs[idx]
	qbox.add_child(UI.label(("📚 Review: " + G.nodes[q["card"]]["name"]) if q["review"] else "Question %d" % (idx + 1), 14, UI.MUTED))
	var inner := UI.vbox(8)
	qbox.add_child(inner)
	_question(inner, q, _card_answered.bind(cid, qs, idx, qbox, acc))

func _card_answered(first_try: bool, cid: String, qs: Array, idx: int, qbox: VBoxContainer, acc: Dictionary) -> void:
	G.record_card_answer(qs[idx], first_try)
	if not first_try and not qs[idx]["review"]: acc["all_first"] = false
	qbox.add_child(UI.button("Next ▶" if idx + 1 < qs.size() else "Finish ▶", _card_q.bind(cid, qs, idx + 1, qbox, acc), true, UI.GREEN, 17))

# ------------------------------------------------------------------ patches
func _on_patch(a: String, i: int) -> void:
	if not G.patch_usable(a, i): return
	var p: Dictionary = G.area(a)[i]
	var label := "Patch %d" % (i % 9 + 1) if a == "field" else ("Tree spot %d" % (i + 1) if a == "orchard" else "Bed %d" % (i + 1))
	var box := _open_modal(label)
	if p["crop"] == "":
		box.add_child(UI.label("What shall we plant? (up to %d plants of one crop per patch)" % G.plants_per_patch(a), 16, UI.MUTED))
		var cs: Array = G.crops_for(a)
		if cs.is_empty(): box.add_child(UI.label("No seeds you can plant here yet.", 16, UI.MUTED))
		for cid in cs:
			var n: Dictionary = G.nodes[cid]
			var plan: Dictionary = G.plant_plan(a, cid)
			var row := UI.hbox(8)
			var seeds_txt := ("%d %s" % [G.down(G.seed_have(cid)), G.iname(n["seedItem"])]) if n.has("seedItem") else ("%d seeds" % G.down(G.seed_have(cid)))
			var t := "%s %s  ×%d   💧%d ⚡%d  ⏳%d   (%s%s)" % [n.get("emoji", ""), n["name"], int(plan["plants"]), G.up(plan["water"]), G.up(plan["energy"]), int(n.get("grow", 0)), seeds_txt,
				(", buys %d for 🪙%d" % [int(plan["buy_seeds"]), G.up(plan["coins"])]) if int(plan["buy_seeds"]) > 0 else ""]
			if int(plan["plants"]) < int(plan["max"]) and plan["reasons"].size() > 0: t += "  — fewer: not enough " + ", ".join(plan["reasons"])
			row.add_child(UI.label(t, 15, UI.INK, true))
			row.add_child(UI.button("Plant", _do_plant.bind(a, i, cid), int(plan["plants"]) >= 1))
			box.add_child(row)
	else:
		var n2: Dictionary = G.nodes[p["crop"]]
		box.add_child(UI.label("%s %s: %d plants · %s" % [n2.get("emoji", ""), n2["name"], G.down(float(p["plants"]) + 0.5), "ready to harvest!" if p["ready"] else "growing %d / %d" % [int(p["growth"]), int(ceil(G.grow_target(p)))]], 18))
		if float(p.get("soil", 1.0)) < 0.99: box.add_child(UI.label("😴 Tired soil: the same crop as last time grows slower. Swap crops next time (beans and clover rest the soil).", 14, UI.MUTED, true))
		elif float(p.get("soil", 1.0)) > 1.01: box.add_child(UI.label("💚 Rested soil after beans or clover: grows faster.", 14, UI.GREEN_DARK, true))
		if p["ready"]:
			var ys := []
			for k in n2.get("yields", {}): ys.append("%s%d" % [G.iemoji(k), G.down(float(n2["yields"][k]) * float(p["plants"]))])
			box.add_child(UI.button("🧺 Harvest  (%s, ⚡%d)" % [" ".join(ys), G.up(G.ecost("harvest", 1.0) * G.m("energy:field"))], _do_harvest.bind(a, i), true, UI.GREEN, 18))
	if a == "field":
		if float(p["weeds"]) >= 0.5:
			box.add_child(UI.button("🌿 Pull weeds (%d here, ⚡%d per pull)" % [int(p["weeds"]), G.up(G.ecost("weed", minf(3.0, float(p["weeds"]))) * G.m("energy:field"))], _do_weed.bind(i), true, UI.GREEN_DARK))
		if float(p["stones"]) >= 0.5:
			box.add_child(UI.button("🪨 Pick stones (%d here)" % int(p["stones"]), _do_stones.bind(i), true, UI.SOIL))
		box.add_child(UI.label("Weeds grow on every patch, faster with more plants and fertilizer. Stones come up in winter. Both slow growth a little.", 13, UI.MUTED, true))

func _do_plant(a: String, i: int, cid: String) -> void:
	if G.plant(a, i, cid): _close_modal()

func _do_harvest(a: String, i: int) -> void:
	if G.harvest(a, i): _close_modal()

func _do_weed(i: int) -> void:
	G.weed(i)
	_on_patch("field", i)

func _do_stones(i: int) -> void:
	G.pick_stones(i)
	_on_patch("field", i)

# ------------------------------------------------------------------ gift cards, names, menu, welcome
func _show_gift(offer: Array) -> void:
	if modal.visible: return
	var box := _open_modal("🎁 Pick a gift")
	box.add_child(UI.label("A milestone! Choose one card. The other two go to the market shop — you can buy them later.", 16, UI.MUTED, true))
	var row := UI.hbox(10)
	box.add_child(row)
	for gid in offer:
		var c: Dictionary = G.gift_card(gid)
		var b := UI.button("%s\n%s\n%s" % [c.get("emoji", "🎁"), c["name"], c.get("desc", "")], _pick_gift.bind(offer, gid), true, Color("7a9a4a"), 17)
		b.custom_minimum_size = Vector2(190, 160)
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		row.add_child(b)

func _pick_gift(offer: Array, gid: String) -> void:
	G.pick_gift(offer, gid)
	_close_modal()

func _show_name(pet_id: String, default_name: String) -> void:
	var box := _open_modal("%s A new friend!" % G.nodes[pet_id].get("emoji", "🐾"))
	box.add_child(UI.label("What should we call your new pet?", 18))
	var le := LineEdit.new()
	le.text = default_name
	le.add_theme_font_size_override("font_size", 22)
	box.add_child(le)
	box.add_child(UI.button("That's the name! ✔", _name_done.bind(pet_id, le), true, UI.GREEN, 18))

func _name_done(pet_id: String, le: LineEdit) -> void:
	G.set_pet_name(pet_id, le.text)
	_close_modal()

func _show_menu() -> void:
	var box := _open_modal("⚙️ Settings")
	box.add_child(UI.label("Question packs, the share of knowledge reviews in the Time Quiz and the size of Rest sums are set in data/settings.json and data/quiz_packs/.", 15, UI.MUTED, true))
	box.add_child(UI.label("Knowledge reviews in the Time Quiz: %d%%" % int(round(float(G.settings.get("knowledgeReviewShare", 0.25)) * 100)), 16))
	box.add_child(UI.button("🗑️ Start a new game (deletes the save)", _reset, true, UI.RED))

func _reset() -> void:
	G.reset_game()
	field_idx = 0; area_name = "field"
	field.show_area("field", 0)
	_close_modal()
	_show_welcome()

func _show_welcome() -> void:
	var box := _open_modal("🔥 Ashes")
	box.add_child(UI.label("Your farm burned down. All that's left: a tent, an old well, a tin pot, a few sticks and stones, five wheat seeds — and a box with a book in it.", 18, UI.INK, true))
	box.add_child(UI.label("Open the book in 📚 Library to learn how to grow wheat. Every right answer in the ❓ Time Quiz moves farm time forward. When you're tired, tap ⚡ to rest.", 16, UI.MUTED, true))
	box.add_child(UI.button("📗 Open the book", _open_first_book, true, UI.GREEN, 18))

func _open_first_book() -> void:
	_close_modal()
	cur_tab = 5; _build_tabs()
	_show_card("k_wheat")

# ------------------------------------------------------------------ tab content
func _rebuild_tab() -> void:
	_clear(content)
	match TABS[cur_tab][0]:
		"goals": _tab_goals()
		"make": _tab_make()
		"animals": _tab_animals()
		"pantry": _tab_pantry()
		"market": _tab_market()
		"library": _tab_library()
		"gear": _tab_gear()
		"album": _tab_album()
		"log": _tab_log()

const CAT_LABEL := {"field": "Field work", "weed": "Weeding", "plant": "Planting", "harvest": "Harvesting", "gather": "Gathering", "wood": "Wood work",
	"build": "Building", "craft": "Crafting", "smith": "Smithing", "kiln": "Kiln work", "cook": "Cooking", "prep": "Prep", "mill": "Milling",
	"process": "Dairy & press", "textile": "Textiles", "animal": "Animal care", "errand": "Errands"}

## Whole numbers for kids: 0.5 shows as ½, 1.5 as 1½, anything else is rounded.
func _num(v: float) -> String:
	var r := snappedf(v, 0.5)
	if absf(v - r) > 0.15: return str(int(round(v)))
	var whole := int(floor(r))
	if absf(r - whole) > 0.01: return ("%d½" % whole) if whole > 0 else "½"
	return str(whole)

func _pct(v: float) -> String:
	return ("−%d%%" % int(round((1.0 - v) * 100))) if v < 1.0 else ("+%d%%" % int(round((v - 1.0) * 100)))

func _effect_text(e: Dictionary) -> String:
	var out := []
	for k in e.get("set", {}):
		var v = e["set"][k]
		match k:
			"energyMax": out.append("energy max %d" % int(v))
			"energyPerRest": out.append("%s ⚡ per Rest answer" % _num(float(v)))
			"waterPerStep": out.append("+%s 💧 per question" % _num(float(v)))
			"waterCap": out.append("holds %d 💧" % int(v))
			"storageCap": out.append("holds %d of each item" % int(v))
			"patchCap": out.append("%d plants per patch" % int(v))
			"scare": out.append("chases %s pests per question" % _num(float(v)))
			"pestBlock": out.append("%d%% fewer pests get in" % int(round(float(v) * 100)))
			"bookSlots": out.append("holds %d books" % int(v))
			"waterMult": out.append("plants need %d%% water" % int(round(float(v) * 100)))
			_:
				if k.begins_with("cap_"): out.append("room for %d %s" % [int(v), k.substr(4)])
	for k in e.get("add", {}):
		var v2 := float(e["add"][k])
		if k == "energyPerRest": out.append("+%s ⚡ per Rest answer" % _num(v2))
		elif k == "energyMax": out.append("energy max +%d" % int(v2))
		elif k == "plots": out.append("+%d field patches" % int(v2))
		elif k == "waterPerStep": out.append("+%s 💧 per question" % _num(v2))
		elif k == "scare": out.append("chases %s more pests" % _num(v2))
		elif k == "sellBonusPct": out.append("+%d%% when selling" % int(v2))
		elif k.begins_with("slots:"): out.append("+%d batch at %s" % [int(v2), G.nodes.get(k.substr(6), {}).get("name", k.substr(6))])
		elif k.begins_with("yield_"): out.append("+%d %s per harvest" % [int(v2), G.iname(k.substr(6))])
		elif k == "shelfLife": out.append("food keeps %d season longer" % int(v2))
		else: out.append("%s +%s" % [k, _num(v2)])
	for k in e.get("mult", {}):
		var v3 := float(e["mult"][k])
		var parts: PackedStringArray = k.split(":")
		var kind: String = parts[0]
		var a: String = parts[1] if parts.size() > 1 else ""
		match kind:
			"energy": out.append("%s %s" % [CAT_LABEL.get(a, a), _pct(v3)])
			"water": out.append("%s water %s" % ["field" if a == "field" else "animal", _pct(v3)])
			"weeds": out.append("weeds %s" % _pct(v3))
			"grow": out.append("growing time %s" % _pct(v3))
			"pests": out.append("pests %s" % _pct(v3))
			"stones": out.append("stones %s" % _pct(v3))
			"fuel": out.append("firewood %s" % _pct(v3))
			"muck": out.append("muck %s" % _pct(v3))
			"read": out.append("reading time %s" % _pct(v3))
			"out": out.append("%s output %s" % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"feed": out.append("%s eat %s" % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"time": out.append("%s time %s" % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"in": out.append("%s needed %s" % [G.iname(parts[2]) if parts.size() > 2 else a, _pct(v3)])
			_: out.append("%s %s" % [k, _pct(v3)])
	for k in e.get("produces", {}): out.append("+1 %s every %d questions" % [G.iname(k), int(round(1.0 / maxf(0.01, float(e["produces"][k]))))])
	return ", ".join(out)

func _cost_bb(c: Dictionary) -> String:
	var parts := []
	for k in c:
		var need := float(c[k])
		var have: float = G.have(k)
		var col := "#3b6a26" if have + 0.0001 >= need else "#b9472f"
		var t := "%s%d" % [G.iemoji(k), G.up(need)]
		if have + 0.0001 < need and k != "energy": t += " (have %d)" % G.down(have)
		parts.append("[color=%s]%s[/color]" % [col, t])
	return "  ".join(parts)

func _section(title: String, note := "") -> void:
	content.add_child(UI.heading(title))
	if note != "": content.add_child(UI.label(note, 14, UI.MUTED, true))

const VERB := {"building": "🔨 Build", "station": "🔨 Build", "tool": "🛠️ Make", "gear": "🧵 Make", "helper": "🔨 Make", "land": "⛏️ Do it",
	"patch": "🟫 Upgrade", "delivery": "📦 Deliver", "pet": "🐾 Welcome home", "sidequest": "🤝 Help", "book": "🛒 Buy"}

func _node_row(id: String, show_button := true) -> PanelContainer:
	var n: Dictionary = G.nodes[id]
	var pc := UI.card()
	var v := UI.vbox(2)
	pc.add_child(v)
	var h := UI.hbox(6)
	v.add_child(h)
	h.add_child(UI.label("%s %s" % [n.get("emoji", ""), n["name"]], 17, UI.INK, true))
	var ck: Dictionary = G.can_unlock(id)
	if show_button:
		var verb: String = VERB.get(n["type"], "✔ Do it")
		if n.get("perPatch", false): verb += " (%d/%d)" % [G.patch_progress(id), G.plots()]
		h.add_child(UI.button(verb, _do_unlock.bind(id), ck["ok"], UI.GREEN, 15))
	var c: Dictionary = G.node_cost(id)
	if not c.is_empty():
		v.add_child(UI.rich(("[color=#7a705c]per patch:[/color] " if n.get("perPatch", false) else "") + _cost_bb(c), 15))
	var d := str(n.get("desc", ""))
	if d != "": v.add_child(UI.label(d, 13, UI.MUTED, true))
	if n.has("effects"):
		var et := _effect_text(n["effects"])
		if et != "": v.add_child(UI.label("✨ " + et, 13, UI.GREEN_DARK, true))
	return pc

func _do_unlock(id: String) -> void:
	G.unlock(id)

func _tab_goals() -> void:
	var main := []
	var opt := []
	var side := []
	var soon := []
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		var t: String = n["type"]
		if t in ["knowledge", "book", "polish", "animal", "crop", "merchant"]: continue
		if G.done(id) or G.satisfied(id): continue
		var mr: Array = G.missing_reqs(id)
		if mr.is_empty():
			if t == "sidequest": side.append(id)
			elif n.get("optional", false): opt.append(id)
			else: main.append(id)
		elif mr.size() == 1 and not n.get("optional", false) and t != "sidequest":
			soon.append([id, mr[0]])
	var key := func(a): return int(G.nodes[a].get("chapter", 1)) * 10 + (0 if G.can_unlock(a)["ok"] else 1)
	main.sort_custom(func(a, b): return key.call(a) < key.call(b))
	opt.sort_custom(func(a, b): return key.call(a) < key.call(b))
	_section("🎯 Next goals", "Build, make and deliver these to move the story on. Green costs you have, red ones you still need.")
	if main.is_empty(): content.add_child(UI.label("Nothing open right now — check 📚 Library for new cards, or keep farming.", 15, UI.MUTED, true))
	for id in main: content.add_child(_node_row(id))
	if not opt.is_empty():
		_section("🧰 Upgrades (optional)", "Never required — they make work cheaper for good. Gear and polish are in 🎒.")
		for id in opt:
			if G.nodes[id]["type"] == "gear": continue
			content.add_child(_node_row(id))
	if not side.is_empty():
		_section("🤝 Favours for neighbours", "Help someone: the reward is a picture for your album, and a bit of luck.")
		for id in side: content.add_child(_node_row(id))
	if not soon.is_empty():
		_section("🔒 Coming up", "One thing missing for each of these.")
		for pair in soon.slice(0, 14):
			var n2: Dictionary = G.nodes[pair[0]]
			content.add_child(UI.label("%s %s — needs %s" % [n2.get("emoji", ""), n2["name"], pair[1]], 14, UI.MUTED, true))

func _tab_make() -> void:
	var wp := UI.card()
	var wv := UI.vbox(4)
	wp.add_child(wv)
	wv.add_child(UI.label("🪵 Woodpile: %d / %d fuel  — ovens, kilns and the forge burn it; the house too in winter." % [G.down(G.S["woodpile"]), G.down(G.woodpile_cap())], 15, UI.INK, true))
	var wh := UI.hbox(6)
	wv.add_child(wh)
	for k in G.meta.get("fuel", {}).get("values", {}):
		if G.count(k) >= 1.0:
			wh.add_child(UI.soft_button("+ %s %s (%d)" % [G.iemoji(k), G.iname(k), G.down(G.count(k))], _stack.bind(k)))
	content.add_child(wp)
	for root in G.stations():
		var act: String = G.active_of(root)
		var n: Dictionary = G.nodes[act]
		var pc := UI.card()
		var v := UI.vbox(4)
		pc.add_child(v)
		var running: Array = G.S["running"].get(root, [])
		var stars: int = G.stars(root)
		var head := "%s %s   %s  busy %d/%d" % [n.get("emoji", ""), n["name"], "⭐".repeat(stars), running.size(), G.station_slots(root)]
		v.add_child(UI.label(head, 17))
		for job in running:
			var r0: Dictionary = G.recipes[job["recipe"]]
			v.add_child(UI.label("⏳ %s — %d question%s left" % [r0.get("name", G.iname(r0["outputs"].keys()[0])), G.up(job["left"]), "" if G.up(job["left"]) == 1 else "s"], 14, UI.BLUE))
		# choice slot (attachments)
		var att := []
		for hid in G.nodes:
			if G.nodes[hid].has("attach") and G.chain_members(root).has(G.nodes[hid]["attach"]): att.append(hid)
		if att.size() > 0:
			var ah := UI.hbox(6)
			ah.add_child(UI.label("Choice slot:", 13, UI.MUTED))
			for hid in att:
				var hn: Dictionary = G.nodes[hid]
				if G.done(hid):
					var active: bool = G.S["attach"].get(hn["attach"], "") == hid
					if active: ah.add_child(UI.button("✔ " + hn.get("emoji", "") + " " + hn["name"], Callable(), true, UI.GREEN, 13))
					else: ah.add_child(UI.soft_button("use " + hn.get("emoji", "") + " " + hn["name"], G.set_attach.bind(hn["attach"], hid), true, 13))
				else:
					ah.add_child(UI.label("(%s %s: make it in 🎯 Goals)" % [hn.get("emoji", ""), hn["name"]], 12, UI.MUTED))
			v.add_child(ah)
		for rid in G.station_recipes_for(root):
			var r: Dictionary = G.recipes[rid]
			var title := str(r.get("name", G.iname(r["outputs"].keys()[0])))
			if not G.recipe_open(rid):
				var why := []
				for q in r.get("requires", []):
					if not G.satisfied(q): why.append(G.nodes[q].get("emoji", "") + " " + G.nodes[q]["name"])
				v.add_child(UI.label("🔒 %s — needs %s" % [title, ", ".join(why)], 13, UI.MUTED, true))
				continue
			var row := UI.hbox(6)
			var outs := []
			for k in r["outputs"]: outs.append("%s%s" % [G.iemoji(k), _num(float(r["outputs"][k]) * G.m("out:" + r["station"]))])
			var c: Dictionary = G.recipe_cost(rid)
			var extra := []
			var fuel: float = G.recipe_fuel(rid)
			if fuel > 0.0: extra.append("🪵%d" % G.up(fuel))
			var tm: float = G.recipe_time(rid)
			if tm > 0.0: extra.append("⏳%d" % G.up(tm))
			for k in r.get("keeps", []): extra.append("keeps %s" % G.iemoji(k))
			var lab := UI.rich("[b]%s[/b] → %s   %s  [color=#7a705c]%s[/color]" % [title, " ".join(outs), _cost_bb(c), " ".join(extra)], 14)
			row.add_child(lab)
			var ok: bool = G.missing_cost(c).is_empty() and running.size() < G.station_slots(root)
			row.add_child(UI.button("Make", _make.bind(rid), ok, UI.GREEN, 14))
			v.add_child(row)
		content.add_child(pc)

func _stack(k: String) -> void:
	var n: float = G.stack_wood(k, G.count(k))
	if n > 0.0: G.say("🪵 Stacked %d %s on the woodpile." % [int(n), G.iname(k)])
	G.save_game(); _queue_refresh()

func _make(rid: String) -> void:
	G.start_recipe(rid)

func _tab_animals() -> void:
	_section("🐔 Animals", "Animals need feed, water and bedding straw. Collecting leaves muck — muck it out for manure (great compost).")
	var any := false
	for aid in G.nodes:
		if G.nodes[aid]["type"] != "animal": continue
		var n: Dictionary = G.nodes[aid]
		if not G.missing_reqs(aid).is_empty() and not G.done(aid): continue
		any = true
		var a: Dictionary = G.animal(aid)
		var pc := UI.card()
		var v := UI.vbox(4)
		pc.add_child(v)
		var h := UI.hbox(6)
		v.add_child(h)
		h.add_child(UI.label("%s %s  %d / %d" % [n.get("emoji", ""), n["name"], int(a["count"]), G.animal_cap(aid)], 18))
		h.add_child(UI.spacer())
		var can_buy: bool = int(a["count"]) < G.animal_cap(aid) and G.missing_cost(G.animal_price(aid)).is_empty()
		h.add_child(UI.button("Buy one  " + G.cost_text(G.animal_price(aid)), G.buy_animal.bind(aid), can_buy, UI.GREEN, 14))
		v.add_child(UI.label(str(n.get("desc", "")), 13, UI.MUTED, true))
		if int(a["count"]) > 0:
			var ready: bool = G.S["step"] >= int(a["ready"])
			var row := UI.hbox(6)
			row.add_child(UI.rich("Each collection needs: " + _cost_bb(G.feed_needs(aid)), 14))
			row.add_child(UI.button("🧺 Collect" if ready else "⏳ in %d" % (int(a["ready"]) - G.S["step"]), G.collect_animal.bind(aid), ready, UI.GREEN, 14))
			v.add_child(row)
			if n.get("needsFlowers", false):
				v.add_child(UI.label("🌼 Flowers on the farm: %s" % ("yes" if G.has_flowers() else "none — plant clover, flax or sunflowers"), 13, UI.GREEN_DARK if G.has_flowers() else UI.RED))
			if float(n.get("muck", 0.0)) > 0.0:
				var mf: float = G.muck_factor(aid)
				var mrow := UI.hbox(6)
				mrow.add_child(UI.label("💩 Muck %d %s" % [G.down(a["muck"]), "" if mf >= 1.0 else "— animals give %d%% less!" % int(round((1.0 - mf) * 100))], 14, UI.INK if mf >= 1.0 else UI.RED))
				mrow.add_child(UI.spacer())
				mrow.add_child(UI.soft_button("Muck out (⚡%d)" % G.up(G.ecost("animal", float(a["muck"]) * 0.5)), G.muck_out.bind(aid), float(a["muck"]) >= 0.5))
				v.add_child(mrow)
		content.add_child(pc)
	if not any: content.add_child(UI.label("No animals yet. A coop comes early in chapter 1 (see 🎯 Goals).", 15, UI.MUTED, true))

const CAT_ORDER := ["crop", "animal", "ingredient", "dish", "material", "textile", "fertilizer", "byproduct", "feed", "fuel", "container", "craft", "find", "seed", "keeper", "pet-item"]

func _tab_pantry() -> void:
	_section("🧺 Pantry", "Store holds %d of each. ⏳ = will go stale at the next change of season — sell it, eat it or cook it into something that keeps." % G.down(G.storage_cap()))
	var keys: Array = G.S["inv"].keys()
	keys.sort_custom(func(a, b):
		return CAT_ORDER.find(G.items[a].get("category", "")) * 1000 + G.items.keys().find(a) < CAT_ORDER.find(G.items[b].get("category", "")) * 1000 + G.items.keys().find(b))
	for k in keys:
		var q: float = G.count(k)
		if q < 0.999 and G.items[k].get("category", "") != "keeper": continue
		var it: Dictionary = G.items[k]
		var row := UI.hbox(6)
		var t := "%s %s × %d" % [it.get("emoji", ""), it["name"], G.down(q)]
		var ss: float = G.stale_soon(k)
		if ss >= 1.0: t += "   ⏳ %d stale soon" % G.down(ss)
		row.add_child(UI.label(t, 15, UI.INK if ss < 1.0 else UI.AMBER))
		row.add_child(UI.spacer())
		if it.has("buff"): row.add_child(UI.soft_button("😋 Eat (−%d%% ⚡ for %d)" % [int(round((1.0 - float(it["buff"]["energy"])) * 100)), int(it["buff"]["questions"])], G.eat.bind(k)))
		if G.fuel_value(k) > 0.0: row.add_child(UI.soft_button("🪵 Burn", _stack.bind(k)))
		if G.value_of(k) > 0.0:
			row.add_child(UI.label("🪙%s" % str(snappedf(G.sell_price(k), 0.1)), 13, UI.MUTED))
			row.add_child(UI.soft_button("Sell 1", G.sell.bind(k, 1.0)))
			row.add_child(UI.soft_button("Sell all", G.sell.bind(k, 999.0)))
		content.add_child(row)
	var seeds := []
	for cid in G.S["seeds"]:
		if float(G.S["seeds"][cid]) >= 1.0: seeds.append("%s %d" % [G.nodes[cid].get("emoji", ""), G.down(G.S["seeds"][cid])])
	if seeds.size() > 0:
		_section("🌱 Seeds")
		content.add_child(UI.label("  ".join(seeds), 16))

func _tab_market() -> void:
	_section("🌱 Seed Merchant", "Planting buys missing seeds automatically, but you can stock up here.")
	for cid in G.nodes:
		var n: Dictionary = G.nodes[cid]
		if n["type"] != "crop" or not G.done(cid) or n.has("seedItem"): continue
		var row := UI.hbox(6)
		row.add_child(UI.label("%s %s seed  🪙%s   (you have %d)" % [n.get("emoji", ""), n["name"], str(n.get("seedCost", 0)), G.down(G.seed_have(cid))], 15))
		row.add_child(UI.spacer())
		row.add_child(UI.soft_button("Buy 1", G.buy_seeds.bind(cid, 1)))
		row.add_child(UI.soft_button("Buy 5", G.buy_seeds.bind(cid, 5)))
		content.add_child(row)
	for mid in G.nodes:
		var mn: Dictionary = G.nodes[mid]
		if mn["type"] != "merchant" or not G.done(mid): continue
		if mn.get("sells", {}).is_empty() and mn.get("barter", {}).is_empty(): continue
		_section("%s %s" % [mn.get("emoji", ""), mn["name"]], str(mn.get("desc", "")))
		for k in mn.get("sells", {}):
			var row2 := UI.hbox(6)
			row2.add_child(UI.label("%s %s  🪙%s" % [G.iemoji(k), G.iname(k), str(mn["sells"][k])], 15))
			row2.add_child(UI.spacer())
			row2.add_child(UI.soft_button("Buy 1", G.buy_item.bind(mid, k, 1)))
			row2.add_child(UI.soft_button("Buy 5", G.buy_item.bind(mid, k, 5)))
			content.add_child(row2)
		for k in mn.get("barter", {}):
			var row3 := UI.hbox(6)
			var c := {}
			for x in mn["barter"][k]: c[x] = float(mn["barter"][k][x])
			row3.add_child(UI.rich("%s %s  for  %s" % [G.iemoji(k), G.iname(k), _cost_bb(c)], 15))
			row3.add_child(UI.soft_button("Trade", G.barter.bind(mid, k)))
			content.add_child(row3)
	if G.S["gift_shop"].size() > 0:
		_section("🎁 Gift card shop", "Cards you didn't pick at a milestone. 🪙%d each." % int(G.gift_price()))
		for gid in G.S["gift_shop"]:
			var c2: Dictionary = G.gift_card(gid)
			var row4 := UI.hbox(6)
			row4.add_child(UI.label("%s %s — %s" % [c2.get("emoji", ""), c2["name"], c2.get("desc", "")], 15, UI.INK, true))
			row4.add_child(UI.soft_button("Buy", G.buy_gift.bind(gid)))
			content.add_child(row4)

func _tab_library() -> void:
	var lib := ""
	for lid in ["library_room", "library_bookcase", "library_shelf", "library_box"]:
		if G.done(lid) and lib == "": lib = lid
	var ln: Dictionary = G.nodes[lib] if lib != "" else {"emoji": "📦", "name": "Book box"}
	_section("%s %s · %d/%d books · %d of %d cards learned" % [ln.get("emoji", ""), ln["name"], G.books_owned(), int(round(G.g("bookSlots", 1.0))), G.cards_learned(), G.card_ids.size()],
		"Read a card (takes a few Time Quiz questions), then answer its quiz. Cards unlock new things or give lasting boosts. Due reviews pop up in the Time Quiz.")
	if G.S["reading"] != "":
		var rc: String = G.S["reading"]
		var row := UI.hbox(8)
		row.add_child(UI.label("📖 Reading: %s" % G.nodes[rc]["name"], 16))
		row.add_child(UI.bar(float(G.S["read_progress"]) / maxf(0.1, G.read_needed(rc)), 160, 12, UI.BLUE))
		row.add_child(UI.label("answer Time Quiz questions to read on", 13, UI.MUTED))
		content.add_child(row)
	var due: int = G.due_cards().size()
	if due > 0: content.add_child(UI.label("🔁 %d card%s due for a review — they'll show up in the Time Quiz." % [due, "" if due == 1 else "s"], 14, UI.BLUE))
	if G.done("book_cart"):
		var books := []
		for bid in G.nodes:
			if G.nodes[bid]["type"] == "book" and not G.done(bid): books.append(bid)
		books.sort_custom(func(a, b): return int(G.nodes[a]["chapter"]) < int(G.nodes[b]["chapter"]))
		if books.size() > 0:
			_section("🛒 Book Cart")
			for bid in books:
				var bn: Dictionary = G.nodes[bid]
				var row2 := UI.hbox(6)
				var ck: Dictionary = G.can_unlock(bid)
				row2.add_child(UI.label("%s %s — %s" % [bn.get("emoji", ""), bn["name"], bn.get("desc", "")], 14, UI.INK if ck["ok"] else UI.MUTED, true))
				row2.add_child(UI.button("Buy 🪙%d" % G.up(float(bn.get("cost", {}).get("coins", 0))), _do_unlock.bind(bid), ck["ok"], UI.GREEN, 14))
				content.add_child(row2)
				if not ck["ok"]: content.add_child(UI.label("   " + str(ck["why"]), 12, UI.MUTED, true))
	for bid in G.nodes:
		if G.nodes[bid]["type"] != "book" or not G.done(bid): continue
		var bn2: Dictionary = G.nodes[bid]
		_section("%s %s" % [bn2.get("emoji", ""), bn2["name"]])
		for cid in G.card_ids:
			if G.nodes[cid]["requires"][0] != bid: continue
			content.add_child(_card_row(cid))

func _card_row(cid: String) -> HBoxContainer:
	var n: Dictionary = G.nodes[cid]
	var st: String = G.card_status(cid)
	var row := UI.hbox(6)
	var t := "%s %s" % [n.get("emoji", ""), n["name"]]
	match st:
		"learned":
			var box_n := int(G.S["cards"].get(cid, {}).get("box", 1))
			row.add_child(UI.label("✅ " + t + "  " + "⭐".repeat(box_n), 15, UI.GREEN_DARK))
			row.add_child(UI.spacer())
			row.add_child(UI.soft_button("📖 Read again", _show_card.bind(cid)))
		"quiz":
			row.add_child(UI.label("❓ " + t, 15))
			row.add_child(UI.spacer())
			row.add_child(UI.button("Take the quiz", _show_card.bind(cid), true, UI.GREEN, 14))
		"reading":
			row.add_child(UI.label("⏳ %s — reading %d / %d" % [t, int(G.S["read_progress"]), G.up(G.read_needed(cid))], 15, UI.BLUE))
		"readable":
			row.add_child(UI.label("📖 %s  (reading takes %d question%s)" % [t, G.up(G.read_needed(cid) * G.m("read")), "" if G.up(G.read_needed(cid) * G.m("read")) == 1 else "s"], 15))
			row.add_child(UI.spacer())
			row.add_child(UI.button("Start reading", G.start_reading.bind(cid), G.S["reading"] == "", UI.BLUE, 14))
		"prereq":
			var miss := []
			for r in n["requires"]:
				if not G.satisfied(r): miss.append(G.nodes[r]["name"])
			row.add_child(UI.label("🔒 %s — first: %s" % [t, ", ".join(miss)], 14, UI.MUTED, true))
		"discover":
			var miss2 := []
			for k in n.get("discover", []):
				if not G.S["seen"].has(k): miss2.append(G.iemoji(k) + " " + G.iname(k))
			row.add_child(UI.label("🔍 %s — find %s first" % [t, ", ".join(miss2)], 14, UI.MUTED, true))
		_:
			row.add_child(UI.label("🔒 " + t, 14, UI.MUTED))
	return row

const GEAR_SLOTS := [["feet", "👣 Feet"], ["hands", "🧤 Hands"], ["back", "🎒 Back"], ["bottle", "🫗 Water bottle"], ["head", "👒 Head"], ["apron", "🥼 Apron"], ["pillow", "🛌 Pillow"], ["bed", "🛏️ Bed"]]

func _tab_gear() -> void:
	_section("🎒 Gear", "Things a real farmer would wear and carry. Each makes some work cheaper or Rest give more energy.")
	for s in GEAR_SLOTS:
		var chain := []
		for id in G.nodes:
			if str(G.nodes[id].get("slot", "")) == "gear:" + s[0] and G.nodes[id]["type"] in ["gear", "helper"]: chain.append(id)
		chain.sort_custom(func(a, b): return int(G.nodes[a]["chapter"]) < int(G.nodes[b]["chapter"]))
		var cur := ""
		var nxt := ""
		for id in chain:
			if G.done(id): cur = id
			elif nxt == "" and not G.satisfied(id): nxt = id
		var pc := UI.card()
		var v := UI.vbox(2)
		pc.add_child(v)
		var cn: String = (G.nodes[cur].get("emoji", "") + " " + G.nodes[cur]["name"] + " — " + _effect_text(G.nodes[cur].get("effects", {}))) if cur != "" else "nothing yet"
		v.add_child(UI.label("%s: %s" % [s[1], cn], 15, UI.INK, true))
		if nxt != "":
			var h := UI.hbox(6)
			var nn: Dictionary = G.nodes[nxt]
			var ck: Dictionary = G.can_unlock(nxt)
			h.add_child(UI.rich("→ %s %s  %s  [color=#3b6a26]%s[/color]" % [nn.get("emoji", ""), nn["name"], _cost_bb(G.node_cost(nxt)), _effect_text(nn.get("effects", {}))], 14))
			h.add_child(UI.button("🧵 Make", _do_unlock.bind(nxt), ck["ok"], UI.GREEN, 14))
			v.add_child(h)
			if not ck["ok"] and not G.missing_reqs(nxt).is_empty(): v.add_child(UI.label("   needs " + ", ".join(G.missing_reqs(nxt)), 12, UI.MUTED, true))
		content.add_child(pc)
	_section("✨ Polish — endless upgrades", "Sharpen, oil, clean, re-stuff… The first time helps most; every next time adds half as much and costs more. Use wears it off slowly.")
	for pid in G.polish_ids:
		if not G.polish_open(pid): continue
		var n: Dictionary = G.nodes[pid]
		var p: float = G.polish_level(pid)
		var pc2 := UI.card()
		var v2 := UI.vbox(2)
		pc2.add_child(v2)
		var h2 := UI.hbox(6)
		h2.add_child(UI.label("%s %s" % [n.get("emoji", ""), n["name"]], 16))
		h2.add_child(UI.bar(G.polish_gain(pid, p), 90, 10, UI.AMBER))
		h2.add_child(UI.label("%d%% → %d%%" % [int(round(G.polish_gain(pid, p) * 100)), int(round(G.polish_gain(pid, floorf(p) + 1.0) * 100))], 13, UI.MUTED))
		h2.add_child(UI.spacer())
		var c: Dictionary = G.polish_cost(pid)
		h2.add_child(UI.button("✨ " + G.cost_text(c), G.do_polish.bind(pid), G.missing_cost(c).is_empty(), UI.AMBER, 14))
		v2.add_child(h2)
		v2.add_child(UI.label("At full polish: " + _effect_text(n.get("effects", {})), 13, UI.GREEN_DARK, true))
		content.add_child(pc2)

func _tab_album() -> void:
	_section("🐾 Pets")
	var any := false
	for pid in ["pet_bunny", "pet_tortoise", "pet_goat", "pet_pony", "pet_alpaca"]:
		if G.done(pid):
			any = true
			var n: Dictionary = G.nodes[pid]
			content.add_child(UI.label("%s %s — %s" % [n.get("emoji", ""), G.S["pet_names"].get(pid, n.get("defaultName", "")), _effect_text(n.get("effects", {}))], 16, UI.INK, true))
	if not any: content.add_child(UI.label("Your first pet, a bunny, comes home at the end of chapter 1.", 15, UI.MUTED, true))
	_section("🖼️ Pictures", "Every favour you do for a neighbour gives a picture. (Placeholder text until the art is drawn.)")
	for a in G.S["album"]:
		var pc := UI.card(Color("fff6e0"))
		pc.add_child(UI.label("%s  %s" % [a.get("emoji", "🖼️"), a["text"]], 15, UI.INK, true))
		content.add_child(pc)
	_section("🌰 Golden acorns: %d / %d" % [G.S["acorns"].size(), G.meta.get("acorns", {}).get("list", []).size()], "Each one gives +3 energy max for good. They hide in different places.")
	for a in G.meta.get("acorns", {}).get("list", []):
		content.add_child(UI.label(("🌰 " if G.S["acorns"].has(a["id"]) else "❔ ") + str(a["name"] if G.S["acorns"].has(a["id"]) else "???"), 15))
	_section("🎁 Gift cards")
	for gid in G.S["gift_owned"]:
		var c: Dictionary = G.gift_card(gid)
		content.add_child(UI.label("%s %s — %s" % [c.get("emoji", ""), c["name"], c.get("desc", "")], 15))

func _tab_log() -> void:
	_section("📜 What happened")
	var lines: Array = G.S["log"].duplicate()
	lines.reverse()
	for t in lines: content.add_child(UI.label(str(t), 14, UI.INK, true))
