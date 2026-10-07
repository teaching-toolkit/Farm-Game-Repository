extends Control
## A field seen at an angle (isometric, 2:1), like Hay Day: 3×3 diamond patches with thin gaps between them.
## The gaps hold what is built for the patches (stick edging, stone borders, log beds, irrigation channels, drip lines),
## and a fence runs round the whole field.
##
## No words on the field: every plant is shown one by one (2 seeds planted = 2 sprouts), and so is every weed, stone,
## rock and stump — they get fewer as you clear them. A patch that is not cleared yet is a diamond of wild growth with
## what is in the way on it: weeds, rocks or stumps (the next field: scrub; the last one: marsh).
## When pests eat, a bird (or rabbit, slug …) comes, eats the plant and leaves; harvested things fly to the store.
##
## Pictures (all optional — without them simple shapes or emojis are drawn):
##   assets/deco/soil_heap.png              a worked patch
##   assets/tiles/overgrown.png             the wild growth on a patch that is not cleared yet (a repeating tile)
##   assets/deco/sprout.png                 one young plant
##   assets/crops/<crop id>.png             one grown plant (else the crop's emoji)
##   assets/deco/weeds.png, stone.png, rubble.png, stump.png, bush.png, reeds.png   things on a patch
##   assets/edging/<kind>.png   one side of a patch border (stick, stone, log, channel, drip …)
##   assets/fences/<kind>.png   one side of a fence or wall (stick_fence, stick_broken, stone_wall, stone_broken …)
## A border or fence picture is ONE straight side running from lower left to upper right (rising 1 for every 2 across).
## It is used as it is for those sides and mirrored for the other two, so four copies make a diamond.

signal patch_pressed(area: String, index: int)

const UI = preload("res://scripts/ui.gd")
const Art = preload("res://scripts/art.gd")
## Fences round the fields, worst to best (the newest one built is shown).
const FENCE_IDS := ["stick_fence", "wattle_fence", "picket_fence", "stone_wall", "hedge_row"]
## Colour and thickness when there is no picture.
const FENCE_LOOK := {"stick_fence": [Color("8a6239"), 3.0], "wattle_fence": [Color("9a7444"), 5.0], "picket_fence": [Color("f4efe3"), 5.0],
	"stone_wall": [Color("9a9a92"), 8.0], "hedge_row": [Color("3f7a34"), 10.0], "stick_broken": [Color("7a5a3a"), 2.5],
	"stone_broken": [Color("8f8f86"), 6.0]}
const BORDER_LOOK := {"stick": [Color("8a6239"), 3.0], "log": [Color("7a5230"), 5.0], "stone": [Color("a3a39a"), 5.0],
	"channel": [Color("5aa7d8"), 4.0], "drip": [Color("2b2b2b"), 2.0], "stick_broken": [Color("7a5a3a"), 2.0],
	"stone_broken": [Color("8f8f86"), 4.0]}
## What is in the way on patches that are not cleared yet, in the order the land nodes open them.

var G
var area_name := "field"
var field_index := 0
var patch := 144.0           # width of one patch diamond; its height is half of that
var gap := 14.0              # the gap between two patches (measured along the width)
var pitch := 158.0           # patch + gap
var patches: Array = []      # IsoPatch, by position 0..8 in the field
var back: Control            # fence sides behind the patches
var borders: Control          # edging and irrigation in the gaps (drawn over the patch pictures' soft edges)
var front: Control            # fence sides in front of the patches
var labels: Control          # plants, weeds and stones — above every patch picture
var layer: Control           # pests, fierce looks, rain, eating
var critters: Array = []
var scare_from := Vector2.ZERO   # where the looks start, in this control's coordinates (set by the map)
var has_scarecrow := false
var pest_share := 1.0            # this field's part of the farm's pests (the map shares them out)
var fence := ""                  # the fence round this field (a FENCE_LOOK key)
var border := ""                 # edging between the patches
var water := ""                  # irrigation in the gaps
var usable: Array = []           # patch k can be used
var hop_t := 0.0
var look_t := 0.0
var kinds := ["🐦", "🐇", "🐌", "🐛", "🐭"]
const PEST_ART := {"🐦": "bird", "🐇": "rabbit", "🐌": "slug", "🐛": "caterpillar", "🐭": "vole"}   # assets/pests/<name>.png when drawn
var pending_eats: Array = []     # [{k, cells, crop}] eaten while a pop-up was open: shown when the farm is visible again
var pending_scare := 0           # pests the scarecrow chased off in the last question(s)
var scare_level := 0             # how many fierce looks the scarecrow throws at once (its level)

func setup(patch_w: float, gap_w := 14.0) -> void:
	patch = patch_w
	gap = gap_w
	pitch = patch + gap
	var w := 3.0 * patch + 2.0 * gap
	size = Vector2(w, w / 2.0)

