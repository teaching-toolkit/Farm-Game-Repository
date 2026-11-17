extends RefCounted
class_name FarmUiInfo
## The short note on tap (interface-feel/01 and 02), one mechanism for three kinds of tap:
##   an item (its tile, or its little picture in a cost)      -> what it is, how many you have, its grades, how much room it takes
##   a bar (energy, water, bag, coins, and every `UI.explain` bar) -> the numbers, and what fills and what drains it
##   a greyed-out button                                       -> why it is grey and what it will need (the reason is the rule's own answer)
## The note is a small card with a picture or an emoji and few words, above everything (also above a pop-up), near what was tapped.
## It leaves by itself (rules/65-feel.json, notes.infoSecs), when it is tapped, or when anything else is tapped. Tap only, no hover.
## Read aloud as the settings say: "off" says nothing, "button" shows a 🔊, "auto" reads it as it opens.
## The kit (`kits/ui/ui.gd`) only reports taps (`UI.info`, `UI.grey`, `UI.explain`); this part knows what to say.

const UI = preload("res://kits/ui/ui.gd")

var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

var card: Control = null        # the note on the screen now (null: none)
var shown := {}                 # what the note says now: kind, icon, title, lines, spoken (for tests)
var spoken := ""                # the last text given to the voice
var _layer: Catcher
var _gen := 0                   # one number per note: the fade-out of an old note must not take a newer one away

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

## Wires the kit's three kinds of tap to this part (main.gd calls it once).
func connect_hooks() -> void:
	UI.explain_hook = explain
	UI.info_hook = on_info
	UI.grey_hook = on_grey

# ------------------------------------------------------------------ the card

## Shows a note. icon: a picture (Texture2D) or an emoji; title may be ""; lines are the few words; extra is a control under them
## (cubes, a cost); action = [label, callable] adds one button (the old job of a tapped bar). kind and `at` (what was tapped: the
## note sits just below or above it) are optional.
func note(icon: Variant, title: String, lines: Array, at: Control = null, extra: Control = null, kind := "", action := []) -> void:
	close()
	if _layer == null or not is_instance_valid(_layer):
		_layer = Catcher.new()
		_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
		_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_layer.outside.connect(close)
		M.add_child(_layer)
	M.move_child(_layer, M.get_child_count() - 1)          # above the pop-up and the notes
	var w := minf(520.0, M.size.x - 32.0)
	var c := PanelContainer.new()
	var st := UI.box(Color(1, 0.98, 0.9, 0.98), 16, Color("c9a96a"), 2, 12)
	st.shadow_color = Color(0, 0, 0, 0.22)
	st.shadow_size = 8
	c.add_theme_stylebox_override("panel", st)
	c.custom_minimum_size = Vector2(w, 0)
	c.mouse_filter = Control.MOUSE_FILTER_STOP
	var row := UI.hbox(10)
	c.add_child(row)
	if icon is Texture2D:
		var tr_ := TextureRect.new()
		tr_.texture = icon
		tr_.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr_.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr_.custom_minimum_size = Vector2(52, 52)
		tr_.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		tr_.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(tr_)
	else:
		var el := UI.label(str(icon), 40)
		el.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		el.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(el)
	var col := UI.vbox(4)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(col)
	var said: Array = []          # what is said aloud: the title, then the lines
	if title != "":
		var tl := UI.label(title, 21, UI.INK, true)
		tl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_child(tl)
		said.append(title)
	for t in lines:
		var l := UI.label(str(t), 17, UI.INK if title == "" and said.is_empty() else UI.MUTED, true)
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_child(l)
		said.append(str(t))
	if extra != null: col.add_child(extra)
	if action.size() == 2:
		var ab := UI.soft_button(str(action[0]), _do_action.bind(action[1]), true, 18)
		ab.custom_minimum_size = Vector2(0, 46)
		ab.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		col.add_child(ab)
	var text := _sentences(said)
	var mode := G.read_aloud_mode()
	if mode != "off":
		var sp := UI.soft_button("🔊", speak.bind(text), true, 18)
		sp.custom_minimum_size = Vector2(46, 40)
		sp.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		row.add_child(sp)
	_layer.add_child(c)
	_layer.card = c
	card = c
	_gen += 1
	shown = {"kind": kind, "icon": icon, "title": title, "lines": lines.duplicate(), "spoken": text, "action": action.size() == 2, "extra": extra != null}
	c.gui_input.connect(_on_card_input)
	_place(c, at)
	c.minimum_size_changed.connect(_place.bind(c, at))     # the words wrap once the card has its width: sit right again
	var gen := _gen
	var tw := c.create_tween()
	tw.tween_interval(G.feel("notes.infoSecs"))
	tw.tween_property(c, "modulate:a", 0.0, 0.5)
	tw.tween_callback(func(): if gen == _gen: close())
	if mode == "auto": speak.call_deferred(text)

