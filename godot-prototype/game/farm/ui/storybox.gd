extends RefCounted
class_name FarmUiStory
## The story on screen (TODO Phase 5.2): the story box (pages, one big button), speech bubbles that stay until tapped, and the 📜 scroll
## that lists what was read. WHAT may show and WHEN is decided by G.story (game/farm/systems/story.gd); this part only shows it,
## and only when the farm is quiet: no Time Quiz or Rest, no pop-up, no celebration or gift waiting, no sheet open (a Discovery
## may come over a sheet: you just tapped it).

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")

const KIND_EMOJI := {"frame": "📖", "beat": "✨", "discovery": "🔎", "letter": "✉️", "moment": "💬", "visit": "🚶", "scene": "🏘️", "bark": "💬"}
const PICTURE_FOLDERS := ["story", "friends", "helpers", "ruins", "deco", "map"]
const SCENE_H := 520.0         # height of a painted story scene (a square picture; the pop-up is up to 760 wide)

var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

var enabled := true            # tests and screenshots of other things switch the story off (--nostory)
var _queued := false
var _then := ""                # what follows the box that is open ("welcome": the old welcome hints)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ when

## Asks for a pump once the current frame is over (many things ask; one pump runs).
func queue_pump() -> void:
	if _queued: return
	_queued = true
	pump.call_deferred()

## Shows the next ready piece if the farm is quiet. Returns true when something was shown.
func pump() -> bool:
	_queued = false
	if not enabled or G == null: return false
	var id := G.story.next_piece()
	if id == "": return false
	if not _quiet(id): return false
	show_piece(id)
	return true

func _quiet(id: String) -> bool:
	if M.modal.visible or M.playback.held or not M.rest_state.is_empty(): return false
	var kind := str(G.story.piece(id).get("kind", ""))
	if kind == "bark": return bubble_count() == 0      # a bubble blocks nothing (one at a time)
	if M.celebration_queue.size() > 0 or G.S["gift_pending"].size() > 0: return false
	if M.sheet.visible and kind != "discovery": return false
	return true

func bubble_count() -> int:
	var n := 0
	for c in M.toasts.get_children():
		if c.get_meta("sticky", false): n += 1
	return n

# ------------------------------------------------------------------ showing

## Shows a piece: a bark as a speech bubble, everything else as a box. Marks it seen (a box that is closed early is not shown again).
func show_piece(id: String, reread := false) -> void:
	var kind := str(G.story.piece(id).get("kind", ""))
	var again := reread or G.story.seen(id)
	if not reread: G.story.mark_seen(id)
	if kind == "bark":
		for pg in G.story.pages(id):
			M.toasts.notify("%s %s" % [_emoji(id), pg["text"]], 0.0, true)
		return
	_then = str(G.story.piece(id).get("then", "")) if not reread else ""
	_page(id, 0, again)

func _emoji(id: String) -> String:
	var p := G.story.piece(id)
	return str(p.get("emoji", KIND_EMOJI.get(str(p.get("kind", "")), "💬")))

func _picture(id: String, pic: String) -> Texture2D:
	if pic == "": return null
	for f in PICTURE_FOLDERS:
		var t: Texture2D = Art.first(f, [pic])
		if t: return t
	return null

## A painted scene for a page (assets/story/<id>_p<page>.png, else <id>.png), shown big; null if there is none.
func _scene(id: String, page: int) -> Texture2D:
	return Art.first("story", ["%s_p%d" % [id, page + 1], id])

func _scene_view(tex: Texture2D) -> Control:
	var r := TextureRect.new()
	r.texture = tex
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.custom_minimum_size = Vector2(0, SCENE_H)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r

func _page(id: String, i: int, again: bool) -> void:
	var pages: Array = G.story.pages(id)
	if pages.is_empty(): return
	i = clampi(i, 0, pages.size() - 1)
	var pg: Dictionary = pages[i]
	var p := G.story.piece(id)
	var title := str(p.get("title", ""))
	var box := M.modals.open_modal(title if title != "" else _emoji(id))
	var scene := _scene(id, i)
	if scene: box.add_child(_scene_view(scene))
	else: box.add_child(UI.header(_picture(id, str(pg.get("picture", ""))), _emoji(id), 140, Color.WHITE, true))
	var text := str(pg["text"])
	var l := UI.label(text, 22, UI.INK, true)
	box.add_child(l)
	if G.read_aloud_mode() != "off":
		box.add_child(UI.soft_button(tr("🔊 Read aloud"), M.timequiz.speak.bind(text), true, 17))
		if G.read_aloud_mode() == "auto": M.timequiz.speak.call_deferred(text)
	var last := i >= pages.size() - 1
	var row := UI.hbox(8)
	if again and not last:
		var sk := UI.soft_button(tr("⏭ Skip"), _finish.bind(id), true, 17)
		sk.custom_minimum_size = Vector2(0, 56)
		row.add_child(sk)
	var go := UI.button(tr("Got it ✔") if last else tr("Next ▶"), _finish.bind(id) if last else _page.bind(id, i + 1, again), true, UI.GREEN, 22)
	go.custom_minimum_size = Vector2(0, 62)
	go.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(go)
	box.add_child(row)
	if pages.size() > 1: box.add_child(UI.label("%d / %d" % [i + 1, pages.size()], 14, UI.MUTED))

func _finish(_id: String) -> void:
	var then := _then
	_then = ""
	M.modals.close_modal()
	if then == "welcome" and G.S["step"] == 0 and not G.done("k_wheat"): M.welcome.show_welcome.call_deferred(true)

# ------------------------------------------------------------------ the scroll

## The 📜 scroll: everything read so far, a chapter at a time; a tap reads a piece again.
func sheet_scroll() -> void:
	var ids: Array = G.story.seen_in_order()
	if ids.is_empty():
		M.content.add_child(UI.label(tr("Nothing here yet. The story is waiting for you on the farm."), 18, UI.MUTED, true))
		return
	var chap := 0
	for id in ids:
		var p := G.story.piece(id)
		var c := int(p.get("chapter", 1))
		if c != chap:
			chap = c
			M.widgets.section(tr("Chapter %d") % c)
		var b := UI.soft_button("%s %s" % [_emoji(id), _short(id)], _reread.bind(id), true, 18)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.clip_text = true
		b.custom_minimum_size = Vector2(0, 52)
		M.content.add_child(b)

func _reread(id: String) -> void:
	show_piece(id, true)

## What the scroll shows for a piece: its title, else the start of its text.
func _short(id: String) -> String:
	var p := G.story.piece(id)
	if str(p.get("title", "")) != "": return str(p["title"])
	var pages: Array = G.story.pages(id)
	var t: String = str(pages[0]["text"]) if pages.size() > 0 else id
	return t if t.length() <= 34 else t.substr(0, 32).strip_edges() + "…"
