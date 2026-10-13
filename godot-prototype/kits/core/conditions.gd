extends RefCounted
## Core · conditions: one small language for "when" in the data (golden acorns, perks; later story pieces, little
## jobs, hidden finds, the unlock schedule). A condition is a text:
##   kind:argument            e.g. "unlocked:library_shelf", "done:pet_bunny", "season:winter"
##   counter>=N               e.g. "harvests>=40", "cards>=10" (also >, <=, <, ==)
##   name                     a named condition, e.g. "luck" (found by a lucky roll elsewhere, never by a check)
##   a & b                    all of them (spaces around & are fine)
## The game says what each kind and counter means:
##   var C = preload("res://kits/core/conditions.gd").new()
##   C.kind("unlocked", func(arg): return done(arg))
##   C.counter("harvests", func(): return float(stats["harvests"]))
##   C.check("harvests>=40 & unlocked:barn_1")
## Unknown kinds or counters are false (and listed by unknown(), for a data checker).

var _kinds := {}       # kind -> Callable(arg: String) -> bool
var _counters := {}    # counter -> Callable() -> float
var _named := {}       # name -> Callable() -> bool
const OPS := [">=", "<=", "==", ">", "<"]

func kind(name: String, f: Callable) -> void:
	_kinds[name] = f

func counter(name: String, f: Callable) -> void:
	_counters[name] = f

func named(name: String, f: Callable) -> void:
	_named[name] = f

func check(w: String) -> bool:
	for part in w.split("&"):
		if not _one(part.strip_edges()): return false
	return true

func _one(w: String) -> bool:
	if w == "": return false
	for op in OPS:
		var i := w.find(op)
		if i < 0: continue
		var name := w.substr(0, i).strip_edges()
		if not _counters.has(name): return false
		var have := float(_counters[name].call())
		var n := float(w.substr(i + op.length()).strip_edges())
		match op:
			">=": return have >= n
			"<=": return have <= n
			"==": return is_equal_approx(have, n)
			">": return have > n
			"<": return have < n
	var c := w.find(":")
	if c < 0: return bool(_named[w].call()) if _named.has(w) else false
	var k := w.substr(0, c)
	if not _kinds.has(k): return false
	return bool(_kinds[k].call(w.substr(c + 1)))

## The parts of a condition this game does not know (empty = all known).
func unknown(w: String) -> Array:
	var out := []
	for part in w.split("&"):
		var p := part.strip_edges()
		var known := false
		for op in OPS:
			if p.find(op) >= 0:
				known = _counters.has(p.substr(0, p.find(op)).strip_edges())
				break
		if not known and p.find(":") >= 0 and not _has_op(p): known = _kinds.has(p.substr(0, p.find(":")))
		if not known and _named.has(p): known = true
		if not known: out.append(p)
	return out

func _has_op(p: String) -> bool:
	for op in OPS:
		if p.find(op) >= 0: return true
	return false