func close() -> void:
	if card != null and is_instance_valid(card):
		card.get_parent().remove_child(card)
		card.queue_free()
	card = null
	if _layer != null and is_instance_valid(_layer): _layer.card = null

func is_open() -> bool:
	return card != null and is_instance_valid(card) and card.visible

func _on_card_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and not e.pressed: close()      # a tap on the note sends it away

func _do_action(job: Callable) -> void:
	close()
	job.call()

## Just below what was tapped (above it when the screen ends there), inside the screen; without `at`, in the middle under the top bar.
func _place(c: Control, at: Control) -> void:
	if not is_instance_valid(c): return
	var s := c.get_combined_minimum_size()
	c.size = s
	var vp := M.size
	var x := (vp.x - s.x) / 2.0
	var y := (M.hud_panel.size.y if M.hud_panel != null else 0.0) + 10.0
	if at != null and is_instance_valid(at):
		var r := at.get_global_rect()
		x = clampf(r.get_center().x - s.x / 2.0, 8.0, maxf(8.0, vp.x - s.x - 8.0))
		y = r.end.y + 8.0
		if M.hud_panel != null and M.hud_panel.get_global_rect().encloses(r): y = M.hud_panel.get_global_rect().end.y + 8.0      # a bar of the top bar: under the whole top bar
		if y + s.y > vp.y - 8.0: y = r.position.y - s.y - 8.0
	c.position = Vector2(x, maxf(8.0, y))

## The pieces of a note as one text for the voice: each a sentence of its own, without emojis.
func _sentences(parts: Array) -> String:
	var out := []
	for p in parts:
		var t := _speakable(str(p))
		if not _has_letters(t): continue            # a line of stars and numbers says nothing aloud
		out.append(t if t[t.length() - 1] in [".", "!", "?", ":"] else t + ".")
	return " ".join(PackedStringArray(out))

func _has_letters(t: String) -> bool:
	for i in range(t.length()):
		var cp := t.unicode_at(i)
		if (cp >= 0x41 and cp <= 0x5A) or (cp >= 0x61 and cp <= 0x7A) or cp >= 0xC0: return true
	return false

## What a voice should say: the words without the emojis and pictures' signs.
func _speakable(t: String) -> String:
	var out := ""
	for i in range(t.length()):
		var cp := t.unicode_at(i)
		if cp >= 0x2190 or cp == 0xFE0F: continue
		out += t[i]
	return out.strip_edges()

func speak(text: String) -> void:
	spoken = text
	M.timequiz.speak(text)

## An emoji at the start of a text is the note's picture: ["⚡", "Too tired."]; no emoji: [fallback, the text].
func split_icon(t: String, fallback := "ℹ️") -> Array:
	var sp := t.find(" ")
	if sp > 0 and t.unicode_at(0) >= 0x2190: return [t.substr(0, sp), t.substr(sp + 1)]
	return [fallback, t]

# ------------------------------------------------------------------ the three kinds of tap

## A bar that explains itself (`UI.explain`): its one line, its emoji as the picture.
func explain(text: String, at: Control = null) -> void:
	var p := split_icon(text)
	note(p[0], "", [p[1]], at, null, "explain")

