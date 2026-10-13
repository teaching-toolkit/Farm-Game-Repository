extends RefCounted
class_name FarmUiTimeQuiz
## The Time Quiz: the question pop-up (text, picture or picture answers), what a right or wrong first try does, read aloud.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ celebrations: something new was built or made

func speak(text: String) -> void:
	var voices := DisplayServer.tts_get_voices_for_language(I18n.lang)      # a voice in the game's language
	if voices.is_empty(): voices = DisplayServer.tts_get_voices_for_language("en")
	if voices.size() > 0:
		DisplayServer.tts_stop()
		DisplayServer.tts_speak(text, voices[0])

func _atext(a) -> String:
	return str(a.get("text", "")) if typeof(a) == TYPE_DICTIONARY else str(a)

## A quiz picture: assets/<folder>/<name>.png for img "folder/name", else the emoji drawn big.
func _quiz_pic(img: String, emoji: String, size: float) -> Control:
	var t: Texture2D = null
	if img.contains("/"):
		var k := img.rfind("/")
		t = Art.tex(img.substr(0, k), img.substr(k + 1))
	var c: Control
	if t != null:
		var r := TextureRect.new()
		r.texture = t
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		c = r
	else:
		var l := UI.label(emoji, int(size * 0.6))
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		c = l
	c.custom_minimum_size = Vector2(size, size)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c

## One multiple-choice question (3–4 answers). It can have a picture above it, and picture answers (then shown as big
## picture buttons, two by two). Wrong picks grey out and show why; the right pick calls on_done(first_try).
func question(box: VBoxContainer, q: Dictionary, on_done: Callable) -> void:
	var qh := UI.hbox(8)
	var ql := UI.label(str(q["q"]), 24, UI.INK, true)
	ql.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	qh.add_child(ql)
	var words := []
	for a in q["answers"]: words.append(_atext(a))
	var aloud := str(q["q"]) + ". " + ". ".join(words)
	if G.read_aloud_mode() != "off":
		var sp := UI.soft_button("🔊", speak.bind(aloud), true, 20)
		sp.custom_minimum_size = Vector2(52, 44)
		qh.add_child(sp)
		if G.read_aloud_mode() == "auto": speak.call_deferred(aloud)
	box.add_child(qh)
	if str(q.get("img", "")) != "" or str(q.get("emoji", "")) != "":
		var pc := CenterContainer.new()
		pc.add_child(_quiz_pic(str(q.get("img", "")), str(q.get("emoji", "")), 150))
		box.add_child(pc)
	var feedback := UI.label("", 18, UI.MUTED, true)
	var buttons := []
	var state := {"first": true, "done": false}
	var grid: GridContainer = null
	if q.get("pictures", false):
		grid = GridContainer.new()
		grid.columns = 2
		grid.add_theme_constant_override("h_separation", 14)
		grid.add_theme_constant_override("v_separation", 14)
		var gc := CenterContainer.new()
		gc.add_child(grid)
		box.add_child(gc)
	for i in range(q["answers"].size()):
		var a = q["answers"][i]
		var b: Button
		if grid != null:
			b = UI.button("", Callable(), true, Color("fffaf0"), 21)
			for st in ["normal", "hover", "pressed"]:
				b.add_theme_stylebox_override(st, UI.box(Color("fffaf0") if st != "pressed" else Color("f1e6cc"), 16, Color("6c8fb3"), 3, 6))
			b.custom_minimum_size = Vector2(176, 176)
			b.tooltip_text = _atext(a)
			var cc := CenterContainer.new()
			cc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			cc.mouse_filter = Control.MOUSE_FILTER_IGNORE
			cc.add_child(_quiz_pic(str(a.get("img", "")), str(a.get("emoji", "")), 140))
			b.add_child(cc)
			b.set_meta("pic", cc)
			grid.add_child(b)
		else:
			b = UI.button(_atext(a), Callable(), true, Color("6c8fb3"), 21)
			b.custom_minimum_size = Vector2(0, 56)
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			box.add_child(b)
		buttons.append(b)
	box.add_child(feedback)
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_answer_pressed.bind(i, q, buttons, feedback, state, on_done))
	M.modals.fit_modal.call_deferred()

