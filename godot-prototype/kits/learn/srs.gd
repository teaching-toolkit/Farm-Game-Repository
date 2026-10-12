## LearnKit · spaced repetition counted in answers (no clock needed): like Anki's learning steps or Leitner boxes.
## An item is a Dictionary {"box", "due", "right", "wrong", "slow"}; n is how many answers the learner has given so far.
##   wrong → box 0, back after cfg.wrongAfter answers
##   slow  → box 0, back after cfg.slowAfter answers (right, but not yet quick)
##   right → box + 1, back after cfg.gaps[box - 1] answers (3, 8, 20, 50, 120, 300 …)
## Used by math_engine.gd (sums) and quiz_engine.gd (question packs); usable on its own.
extends RefCounted

const DEFAULT := {"gaps": [3, 8, 20, 50, 120, 300], "wrongAfter": 2, "slowAfter": 3, "knownBox": 4}

static func new_item() -> Dictionary:
	return {"box": 0, "due": 0, "right": 0, "wrong": 0, "slow": 0}

## Schedules the item after an answer ("wrong", "slow" or "right"). Returns true when the item has just become known.
static func schedule(it: Dictionary, outcome: String, n: int, cfg: Dictionary = DEFAULT) -> bool:
	var gaps: Array = cfg.get("gaps", DEFAULT["gaps"])
	match outcome:
		"wrong":
			it["wrong"] = int(it.get("wrong", 0)) + 1
			it["box"] = 0
			it["due"] = n + int(cfg.get("wrongAfter", 2))
		"slow":
			it["slow"] = int(it.get("slow", 0)) + 1
			it["box"] = 0
			it["due"] = n + int(cfg.get("slowAfter", 3))
		_:
			it["right"] = int(it.get("right", 0)) + 1
			var box := mini(int(it.get("box", 0)) + 1, gaps.size())
			it["box"] = box
			it["due"] = n + int(gaps[box - 1])
			if box >= int(cfg.get("knownBox", 4)) and not it.get("known", false):
				it["known"] = true
				return true
	return false

## The key whose turn is overdue the longest (or ""). avoid: keys not to ask now (just asked).
static func most_overdue(items: Dictionary, n: int, avoid: Array = []) -> String:
	var best := ""
	var at := 1 << 30
	for k in items:
		var d := int(items[k].get("due", 1 << 30))
		if d <= n and d < at and not avoid.has(k):
			best = k
			at = d
	return best

## The key whose turn comes soonest, even if it is not due yet (or "").
static func soonest(items: Dictionary, avoid: Array = []) -> String:
	var best := ""
	var at := 1 << 30
	for k in items:
		if avoid.has(k): continue
		var d := int(items[k].get("due", 1 << 30))
		if d < at:
			best = k
			at = d
	return best
