extends RefCounted
## Core · random numbers: the one source for every random thing in the rules, so that a seed (--seed=N) gives the
## same game every time. The screen's own decoration (sparkles, where a bird lands) may use Godot's own.
##   var R = preload("res://kits/core/rng.gd").new()
##   R.seed_with(1)   or   R.randomize()
##   R.chance(0.3)  R.pick(array)  R.shuffle(array)  R.gen (the RandomNumberGenerator, for kits that take one)

var gen := RandomNumberGenerator.new()

func seed_with(n: int) -> void:
	gen.seed = n

func randomize() -> void:
	gen.randomize()

func chance(p: float) -> bool:
	return gen.randf() < p

func pick(a: Array):
	return a[gen.randi_range(0, a.size() - 1)] if not a.is_empty() else null

## Shuffles in place (Fisher–Yates with gen).
func shuffle(a: Array) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := gen.randi_range(0, i)
		var t = a[i]; a[i] = a[j]; a[j] = t
