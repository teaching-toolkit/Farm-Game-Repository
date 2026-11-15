extends RefCounted
## The village square's ground (money-market/12): diamond slabs (isometric 2:1, assets/square_tiles/) laid as a map from the scene's TOP edge
## to its bottom and from its left to its right edge: no sky. One function builds it, `build(box, layout)`; ui/square.gd only passes the data
## (rules/49-trip.json "square" "ground") and puts the returned control where the ground goes. No tile is tappable (one control, one `_draw`).
##
## The map: `layout.rows` is one string per row, one letter per cell, letters separated by spaces. Row 0 is the top (its slabs poke out over the
## top edge, so no notch between two slabs shows the colour behind); rows beyond the map repeat its LAST row, a cell beyond a row's end repeats the
## row's last letter (so the scene's height needs no more rows). `layout.kinds` says what a letter is: {"files": ["folder/name", …] (pictures in
## assets/), "flip": true (drawn mirrored)}. Which file of the kind a cell gets is a stable hash of its (column, row), so a redraw never changes the look.
##
## The laying: a cell is as wide as the scene's width / 8 (every size is a share of the WIDTH; the number of rows follows from the height); each
## row sits a quarter of that width lower than the row above it; every odd row is shifted right by half a cell, so in an even row column c is
## centred on x = c cells and in an odd row on x = c + 0.5 cells (even rows have columns 0 to 8, the first and the last half outside the scene, odd
## rows 0 to 7). A row's middle is (row - 0.5) quarter cells down. Row by row from the top, so a lower row covers the slab edge of the one above.

const Art = preload("res://kits/ui/art.gd")

const ACROSS := 8.0      # cells across the scene's width
const ROW := 0.25        # a row sits this share of a cell's width lower than the one above
const SLAB := 0.66       # a slab is this tall as a share of its width; a taller picture (tulips, lupins) stands up over the row above
const TOP := -1.5        # row 0's picture starts this many rows above the scene's top edge (the slabs' tips are then above the edge)

## The ground for a scene of `box`: a control at the scene's top left, `box` big, that draws the slabs and nothing else.
## Empty (draws nothing) when there is no usable layout or no room yet.
static func build(box: Vector2, layout: Dictionary) -> Control:
	var canvas := _Canvas.new()
	canvas.name = "ground"
	canvas.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.clip_contents = true
	canvas.position = Vector2.ZERO
	canvas.size = box
	if box.x < 2.0 or box.y < 2.0 or not usable(layout): return canvas
	var w := box.x / ACROSS
	var rows := int(ceilf(box.y / (w * ROW))) + 3
	for r in range(rows):
		for c in range(int(ACROSS) + 1):
			var x := (float(c) - (0.5 if r % 2 == 0 else 0.0)) * w      # the left edge of the cell's picture
			if x >= box.x or x + w <= 0.0: continue
			var cl := cell(layout, c, r)
			var t := _tex(str(cl.get("art", "")))
			if t == null: continue
			var h := w * float(t.get_height()) / maxf(1.0, float(t.get_width()))
			var y := (float(r) + TOP) * w * ROW
			canvas.slabs.append([t, Rect2(x, y, w, h), bool(cl["flip"])])
	return canvas

## Is there a map to lay (rows and kinds)?
static func usable(layout: Dictionary) -> bool:
	return layout.get("rows", []) is Array and not layout.get("rows", []).is_empty() and layout.get("kinds", {}) is Dictionary

## What is in a cell of the map: {"kind": the letter, "art": "folder/name", "flip": bool}; {} when the map has no such kind. Called twice with the
## same layout, column and row it gives the same answer (the picture comes from a stable hash of column and row, never from chance).
static func cell(layout: Dictionary, col: int, row: int) -> Dictionary:
	var rows: Array = layout.get("rows", [])
	if rows.is_empty(): return {}
	var letters := str(rows[clampi(row, 0, rows.size() - 1)]).split(" ", false)
	if letters.is_empty(): return {}
	var kind := str(letters[clampi(col, 0, letters.size() - 1)])
	var def: Dictionary = layout.get("kinds", {}).get(kind, {})
	var files: Array = def.get("files", [])
	if files.is_empty(): return {}
	return {"kind": kind, "art": str(files[_hash(col, row) % files.size()]), "flip": bool(def.get("flip", false))}

## A whole number that is the same for the same column and row on every run and machine (integer arithmetic only).
static func _hash(col: int, row: int) -> int:
	var h := ((col + 7) * 73856093) ^ ((row + 13) * 19349663)
	h = (h ^ (h >> 13)) * 1274126177
	return (h ^ (h >> 16)) & 0x7fffffff

## A picture by "folder/name" (null when the file is not there).
static func _tex(path: String) -> Texture2D:
	var at := path.find("/")
	if at <= 0: return null
	return Art.tex(path.substr(0, at), path.substr(at + 1))

## The control that draws the slabs: [texture, rect, mirrored] in the order they are laid.
class _Canvas extends Control:
	var slabs: Array = []

	func _draw() -> void:
		for s in slabs:
			var r: Rect2 = s[1]
			if s[2]:      # mirrored: drawn leftwards from the rect's right edge
				draw_set_transform(Vector2(r.end.x, r.position.y), 0.0, Vector2(-1.0, 1.0))
				draw_texture_rect(s[0], Rect2(Vector2.ZERO, r.size), false)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			else:
				draw_texture_rect(s[0], r, false)
