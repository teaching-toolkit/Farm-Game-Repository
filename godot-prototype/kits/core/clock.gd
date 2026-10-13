extends RefCounted
## One step of time. Systems register a function under a name; run() calls them in the order they were registered
## (or inserted before/after another by name), handing each the step's report: a dictionary the systems fill with what
## changed (it is what the playback after the Time Quiz shows). A new system is a new registered step, not a new line in a long function.
## Order matters (rain before crops, crops before pests …): it is part of the game's rules, so the game registers in the order it wants.
## Knows nothing about any game.

var _steps: Array = []          # [name, Callable]

## Adds a step at the end, or right after / before the step called `after` / `before`.
func register(step_name: String, fn: Callable, after := "", before := "") -> void:
	assert(index_of(step_name) < 0, "clock: step %s is registered twice" % step_name)
	var at := _steps.size()
	if after != "":
		var i := index_of(after)
		assert(i >= 0, "clock: no step called %s" % after)
		at = i + 1
	elif before != "":
		var j := index_of(before)
		assert(j >= 0, "clock: no step called %s" % before)
		at = j
	_steps.insert(at, [step_name, fn])

func index_of(step_name: String) -> int:
	for i in range(_steps.size()):
		if _steps[i][0] == step_name: return i
	return -1

## The step names in the order they run.
func names() -> Array:
	return _steps.map(func(s): return s[0])

## Runs every step once, in order.
func run(report: Dictionary) -> void:
	for s in _steps: s[1].call(report)
