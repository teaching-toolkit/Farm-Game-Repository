extends RefCounted
## Core · clock: one step of time (in this game: one right first answer in the Time Quiz). The systems register what
## they do on a step, in a fixed order, and step() calls them one after the other with a shared report (a Dictionary
## the playback and the screen read afterwards: what grew, what arrived, rain, a new season …).
##   var clock = preload("res://kits/core/clock.gd").new()
##   clock.add("crops", _step_crops)          # func _step_crops(report: Dictionary) -> void
##   var report = clock.step({"rain": false})
## order() lists the names (tests check it; ARCHITECTURE.md shows it).

var _systems: Array = []    # [[name, Callable], …]

func add(name: String, f: Callable) -> void:
	_systems.append([name, f])

func order() -> Array:
	var out := []
	for s in _systems: out.append(s[0])
	return out

func step(report: Dictionary = {}) -> Dictionary:
	for s in _systems: s[1].call(report)
	return report
