extends RefCounted
## Core · saves: a save is the game's state as JSON with a version number. Loading fills in what an older save does not
## have yet (from the defaults the systems give) and runs the upgrade steps from the save's version up to today's.
##   const Saves = preload("res://kits/core/saves.gd")
##   var text = Saves.pack(state, VERSION)
##   var d = Saves.unpack(text)                       # {} when it is no save
##   d = Saves.upgrade(d, steps, VERSION)            # steps[n] = Callable(d) -> void, turns version n into n + 1
##   Saves.fill(d, defaults)                         # keys missing at the top level get a copy of their default
## A save without "version" is version 0. A save from a newer game is loaded as it is (with a warning).

const KEY := "version"

static func pack(state: Dictionary, version: int) -> String:
	state[KEY] = version
	return JSON.stringify(state)

static func unpack(text: String) -> Dictionary:
	var d = JSON.parse_string(text) if text != "" else null
	return d if typeof(d) == TYPE_DICTIONARY else {}

static func version_of(d: Dictionary) -> int:
	return int(d.get(KEY, 0))

static func upgrade(d: Dictionary, steps: Array, version: int) -> Dictionary:
	var v := version_of(d)
	if v > version:
		push_warning("save from a newer version (%d > %d): loaded as it is" % [v, version])
		return d
	while v < version:
		if v < steps.size(): steps[v].call(d)
		v += 1
	d[KEY] = version
	return d

static func fill(d: Dictionary, defaults: Dictionary) -> void:
	for k in defaults:
		if not d.has(k): d[k] = defaults[k].duplicate(true) if defaults[k] is Dictionary or defaults[k] is Array else defaults[k]
