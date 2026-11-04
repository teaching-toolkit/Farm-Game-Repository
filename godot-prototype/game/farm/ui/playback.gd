extends RefCounted
class_name FarmUiPlayback
## What the farm shows after the Time Quiz (J4). While the quiz is open nothing on the farm changes (the screen keeps the old state:
## `held`); when it closes, a short pause, then the changes play: rain first (if it rained), the rainbow (if it stopped, with the perk),
## then the plants flick through every stage in between, the bars that changed pulse with a number floating up, the scarecrow and the
## pests play, and the short notes pop up last. The farm news (rain, rainbow, scarecrow, pests) is shown, not written: each comes with
## its animation and a short line under it, the same after every kind of question (time-question/06). After a walk (to the village,
## into or out of the forest) the news waits until the farm is seen again (`postpone`, `farm_seen`). Any tap jumps to the end; the
## lines not shown yet still come as notes, so nothing is lost. The rules have long moved on (G.step_time per right answer): this only
## decides WHEN the screen catches up.

const UI = preload("res://kits/ui/ui.gd")

# its pauses (pause, rain, flick, last) are "feel" numbers: rules/65-feel.json, group playback

var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

var held := false         # the screen shows the old state (the Time Quiz is open, or the playback has not caught up yet)
var flicking := false     # true while main.refresh() is the playback's catch-up (plants flick instead of jump)
var playing := false
var speed := 1.0          # 0 = no waiting (tests)
var waiting := false      # a walk's news waits until the farm is seen again (a sheet over the farm is closed)
var _before := {}
var _news := {}           # the farm news of the questions since the farm was last seen: rain, rainbow, scared (pests), eaten (share)
var _lines: Array = []    # the news lines of this playback not shown yet (a tap shows them all as notes)
var _pet_acts := []
var _after := Callable()
var _catcher: Control
var _run := 0

func _init(main: FarmMain) -> void:
	M = main
	G = main.G
	G.step_done.connect(_on_step)

func _on_step(info: Dictionary) -> void:
	if held: _pet_acts = info.get("pet_acts", [])      # the pets show what they did in the last question
	if not held and not waiting: return
	if info.get("rain", false): _news["rain"] = true
	if info.get("rain_stopped", false) and G.rewards.perk_on("perk_rainbow"): _news["rainbow"] = true
	_news["scared"] = int(_news.get("scared", 0)) + int(info.get("removed", 0))
	var e := float(info.get("eat_share", 0.0))
	if e > 0.0: _news["eaten"] = 1.0 - (1.0 - float(_news.get("eaten", 0.0))) * (1.0 - e)

func _has_news() -> bool:
	return _news.get("rain", false) or _news.get("rainbow", false) or int(_news.get("scared", 0)) > 0 or float(_news.get("eaten", 0.0)) >= 0.005

## The Time Quiz opened: from now on the screen keeps the old state until the playback.
func begin() -> void:
	if playing: finish()
	if held: return
	held = true
	if not waiting: _news = {}       # a walk's news that still waits is kept and shown with this question's
	_before = {"step": int(G.S["step"]), "energy": float(G.S["energy"]), "water": float(G.S["water"])}

## A right answer on a walk closes the pop-up into a place (the square, the forest): the screen catches up at once, without the
## animations, and the news waits until the farm is seen again (farm_seen).
func postpone() -> void:
	waiting = true
	held = false
	_before["step"] = int(G.S["step"])
	M.queue_refresh()

## A sheet over the farm closed: if a walk's news is waiting and nothing covers the farm any more, it plays now.
func farm_seen() -> void:
	if not waiting or held or playing or M.modal.visible or M.sheet.visible: return
	play(Callable())

## The pop-up closed (or the farm is seen again after a walk). Plays what changed, then calls `after` (the notes, a gift, a celebration).
func play(after: Callable) -> void:
	_after = after
	waiting = false
	var moved := int(G.S["step"]) != int(_before.get("step", -1))
	var news := _news
	_news = {}
	if not moved and not _news_lines(news).size() > 0:      # no question was answered and no news waits: nothing to play
		held = false
		M.queue_refresh()
		_end()
		return
	_lines = _news_lines(news)
	playing = true
	_run += 1
	var me := _run
	Sound.music("farm", G.seasons.season())          # the quiz music ends with the quiz
	_catcher = Control.new()
	_catcher.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_catcher.mouse_filter = Control.MOUSE_FILTER_STOP
	_catcher.gui_input.connect(_tap)
	M.add_child(_catcher)
	if not await _wait(G.feel("playback.pause"), me): return
	if news.get("rain", false):
		M.map.play_rain()
		_say("rain")
		if not await _wait(G.feel("playback.rain"), me): return
	if news.get("rainbow", false):
		M.map.rainbow()
		M.feedback.sfx("rainbow")
		_say("rainbow")
		if not await _wait(G.feel("playback.rain"), me): return
	held = false
	if moved:
		flicking = true
		M.refresh()                                   # the new state: plants flick through their stages
		flicking = false
		_pulse_changes()
		if not await _wait(G.feel("playback.flick"), me): return
	else:
		M.refresh()
	M.map.play_pending()                              # pests, the scarecrow
	_say("scared")
	_say("eaten")
	_play_pets()
	if not await _wait(G.feel("playback.last"), me): return
	playing = false
	_end()

