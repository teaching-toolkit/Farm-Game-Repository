## LearnKit · a ready-made sums window: the level with its medals, the task, a number pad, a timer bar and kind words.
## Put it into any pop-up of any game; it asks, checks and remembers by itself and tells the game what happened.
##
##   var pad = preload("res://learnkit/number_pad_quiz.gd").new()
##   pad.setup(math_engine, learner.data, rng, {"scale": 1.0, "streak": true})
##   popup.add_child(pad)
##   pad.before_next.connect(func(): if player_is_rested: pad.stop("Full of energy!"))
##   pad.answered.connect(func(res): ...)    # res: q, typed, right, quick, secs, fb (see math_engine.result), text, wait
##   pad.next()
## In the answered handler the game may change res["text"] (what the feedback line says) and res["wait"] (seconds
## until the next task), give a reward, play an effect — or call pad.stop("…").
extends VBoxContainer

signal answered(res: Dictionary)
signal before_next

const QuizTimer = preload("quiz_timer.gd")

var engine                      # math_engine.gd
var L: Dictionary = {}          # the learner's record (learner.gd data)
var rng: RandomNumberGenerator
var opts := {}
var question: Dictionary = {}
var timer = QuizTimer.new()
var typed := ""
var busy := true
var stopped := false
var late := false
var _pick := {}                 # the turn counters before the task on screen was picked (see abandon)

var col := {"ink": Color("3b2f2a"), "muted": Color("7a705c"), "green": Color("4f9a3c"), "green_dark": Color("3c7a2c"),
	"red": Color("c0503a"), "amber": Color("e0a030"), "key": Color("6c8fb3"), "back": Color("b8af9c"), "paper": Color.WHITE,
	"line": Color("d8cdb8"), "medal_bar": Color("f2b632"), "streak": Color("d9622b")}

var lvl_lbl: Label
var lvl_bar: ProgressBar
var medal_lbl: Label
var streak_lbl: Label
var q_lbl: Label
var ans_box: PanelContainer
var ans_lbl: Label
var bar: ProgressBar
var fb_lbl: Label
var grid: GridContainer
var extra: HBoxContainer

## opts: scale (stretches every time limit), streak (show the flame), colors {name: Color}, font sizes q/answer.
func setup(math_engine, learner_data: Dictionary, random: RandomNumberGenerator, options := {}) -> void:
	engine = math_engine
	L = learner_data
	rng = random
	opts = options
	for k in opts.get("colors", {}): col[k] = opts["colors"][k]

func _ready() -> void:
	add_theme_constant_override("separation", 8)
	alignment = BoxContainer.ALIGNMENT_CENTER
	var lr := HBoxContainer.new()
	lr.alignment = BoxContainer.ALIGNMENT_CENTER
	lr.add_theme_constant_override("separation", 8)
	lvl_lbl = _label("", 17, col["ink"])
	lr.add_child(lvl_lbl)
	lvl_bar = _bar(120, 10, col["medal_bar"])
	lr.add_child(lvl_bar)
	medal_lbl = _label("", 18, col["ink"])
	lr.add_child(medal_lbl)
	streak_lbl = _label("", 20, col["streak"])
	lr.add_child(streak_lbl)
	add_child(lr)
	q_lbl = _label("", int(opts.get("q_size", 44)), col["ink"])
	q_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(q_lbl)
	ans_box = PanelContainer.new()
	ans_box.add_theme_stylebox_override("panel", _box(col["paper"], 12, col["line"], 2, 10))
	ans_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ans_box.custom_minimum_size = Vector2(200, 0)
	ans_lbl = _label("?", int(opts.get("answer_size", 40)), col["ink"])
	ans_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ans_box.add_child(ans_lbl)
	add_child(ans_box)
	bar = _bar(420, 12, col["green"])
	bar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	add_child(bar)
	fb_lbl = _label("", 20, col["muted"])
	fb_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	fb_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	fb_lbl.custom_minimum_size = Vector2(300, 0)
	add_child(fb_lbl)
	grid = GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	for k in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "⌫", "0", "✔"]:
		grid.add_child(_key(k))
	add_child(grid)
	extra = HBoxContainer.new()
	extra.alignment = BoxContainer.ALIGNMENT_CENTER
	extra.add_theme_constant_override("separation", 8)
	add_child(extra)

