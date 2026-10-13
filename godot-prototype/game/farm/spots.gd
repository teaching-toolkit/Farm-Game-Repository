extends RefCounted
## Which place on the farm map every node of the data belongs to, and what is known about each place.
## Everything the farm knows about its places is data (data/farm/places.json: names, buildings with an inside, picture chains,
## ruins, pens, the workbench, and the rules that put a data node at a place); this script only reads it.
## Where the places stand comes from data/map_layout.json; the keys in both are the places' ids.
## Some places have an inside (house, barn, workshop): once the building stands, tapping it opens a window with
## its corners (bed, books, kitchen …), and every corner is a place of its own (a "member") with its own sheet.

const PATH := "res://data/farm/places.json"

static var _d := {}
static var _by_spot := {}
static var _of := {}

static func _data() -> Dictionary:
	if _d.is_empty():
		var parsed = JSON.parse_string(FileAccess.get_file_as_string(PATH))
		if typeof(parsed) != TYPE_DICTIONARY:
			push_error("%s could not be read" % PATH)
			return {}
		_d = parsed
	return _d

# ------------------------------------------------------------------ what a place is called, and how it is built

## The English name of a place or corner (shown with tr()); the id with a capital letter when it has none.
static func name_of(sid: String) -> String:
	return str(_data().get("spots", {}).get(sid, {}).get("name", sid.capitalize()))

## The emoji that stands in for a place's picture.
static func emoji_of(sid: String) -> String:
	return str(_data().get("spots", {}).get(sid, {}).get("emoji", "❔"))

## Buildings with an inside: building id -> {"built": the node that makes it stand, "art": picture in assets/interiors/, "members": its corners}.
## Once "built" (or an upgrade of it) is done, the map shows the building and a tap opens the inside; before that the members
## stand outside on their own (house) or the place opens one sheet for all (barn, workshop).
static func interiors() -> Dictionary:
	return _data().get("interiors", {})

static func has_interior(sid: String) -> bool:
	return interiors().has(sid)

static func interior(parent: String) -> Dictionary:
	return interiors().get(parent, {})

## The upgrade chain of a place, first to last: its picture follows the newest one built (tent → cottage → …).
static func art_chain(sid: String) -> Array:
	return _data().get("artChains", {}).get(sid, [])

## Pictures of the corners inside (assets/interior/<id>.png, then assets/map/<id>.png): the newest one built is shown.
static func corner_art(sid: String) -> Array:
	return _data().get("cornerArt", {}).get(sid, [])

## Places that are always open, even before anything is built there (the wild pond is where the bucket gets water).
static func is_always_open(sid: String) -> bool:
	return _data().get("alwaysOpen", []).has(sid)

## What is left of a building before it stands again (remnants of walls on its footprint): "stone" or "wood"; `none` if the place has no ruins.
static func ruin_material(sid: String, none := "") -> String:
	return str(_data().get("ruins", {}).get(sid, none))

## Pens and gardens: no picture of their own, a generic fence round the footprint and a ground, with what is built
## standing inside (add-ons): {"fence": picture in assets/fences/ ("" = none), "ground": earth | grass | meadow, "dirt": how much bare earth shows}.
static func has_pen(sid: String) -> bool:
	return _data().get("pens", {}).has(sid)

static func pen(sid: String) -> Dictionary:
	return _data().get("pens", {}).get(sid, {})

## The workbench shows what has been made: a picture in assets/tools/ appears on the bench once its node is done
## (or, for an item, once there is one in the store). x, y = where on the bench picture (fractions), w = width (fraction).
## Inside the workshop the same tools hang in a row on the wall once the tool rack is built.
static func bench() -> Array:
	return _data().get("bench", [])

# ------------------------------------------------------------------ which place a data node belongs to

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
	var all_interiors := interiors()
	for parent in all_interiors:
		var all := []
		for m in all_interiors[parent]["members"]: all.append_array(_by_spot.get(m, []))
		_by_spot[parent] = all

## The building a corner belongs to ("library" → "home"), or "" for a place of its own.
static func parent_of(sid: String) -> String:
	var all_interiors := interiors()
	for parent in all_interiors:
		if sid in all_interiors[parent]["members"]: return parent
	return ""

## Does node id belong to place sid (directly, or to one of its corners)?
static func in_spot(G, id: String, sid: String) -> bool:
	var s := spot_of(G, id)
	return s == sid or parent_of(s) == sid

## The rules in data/farm/places.json "nodeSpots", in this order: the ruins of a place are cleared at that place; a node
## attached to another goes where that one goes; then the slot's prefix ("gear:", "tool:"); then the slot itself.
static func _rule(G, id: String, depth: int) -> String:
	var r: Dictionary = _data().get("nodeSpots", {})
	var fallback := str(r.get("default", "field"))
	var n: Dictionary = G.nodes[id]
	var ruins := str(r.get("ruinsPrefix", ""))
	if ruins != "" and id.begins_with(ruins):
		var p := id.substr(ruins.length())
		return str(r.get("ruinsAt", {}).get(p, p))
	if n.has("attach") and depth < 3 and G.nodes.has(n["attach"]): return _rule(G, n["attach"], depth + 1)
	var s := str(n.get("slot", ""))
	var prefixes: Dictionary = r.get("slotPrefixes", {})
	for pre in prefixes:
		if s.begins_with(pre): return str(prefixes[pre])
	var e = r.get("slots", {}).get(s)
	if e == null: return fallback
	if typeof(e) == TYPE_STRING: return e
	var ids: Dictionary = e.get("ids", {})
	for spot in ids:
		if id in ids[spot]: return str(spot)
	var id_prefixes: Dictionary = e.get("prefixes", {})
	for pre in id_prefixes:
		if id.begins_with(pre): return str(id_prefixes[pre])
	return str(e.get("default", fallback))
