## The farmer as an actor: after the player did something (weeding, planting, cooking …) the game has already changed
## the numbers; the farmer walks there and acts it out (data/acts.json). A new act interrupts the one playing: the farmer
## puts everything down, gets up and goes to the new place. New acts, poses and props are data — no code needed.
##   actor.perform("weed", patch_point)     # walk to the patch, kneel, pull weeds three times, stand up
extends Node

const DATA := "res://data/acts.json"
const GET_UP := 0.25                 # seconds to get up when interrupted

var avatar                           # scripts/avatar.gd
var resolve: Callable = func(_name): return null    # a place name ("water", "spot:pond") -> farm point or null
var D := {}
var current := ""                    # the act playing now ("" = none)
var _run := 0                        # every new act gets a new number; older runs see it and stop
var _target := Vector2.ZERO

func _ready() -> void:
	var d = JSON.parse_string(FileAccess.get_file_as_string(DATA)) if FileAccess.file_exists(DATA) else null
	D = d if typeof(d) == TYPE_DICTIONARY else {}

func has_act(name: String) -> bool:
	return D.get("acts", {}).has(name)

## Act out name at target (farm coordinates). Interrupts what is playing.
func perform(name: String, target: Vector2) -> void:
	if avatar == null or not has_act(name): return
	if name == current and target.distance_to(_target) < 2.0: return     # the same thing again: keep playing it
	_target = target
	_run += 1
	var me := _run
	if current != "":
		avatar.stop_walking()
		avatar.drop_all()
		avatar.set_pose({}, GET_UP)
		await get_tree().create_timer(GET_UP).timeout
		if me != _run: return
	current = name
	avatar.acting = true
	for step in D["acts"][name]:
		if not await _step(step, target, me): return       # interrupted
	if me == _run:
		current = ""
		avatar.acting = false

## Stop acting (the player sent the farmer somewhere else): put things down and stand up.
func stop() -> void:
	if current == "": return
	_run += 1
	current = ""
	avatar.drop_all()
	avatar.set_pose({}, GET_UP)
	avatar.acting = false

func _place(where: String, target: Vector2):
	if where == "target": return target
	var p = resolve.call(where)
	return p if p is Vector2 else null

## One step; false when this run was interrupted.
func _step(st: Dictionary, target: Vector2, me: int) -> bool:
	if st.has("walk"):
		var p = _place(str(st["walk"]), target)
		if p != null:
			avatar.walk_to(p)
			var guard := 0.0
			while avatar.moving and guard < 20.0:
				await get_tree().process_frame
				guard += get_process_delta_time()
				if me != _run: return false
	elif st.has("face"):
		var f = _place(str(st["face"]), target)
		if f != null: avatar.face_point(f)
	elif st.has("pose"):
		var t := float(st.get("time", 0.3))
		avatar.set_pose(D.get("poses", {}).get(str(st["pose"]), {}), t)
		return await _wait(t, me)
	elif st.has("loop"):
		var t2 := float(st.get("time", 0.3))
		for _i in range(int(st.get("times", 1))):
			for pn in st["loop"]:
				avatar.set_pose(D.get("poses", {}).get(str(pn), {}), t2)
				if not await _wait(t2, me): return false
	elif st.has("hold"):
		avatar.hold(D.get("props", {}).get(str(st["hold"]), {}), str(st.get("hand", "r")))
	elif st.has("drop"):
		avatar.drop(str(st["drop"]))
	elif st.has("wait"):
		return await _wait(float(st["wait"]), me)
	elif st.has("sound"):
		var snd = get_node_or_null("/root/Sound")
		if snd: snd.play(str(st["sound"]))
	return me == _run

func _wait(secs: float, me: int) -> bool:
	await get_tree().create_timer(secs).timeout
	return me == _run
