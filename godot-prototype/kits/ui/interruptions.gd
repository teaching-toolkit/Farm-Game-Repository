extends RefCounted
## What takes the screen next: the interruption queue. Things that arrive on their own and want the screen (a celebration, a
## postcard, a story box, a note …) are interruptions. Each has a kind; the game's order list says, per kind, its place and what it
## waits for. A kind waits for busy screens (names the game watches: "popup", "sheet" …) and for other kinds that are waiting.
## Two ways in: `submit(kind, key, show)` puts one interruption in line (the same key twice is in line once); `source(name, next)`
## is asked for its one candidate when the queue pumps ({"kind", "key", "show"} or {}: the story and the postcards keep their own
## lists, and the queue asks them). `watch(name, busy)` tells the queue how to ask whether a screen is busy.
## `pump()` shows everything that may show now, in order, and returns the keys shown; `request()` pumps once at the end of the frame.
## Knows nothing about any game and draws nothing: each interruption carries its own `show`.
##   var q = Interruptions.new()
##   q.configure([{"kind": "postcard", "waitsFor": ["popup"]}, {"kind": "story", "waitsFor": ["popup", "postcard"]}])
##   q.watch("popup", func(): return modal.visible)
##   q.source("story", func(): return {"kind": "story", "key": id, "show": show_piece.bind(id)} if id != "" else {})
##   q.submit("postcard", "pc1", show_postcard)

var _order: Array = []          # kind names, first wins
var _waits: Dictionary = {}     # kind -> Array of busy names and kinds it waits for
var _busy: Dictionary = {}      # busy name -> Callable returning bool
var _sources: Array = []        # [name, Callable]
var _line: Array = []           # submitted: {"kind", "key", "show", "seq"}
var _seq := 0
var _requested := false
var errors: Array = []          # what went wrong (a kind not in the order list …): the tests read it

## The order list: [{"kind": "…", "waitsFor": ["…"]}, …], first wins. Each name in waitsFor is a kind or a watched busy name.
func configure(order: Array) -> void:
	_order = []
	_waits = {}
	for e in order:
		var k := str(e.get("kind", ""))
		if k == "" or _waits.has(k): _err("order list: empty or twice: '%s'" % k); continue
		_order.append(k)
		_waits[k] = Array(e.get("waitsFor", []))

func kinds() -> Array:
	return _order.duplicate()

func waits_for(kind: String) -> Array:
	return Array(_waits.get(kind, [])).duplicate()

## How to ask whether a screen is busy (`busy` returns true while it is).
func watch(busy_name: String, busy: Callable) -> void:
	_busy[busy_name] = busy

## The names in the order list that are neither a kind nor a watched screen (should be none once the game has set up).
func unknown_names() -> Array:
	var out := []
	for k in _order:
		for w in _waits[k]:
			if not _waits.has(w) and not _busy.has(w) and not out.has(w): out.append(w)
	return out

## A list kept elsewhere (the story, the postcards): `next` returns its one candidate now, {"kind", "key", "show"}, or {}.
func source(source_name: String, next: Callable) -> void:
	for s in _sources:
		if s[0] == source_name: s[1] = next; return
	_sources.append([source_name, next])

## Puts an interruption in line. False if its kind is unknown or the same key of that kind is in line already.
func submit(kind: String, key: String, show: Callable) -> bool:
	if not _waits.has(kind): _err("submit: kind '%s' is not in the order list" % kind); return false
	if has(kind, key): return false
	_seq += 1
	_line.append({"kind": kind, "key": key, "show": show, "seq": _seq})
	return true

## Is this key of this kind waiting in line (submitted, not shown yet)?
func has(kind: String, key: String) -> bool:
	for r in _line:
		if r["kind"] == kind and r["key"] == key: return true
	return false

## The keys of this kind in line, first come first.
func in_line(kind: String) -> Array:
	var out := []
	for r in _line: if r["kind"] == kind: out.append(r["key"])
	return out

## How many of this kind are waiting: in line, and the sources' candidates.
func waiting(kind: String) -> int:
	var n := 0
	for c in _candidates({}): if c["kind"] == kind: n += 1
	return n

## The busy screens the queue knows how to ask about.
func watched() -> Array:
	return _busy.keys()

func is_busy(busy_name: String) -> bool:
	return _busy.has(busy_name) and bool(_busy[busy_name].call())

## Drops everything in line (a new game), or only what is of this kind.
func clear(kind := "") -> void:
	if kind == "": _line.clear(); return
	for r in _line.duplicate(): if r["kind"] == kind: _line.erase(r)

## What would show first now, without showing it: {"kind", "key"} or {}.
func peek() -> Dictionary:
	var c := _pick(_candidates({}))
	return {} if c.is_empty() else {"kind": c["kind"], "key": c["key"]}

## Pumps once at the end of this frame (many parts ask; one pump runs).
func request() -> void:
	if _requested: return
	_requested = true
	_requested_pump.call_deferred()

func _requested_pump() -> void:
	_requested = false
	pump()

## Shows everything that may show now, in order; each source at most once per pump. Returns the keys shown, in order.
## `only`: show only these kinds (the others still count as waiting: a story box still waits for a waiting celebration).
func pump(only: Array = []) -> Array:
	var shown := []
	var asked := {}
	for _i in range(100):
		var c := _pick(_candidates(asked), only)
		if c.is_empty(): break
		if c.has("source"): asked[c["source"]] = true
		else: _line.erase(c["row"])
		shown.append(c["key"])
		c["show"].call()
	return shown

# ------------------------------------------------------------------ inside

func _candidates(asked: Dictionary) -> Array:
	var out := []
	for r in _line: out.append({"kind": r["kind"], "key": r["key"], "show": r["show"], "seq": r["seq"], "row": r})
	var n := 0
	for s in _sources:
		n += 1
		if asked.has(s[0]): continue
		var c: Dictionary = s[1].call()
		if c.is_empty(): continue
		if not _waits.has(str(c.get("kind", ""))): _err("source %s: kind '%s' is not in the order list" % [s[0], c.get("kind", "")]); continue
		out.append({"kind": str(c["kind"]), "key": str(c.get("key", "")), "show": c["show"], "seq": 1000000 + n, "source": s[0]})
	return out

## The first candidate, in the order list's order (then first come), whose kind waits for nothing busy and no other kind waiting.
func _pick(cands: Array, only: Array = []) -> Dictionary:
	cands.sort_custom(func(a, b):
		var ra := _order.find(a["kind"]); var rb := _order.find(b["kind"])
		if ra != rb: return ra < rb
		return a["seq"] < b["seq"])
	for c in cands:
		if only.is_empty() or c["kind"] in only:
			if _clear(c, cands): return c
	return {}

func _clear(c: Dictionary, cands: Array) -> bool:
	for w in _waits[c["kind"]]:
		if _waits.has(w):
			for o in cands:
				if o != c and o["kind"] == w: return false
		elif is_busy(w): return false
	return true

func _err(msg: String) -> void:
	errors.append(msg)
	push_error("interruptions: " + msg)
