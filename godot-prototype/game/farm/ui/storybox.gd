extends RefCounted
class_name FarmUiStory
## The story on screen (TODO Phase 5.2): the story box (pages, one big button), speech bubbles that stay until tapped, and the 📜 scroll
## that lists what was read. WHICH piece is ready and how often is decided by G.story (game/farm/systems/story.gd); WHEN it shows is
## the interruption queue's (M.interrupts, order list in rules/65-feel.json): a story box when no pop-up, Rest, sheet, celebration or
## postcard is in the way (a Discovery may come over a sheet: you just tapped it), a bark when no other bubble is on screen.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")

const KIND_EMOJI := {"frame": "📖", "beat": "✨", "discovery": "🔎", "letter": "✉️", "moment": "💬", "visit": "🚶", "scene": "🏘️", "bark": "💬"}
const PICTURE_FOLDERS := ["story", "friends", "helpers", "ruins", "deco", "map"]

var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

var enabled := true            # tests and screenshots of other things switch the story off (--nostory)
var _then := ""                # what follows the box that is open ("welcome": the old welcome hints)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ when

## Asks the interruption queue for a pump once the current frame is over (many things ask; one pump runs).
func queue_pump() -> void:
	M.interrupts.request()

## Shows the next ready piece now if it is its turn (only story pieces; anything else waiting stays in line). True when one was shown.
func pump() -> bool:
	return M.interrupts.pump_story()

## The queue kind of a piece: a bark, a Discovery and a Scene have their own (both may come over a sheet: a Scene opens on the square
## right after the hand-over); every other piece is a "story" box.
func queue_kind(id: String) -> String:
	var kind := str(G.story.piece(id).get("kind", ""))
	return kind if kind in ["bark", "discovery", "scene"] else "story"

## The next ready piece of this queue kind as the interruption queue wants it ({"kind", "key", "show"}), or {}. One source per queue
## kind, so a Scene on the square is not held back by a story box that waits for the square to close (the order list ranks them).
func candidate(qkind := "") -> Dictionary:
	if not enabled or G == null: return {}
	for id in G.story.ready():
		var k := queue_kind(id)
		if qkind == "" or k == qkind: return {"kind": k, "key": id, "show": show_piece.bind(id)}
	return {}

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
	r.custom_minimum_size = Vector2(0, G.feel("story.pictureHeight"))      # a painted story scene (rules/65-feel.json)
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

# ------------------------------------------------------------------ news boxes (story/13, story/14)

## The first waiting news box (a change of season, a golden acorn, a favour done, a party) for the interruption queue, or {}.
func news_candidate() -> Dictionary:
	if not enabled or G == null: return {}
	var box: Dictionary = G.story.news_next()
	if box.is_empty(): return {}
	return {"kind": "news", "key": str(box.get("key", "")), "show": show_news.bind(box)}

## A news box: its picture big (assets/story, friends or album; else the emoji), the title, the text, a smaller line under it, one button.
func show_news(box: Dictionary, reread := false) -> void:
	if not reread: G.story.news_shown(str(box.get("key", "")))
	var m := M.modals.open_modal(str(box.get("title", "")))
	var pic := str(box.get("picture", ""))
	var tex: Texture2D = null
	if pic != "":
		for f in ["story", "friends", "album"]:
			tex = Art.first(f, [pic])
			if tex: break
	if tex: m.add_child(_scene_view(tex))
	else: m.add_child(UI.header(_picture("", pic), str(box.get("emoji", "✨")), 140, Color.WHITE, true))
	var text := str(box.get("text", ""))
	m.add_child(UI.label(text, 22, UI.INK, true))
	if str(box.get("more", "")) != "": m.add_child(UI.label(str(box["more"]), 17, UI.MUTED, true))
	if G.read_aloud_mode() != "off":
		m.add_child(UI.soft_button(tr("🔊 Read aloud"), M.timequiz.speak.bind(text), true, 17))
		if G.read_aloud_mode() == "auto": M.timequiz.speak.call_deferred(text)
	var go := UI.button(tr("Got it ✔"), M.modals.close_modal, true, UI.GREEN, 22)
	go.custom_minimum_size = Vector2(0, 62)
	m.add_child(go)

# ------------------------------------------------------------------ the scroll

## The 📜 scroll: everything read so far, a chapter at a time; a tap reads a piece again.
func sheet_scroll() -> void:
	var ids: Array = G.story.seen_in_order()
	if ids.is_empty() and G.seasons.season_no() < 1:
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
	_scroll_seasons()

## The season boxes seen so far (one per season reached: summer, autumn, winter, then spring), to read again (story/14).
func _scroll_seasons() -> void:
	var n := mini(G.seasons.season_no(), 4)
	if n < 1: return
	M.widgets.section(tr("Seasons"))
	for i in range(1, n + 1):
		var box: Dictionary = G.seasons.season_box(G.SEASON_NAMES[i % 4])
		var b := UI.soft_button("%s %s" % [box["emoji"], box["title"]], show_news.bind(box, true), true, 18)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
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