## The pets walk to where they worked and show it (a weed, a drop, a log), or a 💤 / 📦 when they could not.
func _play_pets() -> void:
	var acts := _pet_acts
	_pet_acts = []
	for a in acts:
		var where = null
		if a.has("area"): where = M.feedback.patch_place(str(a["area"]), int(a["idx"]))
		elif a.has("place"):
			var pl := str(a["place"])
			if pl == "field": where = M.feedback.patch_place("field", 0)
			else: where = M.feedback.act_place(pl)
		if where != null: M.map.critters.visit(str(a["pet"]), where, str(a["emoji"]))

## Any tap: jump to the end (the new state at once, no more animations).
func finish() -> void:
	if not playing and not held: return
	_run += 1
	held = false
	playing = false
	waiting = false
	for l in _lines: M.notes.toast(str(l[1]))          # the news lines not shown yet still come, as notes
	_lines = []
	M.map.skip_playback()
	M.refresh()
	_end()

func _tap(e: InputEvent) -> void:
	if (e is InputEventMouseButton and e.pressed) or (e is InputEventScreenTouch and e.pressed): finish()

## The news as short lines, in the order they play: [[kind, text], …].
func _news_lines(news: Dictionary) -> Array:
	var out := []
	if news.get("rain", false): out.append(["rain", tr("🌧️ Rain! The fields are watered — planting costs no water until the next question.")])
	if news.get("rainbow", false): out.append(["rainbow", tr("🌈 The rain has stopped — look, a rainbow!")])
	var n := int(news.get("scared", 0))
	if n > 0: out.append(["scared", (tr(" 🧍 The scarecrow chased off %d pest.") if n == 1 else tr(" 🧍 The scarecrow chased off %d pests.")).strip_edges() % n])
	var e := float(news.get("eaten", 0.0))
	if e >= 0.005: out.append(["eaten", tr(" 🐦 Pests ate %d%% of what is growing.").strip_edges() % int(round(e * 100.0))])
	return out

## Shows the line of one kind of news (under its animation, as a note) and takes it off the list.
func _say(kind: String) -> void:
	for i in range(_lines.size()):
		if _lines[i][0] == kind:
			M.notes.toast(str(_lines[i][1]))
			_lines.remove_at(i)
			return

func _end() -> void:
	if _catcher != null and is_instance_valid(_catcher):
		_catcher.queue_free()
	_catcher = null
	var a := _after
	_after = Callable()
	if a.is_valid(): a.call()
	M.interrupts.request()          # the catch-up is over: whatever waited for it may come (also after a walk's news)

func _wait(secs: float, me: int) -> bool:
	if speed > 0.0: await M.get_tree().create_timer(secs * speed).timeout
	else: await M.get_tree().process_frame
	return me == _run

## A bar that changed pulses and shows how much (−4 or +2) floating up.
func _pulse_changes() -> void:
	_pulse(M.energy_bar, float(G.S["energy"]) - float(_before.get("energy", 0.0)))
	_pulse(M.water_bar, float(G.S["water"]) - float(_before.get("water", 0.0)))

func _pulse(bar: Control, d: float) -> void:
	if absf(d) < 0.5 or bar == null: return
	bar.pivot_offset = bar.size / 2.0
	var tw := bar.create_tween()
	tw.tween_property(bar, "scale", Vector2(1.12, 1.12), 0.18)
	tw.tween_property(bar, "scale", Vector2.ONE, 0.25)
	var l := UI.label("%+d" % int(round(d)), 26, UI.RED if d < 0.0 else UI.GREEN_DARK)
	l.add_theme_color_override("font_outline_color", Color(1, 1, 1, 0.9))
	l.add_theme_constant_override("outline_size", 6)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	M.add_child(l)
	l.global_position = bar.get_global_rect().get_center() - Vector2(12, 14)
	var tl := l.create_tween()
	tl.tween_property(l, "position:y", l.position.y + 60.0, 1.6)
	tl.parallel().tween_property(l, "modulate:a", 0.0, 0.9).set_delay(0.7)
	tl.tween_callback(l.queue_free)
