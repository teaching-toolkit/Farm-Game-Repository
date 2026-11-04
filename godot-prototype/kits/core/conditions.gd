extends RefCounted
## One small language for "when" in data (story pieces, interface elements that appear, golden acorns, perks, the pets' WHEN cards).
## A condition is one short line:
##   <word> >= <n>        a number word reaches n             coins>=100, forest_trips>=3
##   <word> < <n>         a number word is below n            water<8
##   <word>               a yes-or-no word holds              start, rain
##   <word>:<arg> …       a word may take one argument        item:carrot>=3, season:winter, done:barn, seen:album, after:c6_bend:2
##   not:<condition>      turns a condition round             not:done:barn
## A list of conditions holds when all of them hold (an empty list holds: "no condition").
## The words are not known here: whoever owns what a word reads registers it (register), with what kind of number or yes-or-no it gives,
## the kind of argument it takes, a note and an example; vocabulary() lists them (the data checker reads that list).
## A condition that uses a word nobody registered, a number word without a comparison or a yes-or-no word with one, or a word with a
## missing or extra argument, is false as a whole, also behind not: (a mistake in the form never shows something at once; a typo in an
## argument, such as a goal that does not exist, only the data checker can catch).
## Knows nothing about any game.

const UNKNOWN := -1

var _words := {}      # word -> {"read": Callable(arg: String) -> float or bool, "kind": "number"/"yes", "arg", "note", "example"}

## Registers a word. read(arg) gives a number (kind "number") or true/false (kind "yes"). arg: the kind of argument it takes ("" for
## none; else a kind the data checker knows: item, node, card, season, seen, place, chance, after).
func register(word: String, read: Callable, kind: String, arg: String, note: String, example: String) -> void:
	assert(not _words.has(word), "condition word registered twice: " + word)
	assert(kind == "number" or kind == "yes", "kind is number or yes: " + word)
	_words[word] = {"read": read, "kind": kind, "arg": arg, "note": note, "example": example}

## Every word with its kind, argument, note and example (no readers): {word: {"kind", "arg", "note", "example"}}.
func vocabulary() -> Dictionary:
	var out := {}
	var ks := _words.keys()
	ks.sort()
	for w in ks:
		var d: Dictionary = _words[w]
		out[w] = {"kind": d["kind"], "arg": d["arg"], "note": d["note"], "example": d["example"]}
	return out

func knows(word: String) -> bool:
	return _words.has(word)

## Does this condition hold now? (false for one that uses an unknown word, also behind not:)
func holds(expr: String) -> bool:
	return _eval(expr.strip_edges()) == 1

## All of a list of conditions hold.
func holds_all(list: Array) -> bool:
	for e in list:
		if not holds(str(e)): return false
	return true

## Is this condition well formed with known words (whether or not it holds now)?
func valid(expr: String) -> bool:
	return _eval(expr.strip_edges()) != UNKNOWN

## The value of a number word now (NAN for a word that is not a number word): value("coins"), value("item:carrot").
func value(word_arg: String) -> float:
	var p := _split(word_arg)
	var d: Dictionary = _words.get(p[0], {})
	if d.is_empty() or d["kind"] != "number": return NAN
	if (str(d["arg"]) != "") != word_arg.contains(":"): return NAN
	return float(d["read"].call(p[1]))

# 1 holds, 0 does not, UNKNOWN: not a condition of known words
func _eval(expr: String) -> int:
	if expr.begins_with("not:"):
		var r := _eval(expr.substr(4))
		return UNKNOWN if r == UNKNOWN else 1 - r
	var op := ""
	var at := expr.find(">=")
	if at >= 0: op = ">="
	else:
		at = expr.find("<")
		if at >= 0: op = "<"
	var left := expr if op == "" else expr.substr(0, at)
	var p := _split(left)
	var d: Dictionary = _words.get(p[0], {})
	if d.is_empty() or p[0] == "": return UNKNOWN
	if (str(d["arg"]) != "") != left.contains(":") or (str(d["arg"]) != "" and p[1] == ""): return UNKNOWN      # an argument exactly when the word takes one
	if op == "":
		if d["kind"] != "yes": return UNKNOWN
		return 1 if bool(d["read"].call(p[1])) else 0
	if d["kind"] != "number": return UNKNOWN
	var rhs := expr.substr(at + op.length()).strip_edges()
	if not rhs.is_valid_float(): return UNKNOWN
	var v := float(d["read"].call(p[1]))
	if is_nan(v): return UNKNOWN
	if op == ">=": return 1 if v >= float(rhs) else 0
	return 1 if v < float(rhs) else 0

# "item:carrot" -> ["item", "carrot"]; "coins" -> ["coins", ""]
func _split(s: String) -> Array:
	var i := s.find(":")
	return [s.strip_edges(), ""] if i < 0 else [s.substr(0, i).strip_edges(), s.substr(i + 1).strip_edges()]
