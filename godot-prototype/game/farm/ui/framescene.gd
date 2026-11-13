extends RefCounted
class_name FarmUiFrameScene
## The grandchildren's frame (story/11): the bedside scene at the start and after each chapter's last beat, as a full-screen black scene
## with only a picture and words, no top bar and no farm, and its own music. A tap anywhere goes on page by page; from the second viewing a
## ⏭ Skip button leaves at once; the last tap leaves. WHICH frame is ready is G.story (a piece of kind "frame"); WHEN it shows is the
## interruption queue's (kind "frame" in rules/65-feel.json: it waits for a quiz, Rest, a pop-up, a sheet, a postcard or celebration, and
## the farm catching up; a story box waits for it). While it is open it counts as a pop-up (the "popup" screen of the queue), so every
## other interruption waits. Pictures are found like the story box's (FarmUiStory.page_picture); a page without one shows the emoji.
## Music: Sound.music("frame") while it is open (data/sounds.json), the farm's music again when it closes.

const UI = preload("res://kits/ui/ui.gd")
const CREAM := Color("f4ead2")
const DIM := Color("a39a84")
const TEXT_SIZE := 28
const MAX_TEXT_W := 720.0

var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

var _root: Control = null      # the scene while it is open
var _id := ""
var _pages: Array = []
var _page := 0
var _again := false            # seen before: the Skip button is there
var _body: Control = null      # this page's picture, words and buttons (rebuilt for every page)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ state (the queue and the tests ask)

## Is a frame scene on screen?
func active() -> bool:
	return _root != null and is_instance_valid(_root)

## The scene's top control (a tap on it goes on), or null.
func root() -> Control:
	return _root if active() else null

func shown_id() -> String:
	return _id if active() else ""

## The page now shown, counting from 0, and how many there are.
func page_no() -> int:
	return _page

func page_count() -> int:
	return _pages.size()

func skip_shown() -> bool:
	return active() and _again and _page < _pages.size() - 1

# ------------------------------------------------------------------ opening, going on, closing

## Opens a frame (the piece `id`), on its first page. `again`: it was seen before, so the Skip button is there.
func show_frame(id: String, again: bool) -> void:
	var pages: Array = G.story.pages(id)
	if pages.is_empty(): return
	if active(): _close_scene()
	_id = id
	_pages = pages
	_again = again
	_root = Control.new()
	_root.name = "FrameScene"
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_STOP      # nothing of the farm behind it can be tapped
	_root.z_index = 100
	_root.gui_input.connect(_on_input)
	M.add_child(_root)
	var black := ColorRect.new()
	black.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	black.color = Color.BLACK
	black.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(black)
	Sound.music("frame")
	_show_page(0)

## A tap: the next page, or the end after the last one.
func advance() -> void:
	if not active(): return
	if _page >= _pages.size() - 1: close()
	else: _show_page(_page + 1)

## Leaves the scene: the farm's music comes back, and whatever waited for the screen may come.
func close() -> void:
	if not active(): return
	_close_scene()
	Sound.music("farm", G.seasons.season())
	M.queue_refresh()
	M.interrupts.request()

func _close_scene() -> void:
	if G.read_aloud_mode() != "off": DisplayServer.tts_stop()
	_root.get_parent().remove_child(_root)
	_root.queue_free()
	_root = null
	_body = null

func _on_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: advance()

# ------------------------------------------------------------------ a page

func _show_page(i: int) -> void:
	_page = clampi(i, 0, _pages.size() - 1)
	if _body != null:
		_root.remove_child(_body)
		_body.queue_free()
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["left", "right"]: margin.add_theme_constant_override("margin_" + side, 36)
	for side in ["top", "bottom"]: margin.add_theme_constant_override("margin_" + side, 28)
	_root.add_child(margin)
	_body = margin
	var col := UI.vbox(16)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(col)
	var last := _page >= _pages.size() - 1
	# the top: the piece's title, and from the second viewing a Skip button
	var top := UI.hbox(8)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var title := UI.label(str(G.story.piece(_id).get("title", "")), 20, DIM)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top.add_child(title)
	if _again and not last:
		var sk := _button(tr("⏭ Skip"), close, 18)
		sk.custom_minimum_size = Vector2(0, 52)
		top.add_child(sk)
	col.add_child(top)
	# the picture, as big as the screen allows (else the emoji)
	var pg: Dictionary = _pages[_page]
	var tex: Texture2D = M.story.page_picture(_id, _page)
	var slot: Control
	if tex:
		var r := TextureRect.new()
		r.texture = tex
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot = r
	else:
		var em := UI.label(M.story.emoji_of(_id), 240)
		em.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		em.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		slot = em
	slot.size_flags_vertical = Control.SIZE_EXPAND_FILL
	slot.custom_minimum_size = Vector2(0, 120)
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(slot)
	# the words
	var text := str(pg.get("text", ""))
	var l := UI.label(text, TEXT_SIZE, CREAM, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.custom_minimum_size = Vector2(clampf(M.size.x - 72.0, 280.0, MAX_TEXT_W), 0)
	l.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(l)
	# the bottom: 🔊, the pages as dots, and what a tap does (→ goes on, ✔ leaves)
	var bottom := UI.hbox(8)
	bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var left := UI.hbox(0)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if G.read_aloud_mode() != "off":
		left.add_child(_button(tr("🔊 Read aloud"), M.timequiz.speak.bind(text), 17))
		if G.read_aloud_mode() == "auto": M.timequiz.speak.call_deferred(text)
	bottom.add_child(left)
	if _pages.size() > 1:
		var dots: PackedStringArray = []
		for k in range(_pages.size()): dots.append("●" if k == _page else "○")
		var dl := UI.label("  ".join(dots), 24, DIM)
		dl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		dl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bottom.add_child(dl)
	var go := UI.label("✔" if last else "→", 40, CREAM)
	go.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	go.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	go.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bottom.add_child(go)
	col.add_child(bottom)
	var pulse := go.create_tween().set_loops()           # the arrow breathes: "tap me"
	pulse.tween_property(go, "modulate:a", 0.35, 0.9)
	pulse.tween_property(go, "modulate:a", 1.0, 0.9)
	# every page fades in
	margin.modulate.a = 0.0
	margin.create_tween().tween_property(margin, "modulate:a", 1.0, G.feel("story.frameFade"))

## A quiet button for the black scene (it takes the tap itself: the scene behind it does not go on).
func _button(text: String, cb: Callable, size: int) -> Button:
	var b := UI.button(text, cb, true, Color(1, 1, 1, 0.14), size)
	b.mouse_filter = Control.MOUSE_FILTER_STOP
	return b
