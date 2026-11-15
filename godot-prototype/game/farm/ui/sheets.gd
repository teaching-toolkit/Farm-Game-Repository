extends RefCounted
class_name FarmUiSheets
## The sheet that slides up from the bottom when a place is tapped: opening, closing, fitting to the screen, rebuilding its content.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots =preload("res://game/farm/spots.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

var _slide := 1.0

# ------------------------------------------------------------------ the sheet

## A tap on a place: a building with an inside opens its inside, everything else its sheet.
func open_spot(sid: String) -> void:
	if sid == "farmer":        # a tap on the farmer opens the wellbeing dashboard, once it has appeared (TODO L4)
		if G.reveal.shown("face"): open_sheet("well")
		return
	G.story.tapped(sid)
	M.feedback.animal_voice(sid)
	if Spots.has_interior(sid) and M.mapview.built(sid):
		M.interiors.open_interior(sid)
		return
	open_sheet_for(sid)

## The sheet of a place or of a corner inside a building. Before a barn or workshop stands, its corners share one sheet.
func open_sheet_for(sid: String) -> void:
	var parent := Spots.parent_of(sid)
	var target := sid
	if parent != "" and parent != "home" and not M.mapview.built(parent): target = parent
	open_sheet("spot:" + target)
	M.get_tree().create_timer(0.1).timeout.connect(_reveal_spot.bind(target))

func _reveal_spot(sid: String) -> void:
	M.mapview.reveal(M.map.spot_rect(M.mapview.map_sid(sid)))

# ------------------------------------------------------------------ inside a building

func open_pantry() -> void: open_spot("storage")

func open_bag() -> void: open_sheet("bag")

func open_goals() -> void: open_sheet("goals")

func open_album() -> void: open_sheet("album")

func open_scroll() -> void: open_sheet("scroll")

func open_sheet(kind: String) -> void:
	M.interior_back = ""
	M.patch_note = -1
	var was := M.sheet.visible
	M.sheet_kind = kind
	M.sheet_scroll.scroll_vertical = 0
	M.sheet.visible = true
	rebuild_sheet()
	fit_sheet()
	fit_sheet.call_deferred()
	M.get_tree().create_timer(0.06).timeout.connect(fit_sheet)
	if not was:
		M.feedback.sfx("open")
		_slide = 0.0
		var tw := M.create_tween()
		tw.tween_method(_set_slide, 0.0, 1.0, 0.22).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

## 0 = hidden below the screen, 1 = fully up (used for the slide-in).
func _set_slide(v: float) -> void:
	_slide = v
	_place_sheet()

func close_sheet() -> void:
	var was_stall := _on_square()
	if M.sheet.visible: M.feedback.sfx("close")
	M.sheet.visible = false
	M.sheet_kind = ""
	M.sheet_h = 0.0
	M.map.set_extra_bottom(0.0)
	M.widgets.clear(M.content)
	if M.interior_back != "":
		var p := M.interior_back
		M.interior_back = ""
		M.interiors.open_interior(p)
	# on the village square, closing a window does not take the farmer home: the scene fills the screen (only 🏠 Back home leaves it);
	# a stall's window that waited under the bag or the quest book comes back
	if G.trip.at_square():
		if was_stall: M.square.window = false
		if not was_stall and M.square.window:
			open_sheet_for("market")
			return
		M.square.sync()
		M.interrupts.request()
		return
	M.square.sync()               # back home: the farm is seen again
	M.playback.farm_seen()        # a walk's news waits for the farm to be seen again
	M.interrupts.request()        # what waited for the sheet to close (a frame scene, a story box) comes now, not at the next change

## The sheet grows with its content, up to 60% of the screen.
func fit_sheet() -> void:
	if not M.sheet.visible: return
	var want := M.content.get_combined_minimum_size().y + 96.0
	M.sheet_h = clampf(want, 240.0, M.size.y * 0.6)
	if _on_square(): M.sheet_h = M.square.sheet_height()      # the square's window always has the same height, so the scene above it stands still
	_place_sheet()
	M.map.set_extra_bottom(M.sheet_h)