## Centre of patch k (0..8, row-major) in this control's coordinates.
func patch_center(k: int) -> Vector2:
	var r := k / 3
	var c := k % 3
	return Vector2(size.x / 2.0 + (c - r) * pitch * 0.5, patch * 0.25 + (c + r) * pitch * 0.25)

func patch_rect(k: int) -> Rect2:
	var ctr := patch_center(k)
	return Rect2(ctr - Vector2(patch * 0.5, patch * 0.45), Vector2(patch, patch * 0.75))

func _ready() -> void:
	G = get_node("/root/Game")
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	back = _layer()
	back.draw.connect(_draw_fence.bind(back, false))
	# back to front: the patch nearest the top is drawn first
	var order := range(9)
	order.sort_custom(func(a, b): return (a / 3 + a % 3) < (b / 3 + b % 3))
	patches.resize(9)
	for k in order:
		var p := IsoPatch.new()
		p.setup(k, patch, patch_center(k), pitch)
		p.pressed_patch.connect(_on_patch)
		add_child(p)
		patches[k] = p
	borders = _layer()
	borders.draw.connect(_draw_borders)
	front = _layer()
	front.draw.connect(_draw_fence.bind(front, true))
	labels = _layer()
	for k in order:
		var p: IsoPatch = patches[k]
		var t := Control.new()
		t.mouse_filter = Control.MOUSE_FILTER_IGNORE
		t.position = p.position
		t.size = p.size
		labels.add_child(t)
		p.top = t
		t.draw.connect(p.draw_top.bind(t))
	layer = _layer()
	G.step_done.connect(_on_step)
	refresh()

func _layer() -> Control:
	var c := Control.new()
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.size = size
	add_child(c)
	return c

func show_area(a: String, f: int) -> void:
	area_name = a
	field_index = f
	for c in critters: c.queue_free()
	critters.clear()
	pending_eats.clear()
	refresh()

func _on_patch(k: int) -> void:
	patch_pressed.emit(area_name, field_index * 9 + k)

## What is in the way on locked patch i, and how much of the clearing is done (0..1) — see G.patch_wild.
func _wild_info(i: int) -> Array:
	return G.patch_wild(field_index, i)

func refresh() -> void:
	var arr: Array = G.area(area_name)
	usable.resize(9)
	for k in range(9):
		var i := field_index * 9 + k
		var spec := {"crop": "", "plants": 0, "stage": "", "ready": false, "weeds": 0, "stones": 0, "wild": "", "seed": hash([field_index, k])}
		usable[k] = i < arr.size() and G.patch_usable(area_name, i)
		if not usable[k]:
			var wi := _wild_info(i)
			spec["wild"] = wi[0]
			spec["clear"] = wi[1]
		else:
			var p = arr[i]
			spec["weeds"] = mini(12, int(floor(float(p["weeds"]) + 0.001)))
			spec["stones"] = mini(6, int(floor(float(p["stones"]) + 0.001)))
			if p["crop"] != "":
				spec["crop"] = p["crop"]
				spec["plants"] = clampi(G.shown_plants(float(p["plants"])), 1, 9)
				var frac := float(p["growth"]) / maxf(0.01, G.grow_target(p))
				spec["stage"] = "ready" if p["ready"] else ("sprout" if frac < 0.5 else "grown")
				spec["ready"] = p["ready"]
		patches[k].show_state(spec)
	# what stands round the field and in the gaps
	var fence_on := ""
	for id in FENCE_IDS:
		if G.nodes.has(id) and G.satisfied(id): fence_on = id
	var field_open: bool = usable.has(true)
	if not field_open: fence = "stone_broken"              # an old field nobody has worked for years
	elif fence_on != "": fence = fence_on
	else: fence = ""                                       # no fence until one is built (the home field starts open)
	border = ""
	for pair in [["patch_edged", "stick"], ["patch_raised", "log"], ["patch_stone", "stone"]]:
		if G.nodes.has(pair[0]) and G.satisfied(pair[0]): border = pair[1]
	# no edging built yet: what is left of the old one (broken sticks; broken stones round the old fields)
	if border == "" and field_index > 0 and field_open: border = "stone_broken"   # an old field taken back: a few stones between the patches
	water = ""
	if G.nodes.has("patch_channel") and G.satisfied("patch_channel"): water = "channel"
	if G.nodes.has("drip_line") and G.done("drip_line"): water = "drip"
	back.queue_redraw()
	borders.queue_redraw()
	front.queue_redraw()
	call_deferred("_sync_critters")