func _answer_pressed(i: int, q: Dictionary, buttons: Array, feedback: Label, state: Dictionary, on_done: Callable) -> void:
	if state["done"]: return
	var b: Button = buttons[i]
	if i == int(q["correct"]):
		state["done"] = true
		b.add_theme_stylebox_override("disabled", UI.box(UI.GREEN, 10, Color(0, 0, 0, 0), 0, 10))
		for x in buttons:
			x.disabled = true
			if x != b and x.has_meta("pic"): x.get_meta("pic").modulate.a = 0.35
		var why := str(q.get("why", ""))
		if why == "": why = _atext(q["answers"][i]) + "."
		var own := false     # the pack's own line already says "Yes!" / "Right!" …
		for w in ["Yes", "Right", "Correct", "Exactly", "Ja", "Richtig", "Genau", "Stimmt"]:
			if why.begins_with(w + "!"): own = true
		feedback.text = "✅ " + ("" if own else tr("Right! ")) + why
		M.feedback.sfx("right")
		feedback.add_theme_color_override("font_color", UI.GREEN_DARK)
		on_done.call(state["first"])
		M.modals.fit_modal.call_deferred()
	else:
		state["first"] = false
		b.disabled = true
		b.add_theme_stylebox_override("disabled", UI.box(Color("d9a89c"), 10, Color(0, 0, 0, 0), 0, 10))
		if b.has_meta("pic"): b.get_meta("pic").modulate.a = 0.35
		var hint := str(q.get("wrong_text", ""))
		if hint == "": hint = tr("Not quite. ") + str(q.get("why", ""))
		feedback.text = "❌ " + hint + tr("  Try again!")
		M.feedback.sfx("wrong")
		feedback.add_theme_color_override("font_color", UI.RED)

# ------------------------------------------------------------------ Time Quiz

func show_quiz_id(id: String) -> void:
	for i in range(G.pack_questions.size()):
		if str(G.pack_questions[i].get("id", "")) == id:
			var q: Dictionary = G.knowledge.shuffled_q(G.pack_questions[i], "", i, false)
			q["wrong_text"] = q["wrong"]
			q["source"] = tr("⏳ Time Quiz")
			show_time_quiz(q)

func show_time_quiz(forced: Dictionary = {}) -> void:
	var q: Dictionary = forced if not forced.is_empty() else G.knowledge.next_time_question()
	var box := M.modals.open_modal(tr("❓ Time Quiz"))
	Sound.music("quiz")
	box.add_child(UI.header(null, "⏳", 64))
	box.add_child(UI.label(str(q.get("source", "")) + tr("   ·   every right answer moves farm time one step"), 15, UI.MUTED, true))
	var qbox := UI.vbox(8)
	box.add_child(qbox)
	var after := UI.vbox(8)
	box.add_child(after)
	question(qbox, q, _time_answered.bind(q, after))

## Only a right FIRST try moves farm time one step. After a wrong first pick the child keeps trying until the right answer
## (and its "why") shows, but time stays where it was, and the question comes back right after the next one.
func _time_answered(first_try: bool, q: Dictionary, after: VBoxContainer) -> void:
	if q.get("review", false): G.knowledge.record_card_answer(q, first_try)
	else: G.knowledge.time_result(q, first_try)
	if not first_try:
		G.knowledge.retry_after_next(q)
		after.add_child(UI.label(tr("⏸️ Time stays where it is: only a right first answer moves the farm on. This question comes back soon."), 17, UI.MUTED, true))
		_time_quiz_buttons(after)
		return
	var info: Dictionary = G.step_time()
	var msg := tr("⏳ Time moves on: question %d.") % G.S["step"]
	if info.get("rain_stopped", false) and G.rewards.perk_on("perk_rainbow"):
		M.map.rainbow()
		M.feedback.sfx("rainbow")
		M.after_close.append(tr("🌈 The rain has stopped — look, a rainbow!"))
	if info.get("rain", false):
		msg += tr(" 🌧️ It rained.")
		M.after_close.append(tr("🌧️ Rain! The fields are watered — planting costs no water until the next question."))
	if int(info.get("removed", 0)) > 0: msg += (tr(" 🧍 The scarecrow chased off %d pest.") if int(info["removed"]) == 1 else tr(" 🧍 The scarecrow chased off %d pests.")) % int(info["removed"])
	if float(info.get("eat_share", 0.0)) >= 0.005: msg += tr(" 🐦 Pests ate %d%% of what is growing.") % int(round(float(info["eat_share"]) * 100.0))
	after.add_child(UI.label(msg, 17, UI.MUTED, true))
	_time_quiz_buttons(after)

func _time_quiz_buttons(after: VBoxContainer) -> void:
	var row := UI.hbox(8)
	var nb := UI.button(tr("Next question ▶"), show_time_quiz, true, UI.GREEN, 21)
	nb.custom_minimum_size = Vector2(0, 56)
	nb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(nb)
	var back := UI.soft_button(tr("⬅️ Back to the farm"), M.modals.close_modal, true, 18)
	back.custom_minimum_size = Vector2(0, 56)
	row.add_child(back)
	after.add_child(row)
	M.modals.fit_modal.call_deferred()
