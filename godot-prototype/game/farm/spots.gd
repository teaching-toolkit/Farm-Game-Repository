extends RefCounted
## Which place on the farm map every node of the data belongs to, and what each place looks like.
## All of it is data: data/farm/places.json (names, insides, picture chains, ruins, pens, the bench, the slot rules;
## its "note" explains every part). Where the places stand comes from data/map_layout.json; the keys are their ids.
## Some places have an inside (house, barn, workshop): once the building stands, tapping it opens a window with
## its corners (bed, books, kitchen …), and every corner is a place of its own (a "member") with its own sheet.

const PLACES_PATH := "res://data/farm/places.json"
static var P: Dictionary = _read()
static var SPOTS: Dictionary = P.get("names", {})            # id -> [name, emoji] (shown with tr())
static var INTERIORS: Dictionary = P.get("interiors", {})
static var HOTSPOT_ART: Dictionary = P.get("insideArt", {})
static var ART_CHAINS: Dictionary = P.get("artChains", {})
static var PLOT_CHAINS: Dictionary = P.get("plotChains", {})
static var ALWAYS_OPEN: Array = P.get("alwaysOpen", [])
static var RUINS: Dictionary = P.get("ruins", {})
static var BENCH: Array = P.get("bench", [])
static var PENS: Dictionary = P.get("pens", {})

static func _read() -> Dictionary:
	var d = JSON.parse_string(FileAccess.get_file_as_string(PLACES_PATH))
	if typeof(d) != TYPE_DICTIONARY:
		push_error("data/farm/places.json missing or broken")
		return {}
	return d

static var _by_spot := {}
static var _of := {}

static func spot_of(G, id: String) -> String:
	if _of.is_empty(): _build(G)
	return _of.get(id, "field")

static func nodes_at(G, spot: String) -> Array:
	if _of.is_empty(): _build(G)
	return _by_spot.get(spot, [])

static func _build(G) -> void:
	_of.clear(); _by_spot.clear()
	for id in G.nodes:
		var s := _rule(G, id, 0)
		_of[id] = s
		if not _by_spot.has(s): _by_spot[s] = []
		_by_spot[s].append(id)
	# a building with an inside holds everything of its corners
	for parent in INTERIORS:
		var all := []
		for m in INTERIORS[parent]["members"]: all.append_array(_by_spot.get(m, []))
		_by_spot[parent] = all

## The building a corner belongs to ("library" → "home"), or "" for a place of its own.
static func parent_of(sid: String) -> String:
	for parent in INTERIORS:
		if sid in INTERIORS[parent]["members"]: return parent
	return ""

## Does node id belong to place sid (directly, or to one of its corners)?
static func in_spot(G, id: String, sid: String) -> bool:
	var s := spot_of(G, id)
	return s == sid or parent_of(s) == sid

static func _rule(G, id: String, depth: int) -> String:
	var n: Dictionary = G.nodes[id]
	if id.begins_with("ruins_"):      # clearing the ruins of a place happens at that place
		var p := id.substr(6)
		return str(P.get("ruinsAt", {}).get(p, p))
	if n.has("attach") and depth < 3 and G.nodes.has(n["attach"]): return _rule(G, n["attach"], depth + 1)
	var s := str(n.get("slot", ""))
	var pre: Dictionary = P.get("slotPrefixes", {})
	for k in pre:
		if s.begins_with(k): return str(pre[k])
	var dflt := str(P.get("defaultPlace", "field"))
	var r = P.get("slots", {}).get(s, null)
	if r == null: return dflt
	if typeof(r) == TYPE_STRING: return r
	if r.get("byId", {}).has(id): return str(r["byId"][id])
	var bp: Dictionary = r.get("byPrefix", {})
	for k in bp:
		if id.begins_with(k): return str(bp[k])
	return str(r.get("default", dflt))