# ------------------------------------------------------------------ fence and borders
func _draw_fence(ci: Control, front_sides: bool) -> void:
	if fence == "": return
	var tex := Art.tex("fences", fence)
	var lk: Array = FENCE_LOOK.get(fence, [Color("8a6239"), 3.0])
	var c := size / 2.0
	var hw := size.x / 2.0 + gap * 0.9
	var hh := hw / 2.0
	var top := c + Vector2(0, -hh)
	var rgt := c + Vector2(hw, 0)
	var bot := c + Vector2(0, hh)
	var lft := c + Vector2(-hw, 0)
	var sides := [[lft, bot], [bot, rgt]] if front_sides else [[lft, top], [top, rgt]]
	var broken := fence.ends_with("_broken")
	var si := 0
	for s in sides:
		si += 1
		for i in range(3):
			var a: Vector2 = s[0].lerp(s[1], i / 3.0)
			var b: Vector2 = s[0].lerp(s[1], (i + 1) / 3.0)
			var lost := (i + field_index + (1 if front_sides else 0)) % 3 == 1
			if fence == "stone_broken" and (i + si + field_index) % 3 == 0: lost = true     # old walls: only a few pieces are left
			if broken and lost:
				# a gap in a ruined fence: a lone post (or nothing) is left
				if fence == "stick_broken":
					var post: Texture2D = Art.first("deco", ["post_%d" % (1 + (i + si + field_index) % 4), "post_1"])
					if post:
						var pw := patch * 0.09
						var ph := pw * float(post.get_height()) / float(post.get_width())
						var at: Vector2 = a.lerp(b, 0.45)
						ci.draw_texture_rect(post, Rect2(at - Vector2(pw / 2.0, ph * 0.92), Vector2(pw, ph)), false)
				continue
			var t: Texture2D = tex
			if fence == "stick_broken": t = Art.first("fences", ["stick_broken_%d" % (1 + (i + si) % 3), "stick_broken"])
			UI.iso_side(ci, a, b, t, lk, true)

## Borders in the gaps round every patch in use: its two front sides, and its back sides where no patch in use is behind it.
func _draw_borders() -> void:
	var looks := []
	for kind in [water, border]:
		if kind != "": looks.append([Art.tex("edging", kind), BORDER_LOOK[kind]])
	if looks.is_empty(): return
	var broken := border.ends_with("_broken")
	var all_sides := []
	for k in range(9):
		if not usable[k] and not broken: continue
		var ctr := patch_center(k)
		var hw := pitch / 2.0
		var hh := hw / 2.0
		var top := ctr + Vector2(0, -hh)
		var rgt := ctr + Vector2(hw, 0)
		var bot := ctr + Vector2(0, hh)
		var lft := ctr + Vector2(-hw, 0)
		var sides := [[lft, bot], [bot, rgt]]
		if k % 3 == 0 or (not usable[k - 1] and not broken): sides.append([lft, top])
		if k / 3 == 0 or (not usable[k - 3] and not broken): sides.append([top, rgt])
		for si in range(sides.size()):
			var sd: Array = sides[si]
			for lk in looks:
				if broken and lk[1] == BORDER_LOOK[border] and absi(hash([field_index, k, si])) % 5 < 3: continue    # gaps
				all_sides.append([(sd[0] as Vector2).y + (sd[1] as Vector2).y, sd, lk])
	# back to front: logs and stones further back are drawn first, so the ones in front lie over them
	all_sides.sort_custom(func(a, b): return a[0] < b[0])
	for e in all_sides: UI.iso_side(borders, e[1][0], e[1][1], e[2][0], e[2][1], false)

# ------------------------------------------------------------------ pests and the scarecrow's looks
func _growing_points() -> Array:
	var out := []
	var arr: Array = G.area(area_name)
	for k in range(9):
		var i := field_index * 9 + k
		if i >= arr.size() or not G.patch_usable(area_name, i): continue
		var p = arr[i]
		if p["crop"] == "" or p["ready"]: continue
		out.append(patch_center(k))
	return out

## How many patches of this field have something growing (for sharing out the pests).
func growing_count() -> int:
	return _growing_points().size()

func _spot_near(c: Vector2) -> Vector2:
	return c + Vector2(randf_range(-0.22, 0.22) * patch, randf_range(-0.1, 0.1) * patch) - Vector2(12, 26)

func _pest_kind() -> String:
	return kinds[mini(G.chapter() - 1, kinds.size() - 1)] if randf() < 0.6 else kinds[randi() % kinds.size()]

func _sync_critters() -> void:
	var pts := _growing_points()
	var want := 0
	if pts.size() > 0: want = mini(14, int(round(float(G.S["pests"]) * pest_share)))
	while critters.size() > want:
		var c: Label = critters.pop_back()
		var tw := create_tween()
		tw.tween_property(c, "modulate:a", 0.0, 0.3)
		tw.tween_callback(c.queue_free)
	while critters.size() < want and pts.size() > 0:
		var c := UI.label(_pest_kind(), 24)
		c.mouse_filter = Control.MOUSE_FILTER_IGNORE
		c.position = Vector2(randf_range(0, size.x), -40)
		layer.add_child(c)
		critters.append(c)
		var tw2 := create_tween()
		tw2.tween_property(c, "position", _spot_near(pts[randi() % pts.size()]), 0.6)

