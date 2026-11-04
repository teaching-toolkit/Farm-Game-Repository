extends Node
## The interruption queue (kits/ui/interruptions.gd) with the game's order list (rules/65-feel.json, "interruptions"): today's order
## for every pair of kinds, the real pile-ups (a chapter turn, a walk), sheets, bubbles and busy screens. Draws nothing: each
## interruption's `show` writes into a log and, for a box, opens a pretend pop-up.
## Run:  godot --headless --path . res://tests/interruption_test.tscn -- --seed=1
const Interruptions = preload("res://kits/ui/interruptions.gd")
const BOXES := ["postcard", "celebration", "discovery", "scene", "story", "news"]    # these open a pop-up when they show; a note and a bark do not
var G
var fails := 0
var checks := 0
var busy := {}
var shown: Array = []
var q

func _ready() -> void:
	G = get_node("/root/Game")
	var cfg: Dictionary = G.meta.get("interruptions", {})
	_check(not cfg.is_empty(), "the order list is in the data")
	var kinds := []
	for e in cfg.get("order", []): kinds.append(str(e["kind"]))
	_check(kinds == ["note", "postcard", "celebration", "discovery", "scene", "story", "news", "bark"], "today's order of kinds: %s" % str(kinds))
	# today's rules, written out here on purpose: a change to the order list must change this table too (story/07 will; story/13–15 added scene and news)
	var today := {"note": ["popup", "playback", "catchup"], "postcard": ["popup", "playback", "catchup"],
		"celebration": ["popup", "playback", "catchup", "postcard"], "discovery": ["popup", "rest", "playback", "postcard", "celebration"],
		"scene": ["popup", "rest", "playback", "postcard", "celebration"],
		"story": ["popup", "rest", "playback", "postcard", "celebration", "sheet"],
		"news": ["popup", "rest", "playback", "postcard", "celebration", "sheet"], "bark": ["popup", "rest", "playback", "bubble"]}
	for e in cfg.get("order", []):
		var want: Array = today.get(str(e["kind"]), [])
		var have: Array = Array(e["waitsFor"])
		want.sort(); have.sort()
		_check(want == have, "%s waits for today's screens and kinds: %s" % [e["kind"], str(have)])
	_fresh()
	_check(q.unknown_names().is_empty(), "every name the order list waits for is a kind or a watched screen: %s" % str(q.unknown_names()))
	_check(q.errors.is_empty(), "the order list loads without errors")

	# every pair of kinds: the earlier one in the list shows first, whichever came first
	for i in range(kinds.size()):
		for j in range(i + 1, kinds.size()):
			_fresh()
			q.submit(kinds[j], "b", _show.bind(kinds[j], "b"))
			q.submit(kinds[i], "a", _show.bind(kinds[i], "a"))
			_until_quiet()
			_check(shown == [kinds[i] + ":a", kinds[j] + ":b"], "%s before %s: %s" % [kinds[i], kinds[j], str(shown)])

	# all kinds at once, submitted backwards: they come in the list's order, the boxes one after the other
	_fresh()
	for k in range(kinds.size() - 1, -1, -1): q.submit(kinds[k], "x", _show.bind(kinds[k], "x"))
	var first: Array = q.pump()
	_check(first == ["x", "x"] and shown == ["note:x", "postcard:x"], "first pump: the note, then the postcard holds the screen: %s" % str(shown))
	_until_quiet()
	_check(shown == ["note:x", "postcard:x", "celebration:x", "discovery:x", "scene:x", "story:x", "news:x", "bark:x"], "then one box per closed pop-up, the bark last: %s" % str(shown))

	# a chapter turn: during the Time Quiz the pet and a building are done, a postcard comes, two story pieces get ready
	_fresh()
	busy["popup"] = true
	busy["playback"] = true
	var pieces := ["c2_frame", "c2_beat"]
	q.source("story", func():
		for p in pieces: if not shown.has("story:" + p): return {"kind": "story", "key": p, "show": _show.bind("story", p)}
		return {})
	q.submit("celebration", "pet_dog", _show.bind("celebration", "pet_dog"))
	q.submit("celebration", "barn", _show.bind("celebration", "barn"))
	q.submit("postcard", "pc_mira", _show.bind("postcard", "pc_mira"))
	q.submit("note", "medal", _show.bind("note", "medal"))
	_check(q.pump().is_empty(), "chapter turn: nothing shows while the Time Quiz is open")
	busy["popup"] = false
	_check(q.pump().is_empty(), "chapter turn: nothing while the farm still shows the old state")
	busy["playback"] = false
	busy["catchup"] = true
	_check(q.pump().is_empty(), "chapter turn: nothing while the farm catches up (no story box either: a celebration waits)")
	busy["catchup"] = false
	_until_quiet()
	_check(shown == ["note:medal", "postcard:pc_mira", "celebration:pet_dog", "celebration:barn", "story:c2_frame", "story:c2_beat"], "chapter turn: note, postcard, both celebrations in the order they came, then the story pieces: %s" % str(shown))

	# a walk: a right answer closes the pop-up into a place (a sheet); the news waits, a celebration comes over the place
	_fresh()
	busy["sheet"] = true
	q.submit("story", "c3_scene", _show.bind("story", "c3_scene"))
	q.submit("celebration", "basket", _show.bind("celebration", "basket"))
	q.pump()
	_check(shown == ["celebration:basket"], "walk: a celebration comes over the place: %s" % str(shown))
	busy["popup"] = false
	q.pump()
	_check(shown == ["celebration:basket"], "walk: a story box waits while the place is open")
	q.submit("discovery", "c3_moss", _show.bind("discovery", "c3_moss"))
	q.pump()
	_check(shown == ["celebration:basket", "discovery:c3_moss"], "walk: a Discovery comes over the place: %s" % str(shown))
	busy["popup"] = false
	busy["sheet"] = false
	q.pump()
	_check(shown.back() == "story:c3_scene", "walk: the story box comes when the place is closed")

	# story/15: a Scene opens over the village square right after the hand-over; a waiting story box still waits for the square to close
	_fresh()
	busy["sheet"] = true
	q.submit("story", "c1_moment", _show.bind("story", "c1_moment"))
	q.submit("scene", "c1_seller", _show.bind("scene", "c1_seller"))
	q.pump()
	_check(shown == ["scene:c1_seller"], "hand-over: the Scene comes over the square at once: %s" % str(shown))
	busy["popup"] = false
	q.pump()
	_check(shown == ["scene:c1_seller"], "hand-over: the other story box waits until Back home")
	busy["sheet"] = false
	q.pump()
	_check(shown.back() == "story:c1_moment", "…and comes when the square is closed")

	# a sheet lets postcards through too
	_fresh()
	busy["sheet"] = true
	q.submit("postcard", "p", _show.bind("postcard", "p"))
	q.pump()
	_check(shown == ["postcard:p"], "a postcard comes over a sheet")

	# barks: one bubble at a time, over a sheet and while the farm catches up; a waiting celebration does not hold them
	_fresh()
	busy["sheet"] = true
	busy["catchup"] = true
	q.submit("celebration", "c", _show.bind("celebration", "c"))
	q.submit("bark", "b1", _show.bind("bark", "b1"))
	q.pump()
	_check(shown == ["bark:b1"], "a bark comes over a sheet, during the catch-up, past a waiting celebration: %s" % str(shown))
	q.submit("bark", "b2", _show.bind("bark", "b2"))
	q.pump()
	_check(shown == ["bark:b1"], "a second bark waits while a bubble is on screen")
	busy["bubble"] = false
	q.pump()
	_check(shown == ["bark:b1", "bark:b2"], "it comes when the bubble is tapped away")

	# nothing shows while a screen it waits for is busy
	for e in cfg["order"]:
		for w in e["waitsFor"]:
			if not cfg["busy"].has(w): continue
			_fresh()
			busy[w] = true
			q.submit(str(e["kind"]), "k", _show.bind(str(e["kind"]), "k"))
			_check(q.pump().is_empty() and q.waiting(str(e["kind"])) == 1, "%s waits while %s is busy" % [e["kind"], w])
			busy[w] = false
			_check(q.pump() == ["k"], "%s comes when %s is no longer busy" % [e["kind"], w])
	# and comes while screens it does not wait for are busy
	for e in cfg["order"]:
		for b in cfg["busy"]:
			if b in e["waitsFor"]: continue
			_fresh()
			busy[b] = true
			q.submit(str(e["kind"]), "k", _show.bind(str(e["kind"]), "k"))
			_check(q.pump() == ["k"], "%s does not wait for %s" % [e["kind"], b])

	# the same key twice is in line once; an unknown kind is an error; peek shows without showing
	_fresh()
	busy["popup"] = true
	_check(q.submit("celebration", "barn", _show.bind("celebration", "barn")) and not q.submit("celebration", "barn", _show.bind("celebration", "barn")), "the same celebration twice is in line once")
	_check(q.waiting("celebration") == 1 and q.has("celebration", "barn"), "it is waiting")
	_check(q.peek().is_empty(), "peek: nothing may show while a pop-up is open")
	busy["popup"] = false
	_check(q.peek() == {"kind": "celebration", "key": "barn"} and shown.is_empty(), "peek names it without showing it")
	q.pump()
	_check(shown == ["celebration:barn"] and not q.has("celebration", "barn"), "shown once, then no longer in line")
	_check(not q.submit("nonsense", "x", _show.bind("nonsense", "x")) and q.errors.size() == 1, "a kind not in the order list is refused and reported")
	q.errors.clear()

	# pump(only): only these kinds show, the others stay in line and still hold back what waits for them
	_fresh()
	q.submit("celebration", "c", _show.bind("celebration", "c"))
	q.submit("story", "s", _show.bind("story", "s"))
	_check(q.pump(["story", "discovery", "bark"]).is_empty() and q.waiting("celebration") == 1, "pump(only story): a story box still waits for a waiting celebration, which stays in line")
	q.clear("celebration")
	_check(q.pump(["story"]) == ["s"], "pump(only story): the story box comes once nothing holds it back")

	# a source is asked at most once per pump, even if its candidate stays the same
	_fresh()
	q.source("loop", func(): return {"kind": "bark", "key": "same", "show": _show.bind("bark", "same")})
	busy["bubble"] = false
	var once: Array = []
	q.source("loop", func(): return {"kind": "note", "key": "same", "show": func(): once.append(1)})
	q.pump()
	_check(once.size() == 1, "a source shows at most once per pump")

	# clear drops what is in line (a new game)
	_fresh()
	busy["popup"] = true
	q.submit("celebration", "a", _show.bind("celebration", "a"))
	q.clear()
	busy["popup"] = false
	_check(q.pump().is_empty(), "clear: nothing left in line")

	print("%s: %d checks, %d failed" % ["INTERRUPTIONS OK" if fails == 0 else "INTERRUPTIONS FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

## A new queue with the game's order list; every busy screen watched and free; the log empty.
func _fresh() -> void:
	q = Interruptions.new()
	q.configure(G.meta["interruptions"]["order"])
	busy = {}
	for b in G.meta["interruptions"]["busy"]:
		busy[b] = false
		q.watch(b, func(): return busy[b])
	shown = []

func _show(kind: String, key: String) -> void:
	shown.append("%s:%s" % [kind, key])
	if kind in BOXES: busy["popup"] = true
	if kind == "bark": busy["bubble"] = true

## Pumps and closes each pop-up and bubble, until nothing more shows.
func _until_quiet() -> void:
	for _i in range(30):
		if q.pump().is_empty() and not busy["popup"] and not busy["bubble"]: return
		busy["popup"] = false
		busy["bubble"] = false

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
