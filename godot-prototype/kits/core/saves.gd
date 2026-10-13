extends RefCounted
## Save files with a version number. A save is one dictionary (JSON on disk) with a "version" key; a save without one is
## version 0 (everything saved before the version number existed). A game lists its upgrade steps, each taking a save from the
## version before it to its own; loading runs the steps the save has not had yet, in order, so an old save keeps loading as the
## game's save layout changes. Knows nothing about any game.
##
##   steps = [{"to": 1, "name": "what it does", "fn": Callable}, …]     fn takes the save dictionary and changes it in place
##   Saves.upgrade(state, steps, CURRENT_VERSION)
##   Saves.fill(state, defaults)         keys that a newer game added get their default (copied), existing keys are never touched
## A save from a NEWER game (its version is above the current one) is left as it is: it is loaded, but never "upgraded" down.

## Reads a save file: the dictionary, or {} if the file is missing or not a save.
static func read(path: String) -> Dictionary:
	if not FileAccess.file_exists(path): return {}
	var d = JSON.parse_string(FileAccess.get_file_as_string(path))
	return d if typeof(d) == TYPE_DICTIONARY else {}

static func write(path: String, state: Dictionary) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null: return false
	f.store_string(JSON.stringify(state))
	return true

## The save's version (0 if it has none).
static func version_of(state: Dictionary) -> int:
	return int(state.get("version", 0))

## Runs the steps the save has not had yet; returns their names. Afterwards the save's version is the current one
## (unless the save came from a newer game, then it is left alone).
static func upgrade(state: Dictionary, steps: Array, current: int) -> Array:
	var ran := []
	var v := version_of(state)
	if v > current: return ran
	var sorted := steps.duplicate()
	sorted.sort_custom(func(a, b): return int(a["to"]) < int(b["to"]))
	for s in sorted:
		if int(s["to"]) <= v or int(s["to"]) > current: continue
		s["fn"].call(state)
		state["version"] = int(s["to"])
		ran.append(str(s["name"]))
	state["version"] = current
	return ran

## Adds the keys of `defaults` that the save does not have yet (deep copies); returns how many.
static func fill(state: Dictionary, defaults: Dictionary) -> int:
	var n := 0
	for k in defaults:
		if not state.has(k):
			var v = defaults[k]
			state[k] = v.duplicate(true) if typeof(v) in [TYPE_DICTIONARY, TYPE_ARRAY] else v
			n += 1
	return n