## Where one of the pests on this field is (map coordinates), or Vector2.INF — the cat goes for it.
func pest_spot() -> Vector2:
	for c in critters:
		if is_instance_valid(c): return position + c.position + Vector2(12, 26)
	return Vector2.INF

## The cat pounced: the nearest pest runs off (it may come back later).
func shoo_one() -> void:
	if critters.is_empty(): return
	var c: Label = critters.pop_front()
	if not is_instance_valid(c): return
	var tw := create_tween()
	tw.tween_property(c, "position", c.position + Vector2(randf_range(-220, 220), -240), 0.5)
	tw.parallel().tween_property(c, "modulate:a", 0.0, 0.5)
	tw.tween_callback(c.queue_free)

var _sway_t := 0.0

func _process(delta: float) -> void:
	# ripe plants sway: redraw their patches about 20 times a second
	_sway_t += delta
	if _sway_t > 0.05:
		_sway_t = 0.0
		for p in patches:
			if p.any_ready() and p.top: p.top.queue_redraw()
	hop_t += delta
	look_t += delta
	if hop_t > 0.8:
		hop_t = 0.0
		var pts := _growing_points()
		for c in critters:
			if not is_instance_valid(c) or pts.is_empty() or randf() > 0.5: continue
			var target := _spot_near(pts[randi() % pts.size()])
			var tw := create_tween()
			tw.tween_property(c, "position", c.position.lerp(target, 0.5) + Vector2(0, -8), 0.18)
			tw.tween_property(c, "position", target, 0.18)
	# (the scarecrow only scares at the start of an interval, see play_pending)

func _throw_look(target: Label, chase: bool) -> void:
	if not is_instance_valid(target): return
	var look := UI.label(["💢", "😠", "👀"][randi() % 3], 22)
	look.mouse_filter = Control.MOUSE_FILTER_IGNORE
	look.position = scare_from
	layer.add_child(look)
	var tw := create_tween()
	tw.tween_property(look, "position", target.position, 0.35)
	tw.tween_property(look, "modulate:a", 0.0, 0.15)
	tw.tween_callback(look.queue_free)
	if chase:
		var tw2 := create_tween()
		tw2.tween_interval(0.35)
		tw2.tween_property(target, "position", target.position + Vector2(randf_range(-200, 200), -260), 0.5)
		tw2.parallel().tween_property(target, "modulate:a", 0.0, 0.5)
		tw2.tween_callback(target.queue_free)

func _on_step(info: Dictionary) -> void:
	if has_scarecrow: pending_scare += int(info.get("removed", 0))
	if info.get("rain", false):
		var rain := UI.label("🌧️🌧️🌧️", 30)
		rain.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rain.position = Vector2(-140, -20)
		layer.add_child(rain)
		var tw := create_tween()
		tw.tween_property(rain, "position", Vector2(size.x + 20, size.y * 0.4), 1.6)
		tw.tween_callback(rain.queue_free)
	# plants the pests ate: remember them, a bird shows it when the farm is visible again
	if area_name != "field": return
	var eaten: Dictionary = info.get("eaten", {})
	for i in eaten:
		var k := int(i) - field_index * 9
		if k < 0 or k > 8: continue
		var p = G.area(area_name)[int(i)]
		var after := clampi(G.shown_plants(float(p["plants"])), 1, 9)
		var lost := int(eaten[i])
		var cells: Array = IsoPatch.FILL.slice(after, mini(9, after + lost))
		pending_eats.append({"k": k, "cells": cells, "crop": str(p["crop"]), "stage": patches[k].spec.get("stage", "grown")})

## Plays what happened while a pop-up was open: pests eating (one animal per plant that is gone).
## Plays what happened while a pop-up was open, at the start of the new interval: first the scarecrow throws its
## fierce looks (as many at once as its level) and the pests it scares fly off; then, after a moment, a pest comes
## for every plant that was eaten, eats it, speeds off with it, and comes back a few seconds later without it.
func play_pending() -> void:
	if has_scarecrow and critters.size() > 0:
		var looks := maxi(1, scare_level)
		var chase := mini(pending_scare, critters.size())
		for j in range(mini(looks, critters.size())):
			var c: Label = critters[critters.size() - 1 - j]
			_throw_look(c, j < chase)
		for j in range(mini(chase, looks)): critters.pop_back()
	pending_scare = 0
	var delay := randf_range(1.2, 2.0)
	for e in pending_eats:
		for cell in e["cells"]:
			_eat_one(int(e["k"]), int(cell), str(e["crop"]), str(e["stage"]), delay)
			delay += 0.4
	pending_eats.clear()

