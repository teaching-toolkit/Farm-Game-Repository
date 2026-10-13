extends RefCounted
## Back on the farm after the Time Quiz (J4): while the quiz is open the fields stay as they were; when it closes, a short
## pause, then the rain (if it rained), then the plants flick through every stage they grew (with weeds, stones and the
## pests), and last the energy bar shows what changed. Any tap jumps to the end.
## M = the main screen, G = Game.
const UI = preload("res://kits/ui/ui.gd")

const PAUSE := 0.8        # seconds before anything moves
const RAIN := 1.0         # how long the rain gets
const FLICK := 0.3        # seconds per growing stage
const STAGES := ["", "sprout", "grown", "ready"]

var M
var G
var hold := false          # the quiz is open: the fields don't change on screen
var playing := false
var _skip := false
var _snap := {}            # what the farm looked like when the quiz opened

## The quiz opens: remember what the fields and the bars look like, and hold the fields still.
func begin() -> void:
	if hold: return
	hold = true
	var fields := []
	for fv in M.map.fields:
		var specs := []
		for k in range(9): specs.append(fv.patches[k].spec.duplicate())
		fields.append(specs)
		fv.hold = true
	_snap = {"energy": float(G.S["energy"]), "fields": fields}

## The quiz closed: play what happened.
func end() -> void:
	if not hold: return
	hold = false
	for fv in M.map.fields: fv.hold = false
	playing = true
	_skip = false
	await _wait(PAUSE)
	var rained := false
	for fv in M.map.fields:
		if fv.pending_rain:
			rained = true
			if not _skip: fv.play_rain()
			else: fv.pending_rain = false
	if rained: await _wait(RAIN)
	M.ui_map._play_fx()                         # pests, flying things: together with the growing
	await _flick()
	M.map.refresh_fields(G)
	_energy_change(float(G.S["energy"]) - float(_snap.get("energy", G.S["energy"])))
	playing = false

func skip() -> void:
	_skip = true

func _wait(secs: float) -> void:
	var t := 0.0
	while t < secs and not _skip:
		await M.get_tree().create_timer(0.05).timeout
		t += 0.05

## The plants flick through their stages, all patches together, FLICK seconds per stage; weeds and stones change at once.
func _flick() -> void:
	var fields: Array = _snap.get("fields", [])
	var steps := 0
	var plan := []        # [fv, k, old spec, new spec]
	for f in range(mini(fields.size(), M.map.fields.size())):
		var fv = M.map.fields[f]
		for k in range(9):
			var old: Dictionary = fields[f][k]
			var new: Dictionary = fv.spec_of(k)
			plan.append([fv, k, old, new])
			if old["crop"] == new["crop"] and new["crop"] != "":
				steps = maxi(steps, STAGES.find(str(new["stage"])) - STAGES.find(str(old["stage"])))
	for s in range(steps + 1):
		if _skip: break
		for e in plan:
			var old: Dictionary = e[2]
			var new: Dictionary = e[3]
			var show: Dictionary = new.duplicate()
			if old["crop"] == new["crop"] and new["crop"] != "":
				var a := STAGES.find(str(old["stage"]))
				var b := STAGES.find(str(new["stage"]))
				if b > a:
					show["stage"] = STAGES[mini(b, a + s)]
					show["ready"] = show["stage"] == "ready"
			e[0].patches[e[1]].show_state(show)
		if s < steps: await _wait(FLICK)

## Last: the energy bar pulses and the change floats up from it (only when it changed).
func _energy_change(d: float) -> void:
	if absf(d) < 0.5 or M.energy_bar == null: return
	var bar: Control = M.energy_bar
	bar.pivot_offset = bar.size / 2.0
	var tw = M.create_tween()
	tw.tween_property(bar, "scale", Vector2(1.08, 1.25), 0.15)
	tw.tween_property(bar, "scale", Vector2.ONE, 0.2)
	var l := UI.label(("+%d ⚡" if d > 0 else "−%d ⚡") % int(round(absf(d))), 22, UI.GREEN_DARK if d > 0 else UI.RED)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	M.add_child(l)
	l.position = bar.get_global_rect().get_center() + Vector2(-20, 6)
	var tw2 = M.create_tween()
	tw2.tween_property(l, "position:y", l.position.y + 40.0, 1.2)
	tw2.parallel().tween_property(l, "modulate:a", 0.0, 1.2).set_delay(0.4)
	tw2.tween_callback(l.queue_free)
