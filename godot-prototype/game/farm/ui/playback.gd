extends RefCounted
class_name FarmUiPlayback
## What the farm shows after the Time Quiz (J4). While the quiz is open nothing on the farm changes (the screen keeps the old state:
## `held`); when it closes, a short pause, then the changes play: rain first (if it rained), then the plants flick through every stage
## in between, the bars that changed pulse with a number floating up, pests come, and the short notes pop up last. Any tap jumps to
## the end. The rules have long moved on (G.step_time per right answer): this only decides WHEN the screen catches up.

const UI = preload("res://kits/ui/ui.gd")

const PAUSE := 0.8        # on the farm again: a fixed short pause, the same after one question or eight
const RAIN := 1.2         # about a second of rain, if it rained
const FLICK := 0.9        # plants flicking through their stages (0.3 s each) and the bars pulsing
const LAST := 0.4         # a moment before the notes

var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

var held := false         # the screen shows the old state (the Time Quiz is open, or the playback has not caught up yet)
var flicking := false     # true while main.refresh() is the playback's catch-up (plants flick instead of jump)
var playing := false
var speed := 1.0          # 0 = no waiting (tests)
var _before := {}
var _rain := false
var _after := Callable()
var _catcher: Control
var _run := 0

func _init(main: FarmMain) -> void:
	M = main
	G = main.G
	G.step_done.connect(_on_step)

func _on_step(info: Dictionary) -> void:
	if held and info.get("rain", false): _rain = true

## The Time Quiz opened: from now on the screen keeps the old state until the playback.
func begin() -> void:
	if playing: finish()
	if held: return
	held = true
	_rain = false
	_before = {"step": int(G.S["step"]), "energy": float(G.S["energy"]), "water": float(G.S["water"])}

## The pop-up closed. Plays what changed, then calls `after` (the notes, a gift, a celebration).
func play(after: Callable) -> void:
	_after = after
	if int(G.S["step"]) == int(_before.get("step", -1)):      # no question was answered: nothing to play
		held = false
		M.queue_refresh()
		_end()
		return
	playing = true
	_run += 1
	var me := _run
	Sound.music("farm", G.seasons.season())          # the quiz music ends with the quiz
	_catcher = Control.new()
	_catcher.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_catcher.mouse_filter = Control.MOUSE_FILTER_STOP
	_catcher.gui_input.connect(_tap)
	M.add_child(_catcher)
	if not await _wait(PAUSE, me): return
	if _rain:
		M.map.play_rain()
		if not await _wait(RAIN, me): return
	held = false
	flicking = true
	M.refresh()                                       # the new state: plants flick through their stages
	flicking = false
	_pulse_changes()
	if not await _wait(FLICK, me): return
	M.map.play_pending()                              # pests, the scarecrow
	if not await _wait(LAST, me): return
	playing = false
	_end()

## Any tap: jump to the end (the new state at once, no more animations).
func finish() -> void:
	if not playing and not held: return
	_run += 1
	held = false
	playing = false
	M.map.skip_playback()
	M.refresh()
	_end()

func _tap(e: InputEvent) -> void:
	if (e is InputEventMouseButton and e.pressed) or (e is InputEventScreenTouch and e.pressed): finish()

func _end() -> void:
	if _catcher != null and is_instance_valid(_catcher):
		_catcher.queue_free()
	_catcher = null
	var a := _after
	_after = Callable()
	if a.is_valid(): a.call()

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