func _eat_one(k: int, cell: int, crop: String, stage: String, delay: float) -> void:
	var p: IsoPatch = patches[k]
	var at: Vector2 = p.position + p.dc + p.plant_at(cell)
	# the plant that is eaten (it already left the patch: this copy stands in for it until it is carried off)
	var ct: Texture2D = Art.tex("crops", crop) if stage != "sprout" else Art.tex("deco", "sprout")
	var gnode: Control
	if ct:
		var tr := TextureRect.new()
		tr.texture = ct
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.size = Vector2(patch * 0.2, patch * 0.2)
		gnode = tr
	else:
		gnode = UI.label(G.nodes[crop].get("emoji", "🌱") if stage != "sprout" else "🌱", 20 if stage != "sprout" else 15)
		gnode.size = Vector2(28, 28)
	gnode.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gnode.position = at - Vector2(gnode.size.x / 2.0, gnode.size.y * 0.9)
	gnode.pivot_offset = gnode.size / 2.0
	gnode.modulate.a = 0.0
	layer.add_child(gnode)
	var who := _pest_kind()
	var flies := who == "🐦"
	var eater := UI.label(who, 24)
	eater.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var ptex: Texture2D = Art.first("pests", [str(PEST_ART.get(who, ""))])
	if ptex:
		eater.text = ""
		eater.custom_minimum_size = Vector2(36, 36)
		var pic := TextureRect.new()
		pic.texture = ptex
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pic.size = Vector2(36, 36)
		pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		eater.add_child(pic)
	var side := -1.0 if randf() < 0.5 else 1.0
	var start := at + (Vector2(randf_range(-160, 160), -220) if flies else Vector2(side * size.x * 0.6, 30))
	eater.position = start
	eater.modulate.a = 0.0
	layer.add_child(eater)
	var land := at - Vector2(26, 30)
	var tw := create_tween()
	tw.tween_interval(delay)
	tw.tween_property(gnode, "modulate:a", 1.0, 0.1)
	tw.parallel().tween_property(eater, "modulate:a", 1.0, 0.15)
	tw.tween_property(eater, "position", land, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	for _j in range(4):     # peck, peck, peck
		tw.tween_property(eater, "position", land + Vector2(4, 6), 0.09)
		tw.tween_property(eater, "position", land, 0.09)
	# off it speeds with the plant: the patch is visibly one plant short
	var away := land + (Vector2(side * 260.0, -280) if flies else Vector2(-side * size.x * 0.7, 20))
	tw.tween_property(gnode, "scale", Vector2(0.6, 0.6), 0.15)
	tw.tween_property(eater, "position", away, 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.parallel().tween_property(gnode, "position", away + Vector2(14, 18), 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.parallel().tween_property(eater, "modulate:a", 0.0, 0.45)
	tw.parallel().tween_property(gnode, "modulate:a", 0.0, 0.45)
	tw.tween_callback(gnode.queue_free)
	# a few seconds later it comes back, without the plant, and stays around the field
	tw.tween_interval(randf_range(2.5, 4.0))
	tw.tween_callback(_pest_returns.bind(eater, at))

func _pest_returns(eater: Label, near: Vector2) -> void:
	if not is_instance_valid(eater): return
	var pts := _growing_points()
	var target := _spot_near(pts[randi() % pts.size()] if pts.size() > 0 else near)
	eater.position = target + Vector2(randf_range(-200, 200), -240)
	var tw := create_tween()
	tw.tween_property(eater, "modulate:a", 1.0, 0.2)
	tw.parallel().tween_property(eater, "position", target, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if pts.size() > 0 and critters.size() < 14: critters.append(eater)
	else: tw.tween_callback(eater.queue_free)


## One diamond patch. Only the diamond itself reacts to taps, so neighbours never steal a tap.
class IsoPatch extends Control:
	signal pressed_patch(k: int)
	const UIc = preload("res://scripts/ui.gd")
	const Artc = preload("res://scripts/art.gd")
	## where the plants stand on a patch (a 3×3 grid inside the diamond): middle first, then side by side (left, right), then back and front, then the rest
	const FILL := [4, 2, 6, 0, 8, 1, 7, 3, 5]
	var k := 0
	var tw := 144.0
	var dc := Vector2.ZERO        # diamond centre in this control
	var spec := {}
	var _press := Vector2.ZERO
	var _pressing := false
	var pic: TextureRect
	var top: Control              # lives in the field's label layer (set by the field): plants, weeds, stones
	var pitch := 156.0            # patch + gap (the borders run along the middle of the gaps)

	## Kept for old callers: draws one side of a diamond (see UI.iso_side).
	static func side(ci: CanvasItem, a: Vector2, b: Vector2, tex: Texture2D, look: Array, posts: bool) -> void:
		UIc.iso_side(ci, a, b, tex, look, posts)

	func setup(index: int, tile_w: float, centre_in_field: Vector2, pitch_w := 156.0) -> void:
		k = index
		tw = tile_w
		pitch = pitch_w
		size = Vector2(tw * 1.1, tw * 0.95)
		dc = Vector2(size.x / 2.0, size.y - tw * 0.25 - tw * 0.1)
		position = centre_in_field - dc
		mouse_filter = Control.MOUSE_FILTER_PASS
		pic = TextureRect.new()
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_SCALE
		pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(pic)

	## Where plant i of the grid stands, relative to the diamond centre (kept well inside, clear of the edging).
	func plant_at(cell: int) -> Vector2:
		var sr := cell / 3
		var sc := cell % 3
		return Vector2((sc - sr) * tw / 6.0, (sc + sr - 2) * tw / 12.0) * 0.72

	## Pictures of wild patches (assets/patches/…), by what is in the way.
	const WILD_PIC := {"weeds": ["overgrown_1", "overgrown_2"], "rocks": ["overgrown_rocks"], "stumps": ["overgrown_stumps"],
		"scrub": ["scrub"], "marsh": ["marsh"]}
	static var _glow: Texture2D

	## A soft round glow (see-through in the middle, nothing at the edge) behind ripe plants.
	static func glow_tex() -> Texture2D:
		if _glow == null:
			var gr := Gradient.new()
			gr.set_color(0, Color(1.0, 0.88, 0.35, 0.42))
			gr.set_color(1, Color(1.0, 0.88, 0.35, 0.0))
			var gt := GradientTexture2D.new()
			gt.gradient = gr
			gt.fill = GradientTexture2D.FILL_RADIAL
			gt.fill_from = Vector2(0.5, 0.5)
			gt.fill_to = Vector2(1.0, 0.5)
			gt.width = 64
			gt.height = 64
			_glow = gt
		return _glow

	func _wild_pic() -> Texture2D:
		var keys: Array = WILD_PIC.get(str(spec.get("wild", "")), [])
		if keys.is_empty(): return null
		var key: String = keys[absi(int(spec.get("seed", 0))) % keys.size()]
		return Artc.first("patches", [key] + keys)

	func any_ready() -> bool:
		return str(spec.get("stage", "")) == "ready" and str(spec.get("crop", "")) != ""

	## A point inside the diamond (s, t from 0 to 1 along its two sides), relative to the diamond centre.
	func _in_diamond(s: float, t: float) -> Vector2:
		var topp := Vector2(0, -tw * 0.25)
		var u := Vector2(tw * 0.5, tw * 0.25)
		var v := Vector2(-tw * 0.5, tw * 0.25)
		return topp + u * s + v * t

	func show_state(s: Dictionary) -> void:
		spec = s
		var tex: Texture2D = null
		if s["wild"] == "" or _soil_look(): tex = Artc.tex("deco", "soil_heap")
		else: tex = _wild_pic()
		pic.texture = tex
		pic.visible = tex != null
		if tex:
			var w := tw * 1.02
			var h := w * float(tex.get_height()) / float(tex.get_width())
			var bottom := dc.y + tw * 0.25 + tw * 0.08
			pic.position = Vector2(dc.x - w / 2.0, bottom - h)
			pic.size = Vector2(w, h)
			pic.modulate = Color(1.08, 1.04, 0.86) if s["ready"] else Color.WHITE
			if s["wild"] != "" and not _soil_look(): pic.modulate = Color(1.06, 1.06, 1.0) if s["wild"] != "marsh" else Color(0.95, 1.02, 1.02)
		queue_redraw()
		if top: top.queue_redraw()

	## The ground of the patch: a worked patch is its picture; a wild one a diamond of growth (no earth rim).
	func _draw() -> void:
		var hw := tw * 0.5
		var hh := tw * 0.25
		var pts := PackedVector2Array([dc + Vector2(0, -hh), dc + Vector2(hw, 0), dc + Vector2(0, hh), dc + Vector2(-hw, 0)])
		if pic and pic.visible: return
		if spec.get("wild", "") != "" and _soil_look():
			# weedy or being cleared: bare soil, the weeds and stones stand on it one by one
			var st: Texture2D = Artc.tex("tiles", "soil")
			if st:
				var suv := PackedVector2Array()
				for p in pts: suv.append((p + position) / Vector2(st.get_width(), st.get_height()) * 2.0)
				draw_polygon(pts, PackedColorArray([Color(1.0, 0.95, 0.88)]), suv, st)
			else:
				draw_colored_polygon(pts, Color("a07a52"))
			draw_polyline(PackedVector2Array([pts[3], pts[2], pts[1]]), Color(0.25, 0.18, 0.1, 0.25), 2.0)
			return
		if spec.get("wild", "") != "":
			var g: Texture2D = Artc.first("tiles", ["overgrown_%d" % (1 + absi(int(spec.get("seed", 0))) % 3), "overgrown"])
			var tint := Color(1.08, 1.14, 0.98) if spec["wild"] != "marsh" else Color(0.85, 1.0, 0.98)
			if g:
				var uvs := PackedVector2Array()
				for p in pts: uvs.append((p + position) / Vector2(g.get_width(), g.get_height()) * 2.4)
				draw_polygon(pts, PackedColorArray([tint]), uvs, g)
			else:
				draw_colored_polygon(pts, Color("6b8f4b") * tint)
			draw_polyline(PackedVector2Array([pts[3], pts[2], pts[1]]), Color(0.15, 0.25, 0.1, 0.25), 2.0)
			return
		if pic and pic.visible: return
		# no picture yet: a coloured diamond
		var col := Color("c9a77c")
		if spec.get("ready", false): col = Color("f0c64a")
		elif spec.get("crop", "") != "": col = Color("9cc46a")
		draw_colored_polygon(pts, col)
		pts.append(pts[0])
		draw_polyline(pts, col.darkened(0.3), 2.0)

	## A locked patch that is weedy or half cleared shows bare soil with single weeds and stones on it.
	func _soil_look() -> bool:
		return spec.get("wild", "") == "weeds" or float(spec.get("clear", 0.0)) > 0.0

	## Everything standing on the patch, back to front: plants one by one, every weed and stone, or what is in the way.
	func draw_top(ci: Control) -> void:
		var things := []     # [y, kind, pos, size]
		var r := RandomNumberGenerator.new()
		r.seed = int(spec.get("seed", k))
		var wild := str(spec.get("wild", ""))
		if wild != "" and not _soil_look() and pic and pic.visible: return    # the wild patch's picture shows it all
		if wild != "":
			var plan := {"weeds": [["weeds", 7]], "rocks": [["rock", 3], ["weeds", 3]], "stumps": [["stump", 2], ["weeds", 3]],
				"scrub": [["bush", 2], ["weeds", 4]], "marsh": [["puddle", 3], ["reeds", 4], ["weeds", 2]]}
			if _soil_look():
				# soil with lots of single weeds and stray stones, fewer with every clearing step
				var left := 1.0 - float(spec.get("clear", 0.0))
				var soil_plan := [["weed", int(round(4 + 12 * left))], ["stone", int(round(1 + 4 * left))], ["debris", int(round(1 + 3 * left))]]
				if wild == "rocks" and left > 0.55: soil_plan.append(["rock", 2])
				if wild == "stumps" and left > 0.55: soil_plan.append(["stump", 2])
				plan = {"x": soil_plan}
				wild = "x"
			for pair in plan.get(wild, plan.get("weeds", [])):
				for _i in range(int(pair[1])):
					var at := dc + _in_diamond(r.randf_range(0.1, 0.9), r.randf_range(0.1, 0.9))
					things.append([at.y, pair[0], at, r.randi()])
		else:
			if spec["crop"] != "":
				var cells: Array = FILL.slice(0, int(spec["plants"]))
				for cell in cells:
					var at2: Vector2 = dc + plant_at(cell)
					things.append([at2.y, "plant", at2, int(cell)])
			for _i in range(int(spec["weeds"])):
				var at3 := dc + _in_diamond(r.randf_range(0.08, 0.92), r.randf_range(0.08, 0.92))
				things.append([at3.y, "weed", at3, r.randi()])
			for _i in range(int(spec["stones"])):
				var at4 := dc + _in_diamond(r.randf_range(0.1, 0.9), r.randf_range(0.1, 0.9))
				things.append([at4.y, "stone", at4, r.randi()])
		things.sort_custom(func(a, b): return a[0] < b[0])
		for t in things: _thing(ci, t[1], t[2], int(t[3]) if t.size() > 3 else 0)

	func _pic(ci: Control, tex: Texture2D, at: Vector2, w: float, tint := Color.WHITE) -> void:
		var h := w * float(tex.get_height()) / float(tex.get_width())
		ci.draw_texture_rect(tex, Rect2(at - Vector2(w / 2.0, h * 0.92), Vector2(w, h)), false, tint)

	func _emoji(ci: Control, e: String, at: Vector2, fs: int) -> void:
		var f: Font = ci.get_theme_font("font", "Label")
		var sz := f.get_string_size(e, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
		ci.draw_string(f, at - Vector2(sz.x / 2.0, fs * 0.15), e, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)

	func _thing(ci: Control, kind: String, at: Vector2, v := 0) -> void:
		match kind:
			"plant":
				var stage := str(spec.get("stage", "grown"))
				if stage == "sprout":
					var sp: Texture2D = Artc.tex("deco", "sprout")
					if sp: _pic(ci, sp, at, tw * 0.14)
					else: _emoji(ci, "🌱", at, int(tw * 0.1))
					return
				var ready := stage == "ready"
				var ct: Texture2D = Artc.tex("crops", str(spec["crop"]))
				var w := tw * (0.22 if ready else 0.18)
				if ready:
					# ripe: a soft glow behind it, and it sways and swells a little ("pick me!")
					var t := Time.get_ticks_msec() / 1000.0
					var ph := float(v) * 1.7 + float(k)
					var gw := w * 1.5
					ci.draw_texture_rect(glow_tex(), Rect2(at - Vector2(gw / 2.0, gw * 0.62), Vector2(gw, gw * 0.75)), false)
					var sc := 1.0 + 0.05 * sin(t * 3.0 + ph)
					ci.draw_set_transform(at, sin(t * 2.0 + ph) * 0.07, Vector2(sc, sc))
					if ct: _pic(ci, ct, Vector2.ZERO, w)
					else: _emoji(ci, str(G_emoji(spec["crop"])), Vector2.ZERO, int(w * 0.72))
					ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
					return
				if ct: _pic(ci, ct, at, w)
				else: _emoji(ci, str(G_emoji(spec["crop"])), at, int(w * 0.72))
			"weed", "weeds":
				var wt: Texture2D = Artc.first("deco", ["weed_%d" % (1 + absi(v) % 9), "weeds"])
				var ww := tw * (0.13 if kind == "weed" else 0.17)
				if wt: _pic(ci, wt, at, ww)
				else: _emoji(ci, "🌿", at, int(ww * 0.8))
			"stone":
				var st: Texture2D = Artc.first("deco", ["debris_%d" % (1 + absi(v) % 3), "stone"])
				if st: _pic(ci, st, at, tw * 0.1)
				else: ci.draw_circle(at, tw * 0.03, Color("9a9a92"))
			"debris":
				var dt: Texture2D = Artc.first("deco", ["debris_%d" % (4 + absi(v) % 6)])
				if dt: _pic(ci, dt, at, tw * 0.1)
			"rock":
				var rt: Texture2D = Artc.first("deco", ["rubble", "stone"])
				if rt: _pic(ci, rt, at, tw * 0.2)
				else: ci.draw_circle(at, tw * 0.06, Color("8f8f86"))
			"stump":
				var sp2: Texture2D = Artc.tex("deco", "stump")
				if sp2: _pic(ci, sp2, at, tw * 0.2)
				else:
					var rw := tw * 0.08
					ci.draw_rect(Rect2(at - Vector2(rw, rw * 1.1), Vector2(rw * 2.0, rw * 1.1)), Color("7a5230"))
					_ellipse(ci, at - Vector2(0, rw * 1.1), rw, rw * 0.5, Color("d2a874"))
					_ellipse(ci, at - Vector2(0, rw * 1.1), rw * 0.5, rw * 0.25, Color("b88a55"))
			"bush":
				var bt: Texture2D = Artc.tex("deco", "bush")
				if bt: _pic(ci, bt, at, tw * 0.24)
				else: _emoji(ci, "🌳", at, int(tw * 0.15))
			"puddle":
				_ellipse(ci, at, tw * 0.09, tw * 0.04, Color(0.42, 0.62, 0.72, 0.85))
			"reeds":
				var rd: Texture2D = Artc.tex("deco", "reeds")
				if rd: _pic(ci, rd, at, tw * 0.12)
				else:
					for j in range(4):
						ci.draw_line(at + Vector2(j * 3.0 - 4.5, 0), at + Vector2(j * 4.0 - 6.0, -tw * 0.08), Color(0.24, 0.42, 0.16), 2.0)

	func _ellipse(ci: Control, c: Vector2, rx: float, ry: float, col: Color) -> void:
		var pts := PackedVector2Array()
		for j in range(16): pts.append(c + Vector2(cos(TAU * j / 16.0) * rx, sin(TAU * j / 16.0) * ry))
		ci.draw_colored_polygon(pts, col)

	func G_emoji(crop: String) -> String:
		var g = get_node_or_null("/root/Game")
		if g and g.nodes.has(crop): return str(g.nodes[crop].get("emoji", "🌱"))
		return "🌱"

	func _has_point(p: Vector2) -> bool:
		var d := p - dc
		return absf(d.x) / (tw * 0.5) + absf(d.y) / (tw * 0.25) <= 1.0

	func _gui_input(e: InputEvent) -> void:
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed:
				_press = e.position
				_pressing = true
				modulate = Color(0.9, 0.9, 0.9)
			elif _pressing:
				_pressing = false
				modulate = Color.WHITE
				if e.position.distance_to(_press) < 16.0:
					pressed_patch.emit(k)
		elif e is InputEventMouseMotion and _pressing and e.position.distance_to(_press) >= 16.0:
			_pressing = false
			modulate = Color.WHITE

	func _notification(what: int) -> void:
		if what == NOTIFICATION_SCROLL_BEGIN and _pressing:
			_pressing = false
			modulate = Color.WHITE