## Is the sheet the village square's window (the stall that was tapped, below the scene)?
func _on_square() -> bool:
	return M.sheet_kind == "spot:market" and G.trip.at_square()

func _place_sheet() -> void:
	M.sheet.size = Vector2(M.size.x, M.sheet_h)
	M.sheet.position = Vector2(0, M.size.y - M.sheet_h + (1.0 - _slide) * M.sheet_h)

## The picture key (assets/windows/<key>.webp, the ids of tools/window_pictures.json) of the window that is open now; "" for none.
## A place's window is its place id (a corner inside a building has its own id, e.g. ws_loom, barn_hay); the others are named by their kind.
func window_key() -> String:
	var k := M.sheet_kind
	if k == "" or _on_square() or k == "mystery": return ""
	if k.begins_with("spot:"):
		return "" if M.mapview.mystery(k.substr(5)) else k.substr(5)      # a mystery place gives nothing away
	if k.begins_with("patch:"): return "patch"
	if k == "well": return "well_dashboard"
	return k      # bag, goals, album, scroll, forest, log

## The painted picture across the top of the window (first thing in the scrolling content); none when the key has no file.
func _window_picture() -> TextureRect:
	var key := window_key()
	if key == "": return null
	var t := Art.first("windows", [key])
	if t == null: return null
	var w := maxf(M.size.x - 40.0, 200.0)
	var r := TextureRect.new()
	r.name = "WindowPicture"
	r.texture = t
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	r.clip_contents = true
	r.custom_minimum_size = Vector2(0, minf(w * 2.0 / 3.0, w * 0.42))
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UI.round_picture(r)
	return r

func rebuild_sheet() -> void:
	M.widgets.clear(M.content)
	var k := M.sheet_kind
	M.square.sync()            # the scene of the village square comes and goes with the farmer
	if _on_square():           # in the village: the window of the stall that was tapped (the scene above it is ui/square.gd)
		M.sheet_title.text = tr("🏘️ The village")
		M.square.window = true
		M.square.build_window()
		return
	_build_content(k)
	var pic := _window_picture()
	if pic:
		M.content.add_child(pic)
		M.content.move_child(pic, 0)

func _build_content(k: String) -> void:
	if k.begins_with("spot:"):
		var sid := k.substr(5)
		if M.mapview.mystery(sid):
			M.sheet_title.text = "❔"
			M.placesheet.part_mystery()
			return
		M.sheet_title.text = "%s %s" % [M.mapview.spot_emoji(sid), M.mapview.spot_title(sid)]
		M.content.add_child(M.placesheet.spot_header(sid))
		M.placesheet.sheet_spot(sid)
	elif k.begins_with("patch:"):
		var parts := k.split(":")
		M.patches.sheet_patch(parts[1], int(parts[2]))
	else:
		match k:
			"mystery":
				M.sheet_title.text = "❔"
				M.placesheet.part_mystery()
			"goals":
				M.sheet_title.text = tr("📖 Quest book")
				M.content.add_child(UI.header(null, "📖", 80))
				M.questlog.sheet_goals()
			"bag":
				M.sheet_title.text = tr("🎒 Bag")
				M.content.add_child(UI.header(null, "🎒", 70))
				M.pantry.part_bag()
			"forest":
				M.sheet_title.text = tr("🌲 The forest")
				M.content.add_child(UI.header(null, "🌲", 70))
				M.forestui.sheet_forest()
			"well":
				M.sheet_title.text = tr("%s How you feel") % G.well.face()
				M.wellui.sheet_well()
			"scroll":
				M.sheet_title.text = tr("📜 Story")
				M.content.add_child(UI.header(null, "📜", 80))
				M.story.sheet_scroll()
			"album":
				M.sheet_title.text = tr("🖼️ Album")
				M.content.add_child(UI.header(null, "🖼️", 80))
				M.album.sheet_album()
			"log":
				M.sheet_title.text = tr("📋 What happened")
				M.questlog.sheet_log()