# ------------------------------------------------------------------ the flow
## The next task (unless stopped). Emits before_next first, so the game can stop instead.
func next() -> void:
	if stopped: return
	before_next.emit()
	if stopped or engine == null: return
	_pick = engine.pick_state(L)
	question = engine.question(L, rng, float(opts.get("scale", 1.0)))
	typed = ""
	busy = false
	late = false
	q_lbl.text = ("🔁 " if question.get("review", false) and not question.get("booster", false) else "") + str(question["q"]).replace(" = ?", " =")
	ans_lbl.text = "?"
	fb_lbl.text = ""
	if question.get("booster", false):
		var bc: Array = engine.C.get("comments", {}).get("booster", [])
		if not bc.is_empty(): _say(str(bc[rng.randi_range(0, bc.size() - 1)]), col["green_dark"])
	for c in extra.get_children(): c.queue_free()
	for k in question.get("keys", []):
		extra.add_child(_key(str(k)))
	bar.value = 1.0
	_bar_color(col["green"])
	_level_line(str(question.get("level", "")))
	timer.start(float(question.get("limit", 2.5)))

func key(k: String) -> void:
	if busy: return
	if k == "✔":
		enter()
		return
	if k == "⌫": typed = typed.substr(0, maxi(0, typed.length() - 1))
	elif typed.length() < 7: typed += k
	ans_lbl.text = typed if typed != "" else "?"
	if typed != "" and engine.is_right(question, typed): enter()     # right: no need to press ✔

func enter() -> void:
	if busy or typed == "": return
	busy = true
	_pick = {}
	var secs: float = timer.elapsed()
	var right: bool = engine.is_right(question, typed)
	var quick: bool = right and secs <= float(timer.limit)
	var fb: Dictionary = engine.result(L, question, right, quick, rng)
	var text := ""
	var wait := 0.7
	if right:
		text = "✅ quick!" if quick else "✅ right (a bit slow)"
	else:
		var shown := str(question["q"]).replace(" = ?", " =")
		if shown.contains("?"): shown = shown.replace("? R ?", str(question["answer"]).replace("R", " R ")).replace("?", str(question["answer"]))
		else: shown += " " + str(question["answer"]).replace("R", " R ")
		text = "❌  " + shown
		var hint := str(fb.get("hint", ""))
		if hint.contains(","):
			text += "\n💡 " + hint
			wait = 2.8
		else: wait = 1.6
	if str(fb.get("comment", "")) != "":
		text += "\n" + str(fb["comment"])
		wait = maxf(wait, 1.4)
	if fb.get("level_up", false) or not fb.get("medals", []).is_empty(): wait = maxf(wait, 2.2)
	var res := {"q": question, "typed": typed, "right": right, "quick": quick, "secs": secs, "fb": fb, "text": text, "wait": wait}
	answered.emit(res)
	_say(str(res["text"]), col["green_dark"] if right else col["red"])
	_level_line(str(question.get("level", "")))
	if not stopped: get_tree().create_timer(float(res["wait"])).timeout.connect(next)

## The child leaves while a task is on screen: it was never answered, so it leaves no trace in the record (no wrong,
## no slow, no change to when it comes back; the turn counters go back to before it was picked). Also called when the
## pad leaves the screen.
func abandon() -> void:
	if not _pick.is_empty() and engine != null: engine.restore_pick_state(L, _pick)
	_pick = {}

func _exit_tree() -> void:
	abandon()

## Ends the round with a message (the pad and timer go away).
func stop(msg: String) -> void:
	stopped = true
	busy = true
	if q_lbl == null: return
	q_lbl.text = "⚡"
	ans_lbl.text = "😊"
	_say(msg, col["green_dark"])
	grid.visible = false
	extra.visible = false
	bar.visible = false