## A tap on an item, a bar or a cost (`UI.info`). Bars are named like their keys: energy, water, coins, bag.
func on_info(kind: String, id: String, at: Control = null) -> void:
	if kind == "bar" or id in ["energy", "water", "coins"]: bar(id, at)
	elif id == "fuel": note("🔥", tr("Fuel"), [tr("The woodpile has %d. Ovens, kilns and the forge burn it.") % G.down(G.S["woodpile"]), tr("Stack wood on it from the store.")], at, null, "item")
	elif kind == "item": item(id, at, float(at.get_meta("info_need", 0.0)) if at != null else 0.0)

## What an item is: its name, a few words about it, how many you have (and what it needs), the grades, the room it takes in the bag.
func item(k: String, at: Control = null, need := 0.0) -> void:
	if k.begins_with("tag:"):          # "any flour": the things that will do
		var names := []
		for o in G.inventory.tag_choices(k.substr(4)): names.append("%s %s %d" % [G.iemoji(str(o)), G.iname(str(o)), G.down(G.inventory.count(str(o)))])
		note(G.iemoji(k), G.iname(k), [tr("Any of these will do:")] + names, at, null, "item")
		return
	if not G.items.has(k):
		var nd: Dictionary = G.nodes.get(k, {})
		note(str(nd.get("emoji", "•")), G.iname(k), [str(nd.get("desc", ""))] if str(nd.get("desc", "")) != "" else [], at, null, "item")
		return
	var it: Dictionary = G.items[k]
	var lines := []
	if str(it.get("desc", "")) != "": lines.append(str(it["desc"]))
	var q: float = G.inventory.count(k)
	if need > 0.0: lines.append(tr("It needs %d. You have %d.") % [G.up(need), G.down(q)])
	elif str(it.get("category", "")) != "keeper": lines.append(tr("You have %d.") % G.down(q))
	if G.quality.graded(k):          # how many of each grade: ⭐⭐⭐ 2  ⭐⭐ 5
		var gs: Dictionary = G.inventory.grades(k)
		var gk := gs.keys()
		gk.sort()
		gk.reverse()
		var parts := []
		for g in gk: parts.append("%s %d" % [G.quality.stars(int(g)), G.down(float(gs[g]))])
		if not parts.is_empty(): lines.append("   ".join(parts))
	if G.reveal.shown("bag"): lines.append(room_text(k))
	var pic: Texture2D = M.widgets.pic(k, 96)
	note(pic if pic != null else str(it.get("emoji", "📦")), str(it["name"]), lines, at, null, "item")

## How much room one of the item takes in the bag (whole numbers; the lightest things hardly any).
func room_text(k: String) -> String:
	var w: float = G.inventory.weight_of(k)
	if w < 0.25: return tr("🎒 Hardly any room in the bag.")
	return tr("🎒 Takes %s room in the bag.") % M.widgets.num(w)

## A bar: what it shows (the numbers), what fills it and what drains it. energy and water also offer what a tap used to do.
func bar(which: String, at: Control = null) -> void:
	match which:
		"energy":
			var cap: float = G.needs.energy_max()
			var e: float = float(G.S["energy"])
			note("⚡", tr("Energy"), [tr("You have %d of %d.") % [G.down(e), G.down(cap)], tr("Rest fills it up: answer sums."), tr("Every chore uses some.")], at,
				UI.stock_bar(e, cap, UI.item_color("energy"), 260), "energy", [tr("😴 Rest"), M.rest.go_rest])
		"water":
			var cap2: float = G.needs.water_cap()
			var wt: float = float(G.S["water"])
			note("💧", tr("Water"), [tr("You have %d of %d.") % [G.down(wt), G.down(cap2)], tr("Carry more from the pond or the well."), tr("Planting, cooking and animals use it.")], at,
				UI.stock_bar(wt, cap2, UI.item_color("water"), 260), "water", [tr("🪣 Get water"), M.sheets.open_spot.bind("well")])
		"bag":
			var cap3: float = G.trip.capacity()
			var used: int = ceili(G.trip.carry_fill() * cap3 - 0.0001)
			var how: String = tr("Selling and handing over make room. What you buy fills it for the way home.") if G.trip.at_square() else tr("What you pack with 🎒 fills it. Take it to the village.")
			note("🎒", tr("Your bag"), [tr("%d of %d room is used.") % [used, int(cap3)], how], at, UI.bar(G.trip.carry_fill(), 240, 12, UI.AMBER if G.trip.carry_fill() < 0.999 else UI.RED), "bag")
		"coins":
			var cur: Dictionary = G.meta.get("currency", {})
			var lines := [tr("You have %s.") % G.money(float(G.S["coins"]), true), tr("%d bronze make 1 gold.") % int(cur.get("bronzePerGold", 100)),
				tr("Selling in the village brings coins. Buying and building uses them.")]
			if G.lord.owed() > 0.0: lines.append(tr("🏮 The Lord's share comes first: %s") % G.money_up(G.lord.owed()))
			var pic: Texture2D = M.widgets.pic("coins", 96)
			note(pic if pic != null else "🪙", tr("Your coins"), lines, at, null, "coins")

