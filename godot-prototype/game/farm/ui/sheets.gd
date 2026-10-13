extends RefCounted
class_name FarmUiSheets
## The sheet that slides up from the bottom when a place is tapped: opening, closing, fitting to the screen, rebuilding its content.

const UI = preload("res://kits/ui/ui.gd")
const Spots = preload("res://game/farm/spots.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

var _slide := 1.0

# ------------------------------------------------------------------ the sheet

## A tap on a place: a building with an inside opens its inside, everything else its sheet.
func open_spot(sid: String) -> void:
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

func open_goals() -> void: open_sheet("goals")

func open_album() -> void: open_sheet("album")

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

## The sheet grows with its content, up to 60% of the screen.
func fit_sheet() -> void:
	if not M.sheet.visible: return
	var want := M.content.get_combined_minimum_size().y + 96.0
	M.sheet_h = clampf(want, 240.0, M.size.y * 0.6)
	_place_sheet()
	M.map.set_extra_bottom(M.sheet_h)

func _place_sheet() -> void:
	M.sheet.size = Vector2(M.size.x, M.sheet_h)
	M.sheet.position = Vector2(0, M.size.y - M.sheet_h + (1.0 - _slide) * M.sheet_h)

func rebuild_sheet() -> void:
	M.widgets.clear(M.content)
	var k := M.sheet_kind
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
			"album":
				M.sheet_title.text = tr("🖼️ Album")
				M.content.add_child(UI.header(null, "🖼️", 80))
				M.album.sheet_album()
			"log":
				M.sheet_title.text = tr("📜 What happened")
				M.questlog.sheet_log()