func _process(_d: float) -> void:
	if busy or bar == null: return
	bar.value = timer.left_share()
	if bar.value <= 0.0 and not late:
		late = true
		_bar_color(col["amber"])

func _unhandled_input(ev: InputEvent) -> void:
	if busy or not is_visible_in_tree(): return
	if ev is InputEventKey and ev.pressed and not ev.echo:
		var kc: int = ev.keycode
		if kc >= KEY_0 and kc <= KEY_9: key(str(kc - KEY_0))
		elif kc >= KEY_KP_0 and kc <= KEY_KP_9: key(str(kc - KEY_KP_0))
		elif kc == KEY_BACKSPACE: key("⌫")
		elif kc == KEY_ENTER or kc == KEY_KP_ENTER: key("✔")
		elif kc == KEY_PERIOD or kc == KEY_COMMA or kc == KEY_KP_PERIOD: key(".")
		elif kc == KEY_MINUS or kc == KEY_KP_SUBTRACT: key("-")
		elif kc == KEY_R: key("R")
		else: return
		get_viewport().set_input_as_handled()

# ------------------------------------------------------------------ the level line: "🐸 Plus & minus · By heart 10/13 · Jump over ten (+)"
func _level_line(id: String) -> void:
	var li: Dictionary = engine.level_info(L, id)
	if li.is_empty(): return
	lvl_lbl.text = "%s %s %d/%d · %s %s" % [li["section_emoji"], li["section"], int(li["pos"]), int(li["count"]), li["emoji"], li["name"]]
	lvl_bar.value = 1.0 if li["bronze"] else float(li["got"]) / maxf(1.0, float(li["need"]))
	medal_lbl.text = ("🥉" if li["bronze"] else "") + ("🥈" if li["silver"] else "") + ("🥇" if li["gold"] else "")
	var st := int(li["streak"])
	streak_lbl.text = ("🔥 %d" % st) if opts.get("streak", false) and st >= 2 else ""
	streak_lbl.add_theme_font_size_override("font_size", 20 if st < 10 else 26)

func _say(t: String, c: Color) -> void:
	fb_lbl.text = t
	fb_lbl.add_theme_color_override("font_color", c)

# ------------------------------------------------------------------ small builders (no theme needed)
func _label(t: String, size: int, c: Color) -> Label:
	var l := Label.new()
	l.text = t
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", c)
	return l

func _box(bg: Color, radius: int, border: Color, bw: int, pad: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.set_corner_radius_all(radius)
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_content_margin_all(pad)
	return s

func _bar(w: int, h: int, c: Color) -> ProgressBar:
	var b := ProgressBar.new()
	b.min_value = 0.0
	b.max_value = 1.0
	b.show_percentage = false
	b.custom_minimum_size = Vector2(w, h)
	b.add_theme_stylebox_override("background", _box(Color(0, 0, 0, 0.08), 5, Color(0, 0, 0, 0), 0, 0))
	b.add_theme_stylebox_override("fill", _box(c, 5, Color(0, 0, 0, 0), 0, 0))
	return b

func _bar_color(c: Color) -> void:
	bar.add_theme_stylebox_override("fill", _box(c, 5, Color(0, 0, 0, 0), 0, 0))

func _key(k: String) -> Button:
	var c: Color = col["green"] if k == "✔" else (col["back"] if k == "⌫" else col["key"])
	var b := Button.new()
	b.text = k
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(96, 70)
	b.add_theme_font_size_override("font_size", 30)
	b.add_theme_color_override("font_color", Color.WHITE)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_pressed_color", Color.WHITE)
	b.add_theme_stylebox_override("normal", _box(c, 12, Color(0, 0, 0, 0), 0, 6))
	b.add_theme_stylebox_override("hover", _box(c.lightened(0.08), 12, Color(0, 0, 0, 0), 0, 6))
	b.add_theme_stylebox_override("pressed", _box(c.darkened(0.12), 12, Color(0, 0, 0, 0), 0, 6))
	b.pressed.connect(key.bind(k))
	return b
