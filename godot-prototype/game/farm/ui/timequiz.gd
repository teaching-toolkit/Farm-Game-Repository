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
	_shown = [q, buttons, feedback, state, on_done]
	M.modals.fit_modal.call_deferred()

var _shown := []      # the question on screen now (screenshots: --answer)

## Screenshots: the question on screen is answered right at the first try (--answer).
func answer_right() -> void:
	if _shown.is_empty(): return
	_answer_pressed(int(_shown[0]["correct"]), _shown[0], _shown[1], _shown[2], _shown[3], _shown[4])

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

# ------------------------------------------------------------------ the question pop-up: farm time and the walks

## A pack question by its id (testing: --qid=PIC-004), shown as a Time Quiz question.
func show_quiz_id(id: String) -> void:
	var q: Dictionary = G.timeq.question_by_id(id)
	if not q.is_empty(): show_time_quiz(q)

## The Time Quiz on the farm (purpose farm).
func show_time_quiz(forced: Dictionary = {}) -> void:
	ask("farm", {"title": tr("❓ Time Quiz"), "emoji": "⏳", "line": tr("   ·   every right answer moves farm time one step")}, forced)

## The one question on the way to the village (the trip's energy is already paid; a market trip waits until one is answered right first time).
func show_trip_question() -> void:
	ask("to_village", {"title": tr("🚶 On the way to the village"), "emoji": "🏘️",
		"wrong": tr("⏸️ Not quite: only a right first answer gets you to the village. Try the next one."), "go": _to_square})

## The one question on the way to a neighbour's farm: after a right first try the visit happens and shows its scene.
func show_visit_question() -> void:
	ask("visit", {"title": tr("🚶 On the way to %s") % G.well.invite(), "emoji": "💌", "text_size": 18,
		"button": tr("🏡 Back to the farm"), "go": M.modals.close_modal})

## A walk into the forest or out of it (purpose into_forest / out_of_forest). cfg = {"purpose", "title", "emoji"}.
func show_walk_question(cfg: Dictionary) -> void:
	var c := cfg.duplicate()
	c["go"] = _walk_done
	ask(str(cfg["purpose"]), c)

## The question pop-up, the same for every purpose: the question, then right or wrong and time moving. Only a right first try moves
## time and lets the purpose happen (G.timeq.answered holds the rule; this only draws the report). After a wrong first pick the child
## keeps trying until the right answer (and its "why") shows; time stays and the question comes back after the next one. What happened
## on the farm (rain, pests …) is not told here: the playback shows it on the farm (ui/playback.gd).
## A right answer on a walk shows the green answer for a moment, then the pop-up closes into the place ("go"), with no arrival line
## (the background will show where the farmer is); a visit keeps its scene and its "Back to the farm" button.
## cfg = {"title", "emoji", "line" (after the source), "wrong" (after a wrong first try), "go": Callable (walks), "text_size",
## "button" (the visit)}.
func ask(purpose: String, cfg: Dictionary, forced: Dictionary = {}) -> void:
	var q: Dictionary = forced if not forced.is_empty() else G.timeq.next()
	M.playback.begin()          # the farm keeps its old look until the pop-up closes (J4)
	var box := M.modals.open_modal(str(cfg["title"]))
	Sound.music("quiz")
	box.add_child(UI.header(null, str(cfg["emoji"]), 64))
	box.add_child(UI.label(str(q.get("source", "")) + str(cfg.get("line", tr("   ·   one question, then you are there"))), 15, UI.MUTED, true))
	var qbox := UI.vbox(8)
	box.add_child(qbox)
	var after := UI.vbox(8)
	box.add_child(after)
	question(qbox, q, _answered.bind(q, after, purpose, cfg))

func _answered(first_try: bool, q: Dictionary, after: VBoxContainer, purpose: String, cfg: Dictionary) -> void:
	var rep: Dictionary = G.timeq.answered(q, first_try, purpose)
	if purpose == "farm":
		_farm_report(rep, after)
		return
	if not rep["moved"]:
		after.add_child(UI.label(str(cfg.get("wrong", tr("⏸️ Not quite: only a right first answer gets you there. Try the next one."))), 17, UI.MUTED, true))
		var nb := UI.button(tr("Next question ▶"), ask.bind(purpose, cfg), true, UI.GREEN, 21)
		nb.custom_minimum_size = Vector2(0, 56)
		after.add_child(nb)
		M.modals.fit_modal.call_deferred()
		return
	if purpose != "visit":
		await M.get_tree().create_timer(G.feel("playback.walkRight")).timeout
		if not is_instance_valid(after) or not after.is_inside_tree(): return      # the pop-up was closed meanwhile: the farm plays it
		M.playback.postpone()
		(cfg["go"] as Callable).call()
		return
	var text := str(rep["follow"])
	if text != "": after.add_child(UI.label(text, int(cfg.get("text_size", 17)), UI.INK, true))
	var go := UI.button(str(cfg["button"]), cfg["go"], true, UI.GREEN, 22)
	go.custom_minimum_size = Vector2(0, 56)
	after.add_child(go)
	M.modals.fit_modal.call_deferred()

## The farm's report: time stays (wrong first try) or moves on (⏳ and the question number). The news is the playback's.
func _farm_report(rep: Dictionary, after: VBoxContainer) -> void:
	if not rep["moved"]:
		after.add_child(UI.label(tr("⏸️ Time stays where it is: only a right first answer moves the farm on. This question comes back soon."), 17, UI.MUTED, true))
		_time_quiz_buttons(after)
		return
	after.add_child(UI.label(tr("⏳ Time moves on: question %d.") % int(rep["step"]), 17, UI.MUTED, true))
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

func _walk_done() -> void:
	M.modals.close_modal()
	M.sheets.open_sheet.call_deferred("forest")

func _to_square() -> void:
	M.modals.close_modal()
	M.sheets.open_spot.call_deferred("market")
