extends RefCounted
class_name FarmUiPlaceSheet
## What a place's sheet shows: the header, what can be built or done there, and which kind of place sheet to use.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ what a place shows

## A locked place with nothing within reach: only a weathered sign and a promise.
func part_mystery() -> void:
	M.content.add_child(UI.header(Art.first("deco", ["mystery_sign", "signpost"]), "🪧", 130))
	var l := UI.label(tr("Something stood here once…\nYou will find out what belongs here later — when you have what it needs."), 19, UI.MUTED, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	M.content.add_child(l)

## The picture at the top of a place's sheet: what stands there now (or the first thing built in a pen).
func spot_header(sid: String) -> Control:
	if sid == "road": return UI.header(Art.first("map", M.mapview.art_keys("road")), "🛤️", 90)
	var ms := M.mapview.map_sid(sid)
	var tex: Texture2D = null
	if M.map.slots.has(ms) and M.map.slots[ms].visible and M.map.slots[ms].pic.texture: tex = M.map.slots[ms].pic.texture
	if Spots.parent_of(sid) != "" and M.mapview.built(Spots.parent_of(sid)):
		var keys: Array = Spots.corner_art(sid).filter(func(id): return G.nodes.has(id) and G.done(id))
		keys.reverse()
		var kk := M.mapview.first_key("interior", keys)
		tex = Art.tex("interior", kk) if kk != "" else null
	if tex == null and Spots.has_pen(sid):
		for a in M.map.addon_nodes:
			if a["sid"] == sid and a["node"].visible: tex = a["node"].texture
	return UI.header(tex, M.mapview.spot_emoji(sid), 100)

func sheet_spot(sid: String) -> void:
	if sid == "field" and M.patch_note >= 0: M.patches.part_patch_note(M.patch_note)
	var head := M.mapview.headline(sid)
	if head != "" and str(G.nodes[head].get("desc", "")) != "" and not (sid in ["market", "board"]):
		M.content.add_child(UI.label(str(G.nodes[head]["desc"]), 16, UI.MUTED, true))
	elif not M.mapview.is_open(sid):
		M.content.add_child(UI.label(tr("Build it to open this place."), 17, UI.MUTED, true))
	if sid == "field":      # no sign on the map any more: this sheet only opens for an overgrown patch (or from a goal)
		part_field_below()
		return
	var lists := goal_lists(sid)
	if sid != "market": _part_main_goals(sid, lists[0])   # what to do here comes first (the market: selling first, orders at the bottom)
	match sid:
		"living": M.home.part_home()
		"library": M.market.part_library()
		"storage": M.pantry.part_pantry()
		"market": M.market.part_market()
		"bookcart": M.market.part_bookcart()
		"board": M.home.part_jobs()
		"orchard": M.patches.part_area("orchard")
		"greenhouse": M.patches.part_area("gh")
		"pets": M.home.part_pets()
		"kitchen", "forest": M.stations.part_woodpile()
		"pond", "well": M.waterroad.part_water(sid)
		"road": M.waterroad.part_road()
	_part_things_here(sid)
	_part_more_goals(sid, lists[0], lists[1], lists[2])
	M.stations.part_polish_here(sid)
	if sid == "market": _part_main_goals(sid, lists[0])

## The animals and the machines (stations) that stand at a place, as cards.
func _part_things_here(sid: String) -> void:
	for aid in Spots.nodes_at(G, sid):
		if G.nodes[aid]["type"] != "animal": continue
		if not G.progression.missing_reqs(aid).is_empty() and not G.done(aid): continue
		M.content.add_child(M.animalsheet.animal_card(aid))
	for root in G.crafting.stations():
		if Spots.in_spot(G, root, sid): M.content.add_child(M.stations.station_card(root))

## What the field window shows below the patch (or by itself for an overgrown patch): the whole-field jobs, what to do on the
## fields (clearing, new land), the field's upgrades, then the pests line.
func part_field_below() -> void:
	M.patches.part_whole_field()
	var lists := goal_lists("field")
	_part_main_goals("field", lists[0])
	_part_things_here("field")
	_part_more_goals("field", lists[0], lists[1], lists[2])
	M.stations.part_polish_here("field")
	M.patches.part_pests()

## [main goals open now, optional upgrades open now, [id, missing] one step away] at a place.
func goal_lists(sid: String) -> Array:
	var main := []
	var opt := []
	var soon := []
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not (n["type"] in G.goal_types): continue
		if G.done(id) or G.satisfied(id) or not M.mapview.in_chapter(id): continue
		var mr: Array = G.progression.missing_reqs(id)
		if mr.is_empty():
			if n.get("optional", false): opt.append(id)
			else: main.append(id)
		elif mr.size() == 1 and not n.get("optional", false):
			soon.append([id, mr[0]])
	var key := func(a): return int(G.nodes[a].get("chapter", 1)) * 10 + (0 if G.progression.can_unlock(a)["ok"] else 1)
	main.sort_custom(func(a, b): return key.call(a) < key.call(b))
	opt.sort_custom(func(a, b): return key.call(a) < key.call(b))
	return [main, opt, soon]

func _part_main_goals(sid: String, main: Array) -> void:
	if sid == "market": main = main.filter(func(id): return G.nodes[id]["type"] != "delivery")      # orders are handed over on the village square (part_market)
	if main.is_empty(): return
	M.widgets.section(tr("🤝 Favours for neighbours") if sid == "board" else (tr("📦 Orders to deliver") if sid == "market" else tr("🔨 To do here")),
		tr("Help someone: the reward is a picture for your album, and a bit of luck.") if sid == "board" else "")
	M.content.add_child(M.widgets.node_grid(main))

func _part_more_goals(sid: String, main: Array, opt: Array, soon: Array) -> void:
	if not opt.is_empty():
		M.widgets.section(tr("🧰 Upgrades (optional)"), tr("Never required — they make work cheaper for good."))
		M.content.add_child(M.widgets.node_grid(opt))
	# what comes later is not shown here: only what can be done now (the quest book has this chapter's next steps)