## A greyed-out button was tapped: why, and what it will need. The reasons are what the rule that greyed it answered (the button carries
## them: `UI.button` with a rule's answer, or a sentence), so the button and its note cannot disagree.
func on_grey(b: Button) -> void:
	var why: Variant = b.get_meta("grey", null)
	var lines: Array = []
	var key := ""
	var cost := {}
	var base := {}
	if why is Dictionary:
		for u in why.get("unmet", []):
			if key == "": key = str(u.get("key", ""))
			var t := str(u.get("text", ""))
			if t == "": t = _key_text(str(u.get("key", "")))
			if t != "" and not lines.has(t): lines.append(t)
		cost = why.get("cost", {})
		base = why.get("base", cost)
	elif why is String:
		lines.append(why)
	if lines.is_empty(): lines.append(tr("🔒 Not right now."))
	var lead := split_icon(str(lines[0]), "🔒")
	lines[0] = lead[1]
	if lines.size() > 2: lines = lines.slice(0, 2)
	var short := false
	var mn := int(why.get("min", 0)) if why is Dictionary else 0      # a goal that takes a grade or better: ⭐⭐ on its things
	for k in cost:
		if (G.inventory.have(str(k), mn) if mn > 0 else M.widgets.have_any(str(k))) + 0.0001 < float(cost[k]): short = true
	M.feedback.sfx("tired" if key == "energy" else "tap")
	if key == "time": M.feedback.spark(b.get_global_rect().get_center(), M.quiz_btn)      # no time left: a spark flies to the clock
	note(lead[0], "", lines, b, M.widgets.costs(cost, base, mn) if short else null, "grey")

## The words for a reason that has none of its own (an unmet requirement with an empty text).
func _key_text(key: String) -> String:
	match key:
		"nothing_to_do", "no_animals": return tr("Nothing to do here right now.")
		"closed", "inside", "outside", "unknown": return tr("Not right now.")
	return ""

## Screenshots (`--note=…`): energy, water, bag, coins, item:stone, or grey (the first greyed-out button of the open sheet or pop-up).
func test_note(what: String) -> void:
	await M.get_tree().create_timer(0.4).timeout
	var parts := what.split(":")
	match parts[0]:
		"item": item(parts[1], M.hud_panel)
		"grey":
			var stack: Array = [M.modal_box if M.modal.visible else M.content]
			while not stack.is_empty():
				var n: Node = stack.pop_front()
				if n is Button and n.disabled and n.is_visible_in_tree():
					M.sheet_scroll.ensure_control_visible(n)
					await M.get_tree().process_frame
					on_grey(n)
					return
				stack.append_array(n.get_children())
		_:
			var at: Control = {"energy": M.energy_bar.get_parent().get_parent(), "water": M.water_bar.get_parent().get_parent(), "bag": M.bag_bar.get_parent(), "coins": M.lbl_coins}.get(parts[0])
			bar(parts[0], at)

## The note that is open: what it says (for tests).
func now() -> Dictionary:
	return shown if is_open() else {}

## Taps outside the note send it away (and go on to whatever was tapped).
class Catcher extends Control:
	signal outside
	var card: Control = null

	func _input(e: InputEvent) -> void:
		if card == null or not is_instance_valid(card): return
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT and not card.get_global_rect().has_point(e.position): outside.emit()
