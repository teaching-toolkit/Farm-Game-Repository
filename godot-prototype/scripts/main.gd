extends Control
## Farm Quiz Game — the farm-map interface, made for an iPad held upright (834×1194 design size).
## Tap a place on the map (house, kitchen, coop, market stall …) and a sheet slides up with everything you can do there.
## Pictures come from assets/ when they exist (see scripts/art.gd); emojis stand in for the rest.
const UI = preload("res://scripts/ui.gd")
const Art = preload("res://scripts/art.gd")
const Spots = preload("res://scripts/spots.gd")
const FieldView = preload("res://scripts/field_view.gd")
const MAP_SCENE = preload("res://farm_map.tscn")
const MapScript = preload("res://scripts/farm_map.gd")
const SlotScript = preload("res://scripts/slot.gd")

const GOAL_TYPES := ["building", "station", "tool", "gear", "helper", "land", "patch", "delivery", "pet", "sidequest"]
const ANIMALS := ["animal_chicken", "animal_cow", "animal_sheep", "animal_bees"]
const PETS := ["pet_bunny", "pet_tortoise", "pet_goat", "pet_pony", "pet_alpaca"]

var G
var bg: ColorRect
var lbl_coins: Label
var water_bar        # UI.CubeBar: water as cubes (with the number)
var energy_bar       # UI.CubeBar: energy as cubes; tapping it opens Rest
var season_bar       # UI.SeasonBar: the questions of this season
var season_emoji: Label
var _last_water := -1.0
var lbl_info: Label
var lbl_status: Label
var scroll: ScrollContainer
var map
var bottom: PanelContainer
var goal_btn: Button
var quiz_btn          # UI.ClockButton: the Time Quiz (an old clock; its hand goes round once when tapped)
var sheet: PanelContainer
var sheet_title: Label
var sheet_scroll: ScrollContainer
var content: VBoxContainer
var sheet_kind := ""
var sheet_h := 0.0
var _slide := 1.0
var toasts: VBoxContainer
var modal: Control
var modal_card: PanelContainer
var modal_box: VBoxContainer
var field_idx := 0        # the field whose patch was tapped last (the field sheet works on it)
var _interior_back := ""  # reopen this building's inside when the corner's sheet closes
var goal_id := ""
var _queued := false
var _scroll_tw: Tween
var shot_path := ""
var shot_frames := 0
var step_at := -1
var _fx_queue: Array = []      # things that arrived while a pop-up was open: they fly to the store when it closes
var _rest := {}               # the Rest pop-up: question, typed answer, when it was asked, its nodes
var _celebrations: Array = []  # new buildings, tools and helpers waiting for their big pop-up
var _last_fx := ""             # the celebration effect shown last time (the next one is different)
var _after_close: Array = []   # messages shown when the pop-up closes (rain …)
const Fx = preload("res://scripts/fx.gd")
const Pad = preload("res://learnkit/number_pad_quiz.gd")
var sfx                        # little sounds (perk "Farm sounds")
var _look_sig := "-"

func _ready() -> void:
	G = get_node("/root/Game")
	_setup_theme()
	_build()
	G.changed.connect(_queue_refresh)
	G.toast.connect(_toast)
	UI.explain_hook = _hint
	G.offer_cards.connect(_show_gift)
	G.sold.connect(_on_sold)
	sfx = Fx.Sfx.new()
	add_child(sfx)
	G.ask_name.connect(_show_name)
	G.gained.connect(_on_gained)
	G.celebrate.connect(_celebrate)
	for fv in map.fields: fv.patch_pressed.connect(_on_patch)
	map.spot_tapped.connect(_open_spot)
	resized.connect(_on_resized)
	_parse_args()
	_refresh()
	if G.player == "" and shot_path == "" and DisplayServer.get_name() != "headless":
		_ask_player()
	elif G.S["gift_pending"].size() > 0: _show_gift()
	elif G.S["step"] == 0 and not G.done("k_wheat"): _show_welcome()

## Andika (a font made for children learning to read) with Noto Color Emoji as fallback, so every device shows the same emojis.
func _setup_theme() -> void:
	var th := Theme.new()
	var emoji: Font = load("res://fonts/NotoColorEmoji.ttf")
	var base: Font
	var bold: Font
	if ResourceLoader.exists("res://fonts/Andika-Regular.ttf"):
		base = load("res://fonts/Andika-Regular.ttf")
		bold = load("res://fonts/Andika-Bold.ttf") if ResourceLoader.exists("res://fonts/Andika-Bold.ttf") else base
	else:
		var sf := SystemFont.new()
		sf.font_names = PackedStringArray(["Nunito", "Avenir Next", "Helvetica Neue", "Segoe UI", "Noto Sans", "DejaVu Sans", "Arial"])
		base = sf
		bold = sf
	if emoji:
		base.fallbacks = [emoji]
		if bold != base: bold.fallbacks = [emoji]
	th.default_font = base
	th.default_font_size = 18
	th.set_font("bold_font", "RichTextLabel", bold)
	theme = th

func _parse_args() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--shot="): shot_path = a.substr(7)
		elif a.begins_with("--demo="):
			for _i in range(int(a.substr(7))): G.cheat_max()
		elif a == "--quiz": call_deferred("_show_time_quiz")
		elif a.begins_with("--qid="): call_deferred("_show_quiz_id", a.substr(6))     # screenshots: one Time Quiz question
		elif a.begins_with("--lang="):                                               # screenshots: quiz texts in another language
			G.settings["language"] = a.substr(7)
			G.quiz_tr = G.quiz.load_texts("res://data/i18n/quiz-%s.json" % a.substr(7))
		elif a == "--rest": call_deferred("_show_rest")
		elif a.begins_with("--card="): call_deferred("_show_card", a.substr(7))
		elif a.begins_with("--patch="): call_deferred("_on_patch", "field", int(a.substr(8)))
		elif a.begins_with("--pests="): G.S["pests"] = float(a.substr(8))
		elif a.begins_with("--water="): G.S["water"] = float(a.substr(8))   # screenshots: carried water
		elif a.begins_with("--timestep="): G.S["step"] = int(a.substr(11))   # e.g. 95 = winter (screenshots only)
		elif a.begins_with("--stepat="): step_at = int(a.substr(9))
		elif a.begins_with("--sheet="): call_deferred("_open_sheet", a.substr(8))
		elif a.begins_with("--spot="): call_deferred("_open_spot", a.substr(7))
		elif a.begins_with("--scroll="): call_deferred("_scroll_to", float(a.substr(9)), false)
		elif a == "--goal": call_deferred("_goal_pressed")
		elif a == "--newgame": G.reset_game()      # screenshots of the very start
		elif a.begins_with("--player="): G.set_player(a.substr(9))
		elif a.begins_with("--celebrate="): call_deferred("_celebrate", a.substr(12))     # screenshots of the big pop-up
		elif a == "--postcard":                    # screenshots: a friend (Granny Maud) and her postcard
			G.S["unlocked"]["sq_lost_goat"] = true
			G._dirty()
			G.S["gift_pending"].clear()
			G.S["postcards"] = []
			G._offer_gift("your new bunny")
		elif a.begins_with("--perks="):            # screenshots: --perks=all or --perks=perk_rainbow,perk_breeze
			for p in G.meta.get("perks", {}).get("list", []):
				if a == "--perks=all" or a.substr(8).split(",").has(p["id"]): G.perks()[p["id"]] = true
		elif a == "--rainbow": call_deferred("_rainbow_now")
		elif a.begins_with("--unlock="):           # screenshots: pretend these are done (--unlock=workbench,stone_axe)
			for id in a.substr(9).split(","): G.S["unlocked"][id] = true
			G._dirty()
		elif a.begins_with("--give="):             # screenshots: --give=rope:2,stick:5
			for kv in a.substr(7).split(","):
				var parts: PackedStringArray = kv.split(":")
				G.add_item(parts[0], float(parts[1]) if parts.size() > 1 else 1.0, true)
		elif a == "--built":                       # screenshots: pretend house, barn and workshop stand
			for b in ["cottage", "barn_1", "workshop_1"]: G.S["unlocked"][b] = true
			G._dirty()

func _process(_d: float) -> void:
	if shot_path != "":
		shot_frames += 1
		if shot_frames == step_at: G.step_time()
		if shot_frames == 45:
			var img := get_viewport().get_texture().get_image()
			img.save_png(shot_path)
			print("saved ", shot_path)
			get_tree().quit()

# ------------------------------------------------------------------ layout
func _build() -> void:
	bg = ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = UI.BG
	add_child(bg)
	var root := UI.vbox(0)
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)
	# --- top bar (HUD)
	var hud := PanelContainer.new()
	var hs := UI.box(UI.PAPER, 0, UI.LINE, 0, 12)
	hs.border_width_bottom = 2
	hs.border_color = UI.LINE
	hud.add_theme_stylebox_override("panel", hs)
	root.add_child(hud)
	var hv := UI.vbox(2)
	hud.add_child(hv)
	var r1 := UI.hbox(10)
	hv.add_child(r1)
	lbl_coins = UI.label("", 22); r1.add_child(lbl_coins)
	var wp = UI.TapPanel.new()
	wp.add_theme_stylebox_override("panel", UI.box(Color("dcecf6"), 10, Color("9fc3dc"), 1, 6))
	wp.tooltip_text = "Water: tap to carry more from the pond or the well."
	var wbox := UI.hbox(3)
	wbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wbox.add_child(UI.label("💧", 20))
	water_bar = UI.stock_bar(0.0, 10.0, UI.item_color("water"), 150)
	wbox.add_child(water_bar)
	wbox.add_child(UI.label("🪣", 18))
	wp.add_child(wbox)
	wp.pressed.connect(_open_spot.bind("well"))
	r1.add_child(wp)
	var ep = UI.TapPanel.new()
	ep.add_theme_stylebox_override("panel", UI.box(Color("dbe8f4"), 10, Color("9fbbd6"), 1, 6))
	ep.tooltip_text = "Rest: answer sums to get energy back (sleep, food, a sip of water)."
	var ebox := UI.hbox(3)
	ebox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ebox.add_child(UI.label("⚡", 20))
	energy_bar = UI.stock_bar(0.0, 20.0, UI.item_color("energy"), 150)
	ebox.add_child(energy_bar)
	ebox.add_child(UI.label("😴", 18))
	ep.add_child(ebox)
	ep.pressed.connect(_show_rest)
	r1.add_child(ep)
	r1.add_child(UI.spacer())
	for pair in [["🎒", _open_pantry, "Pantry: what you have"], ["📖", _open_goals, "Quest book: everything you can do next"],
			["🖼️", _open_album, "Album: pets, friends, postcards, perks, acorns"], ["⚙️", _show_menu, "Settings"]]:
		var b := UI.soft_button(pair[0], pair[1], true, 22)
		b.custom_minimum_size = Vector2(50, 46)
		b.tooltip_text = pair[2]
		r1.add_child(b)
	var r2 := UI.hbox(8)
	hv.add_child(r2)
	season_emoji = UI.label("", 18); r2.add_child(season_emoji)
	season_bar = UI.SeasonBar.new(); r2.add_child(season_bar)
	UI.explain(season_bar, "🗓️ The season: one mark per Time Quiz question. The number = questions until the next season.")
	lbl_info = UI.label("", 15, UI.MUTED); r2.add_child(lbl_info)
	lbl_status = UI.label("", 15, UI.MUTED); r2.add_child(lbl_status)
	r2.add_child(UI.spacer())
	if G.settings.get("showCheatButton", true):
		var cb := UI.button("⏩ Cheat", _cheat, true, UI.AMBER, 14)
		cb.custom_minimum_size = Vector2(0, 30)
		cb.tooltip_text = "Testing only: lets time pass until everything growing or cooking is done, then fills energy and water."
		r2.add_child(cb)
		var cc := UI.button("🪙+100", func(): G.cheat_coins(100), true, UI.AMBER, 14)
		cc.custom_minimum_size = Vector2(0, 30)
		r2.add_child(cc)
	# --- the farm map: one screen, scaled to fit (it only moves up when a sheet covers the bottom)
	scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	root.add_child(scroll)
	map = MAP_SCENE.instantiate()
	map.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(map)
	scroll.resized.connect(func(): map.fit(scroll.size))
	# --- bottom bar: next goal + the Time Quiz
	bottom = PanelContainer.new()
	var bs := UI.box(UI.PAPER, 0, UI.LINE, 0, 12)
	bs.border_width_top = 2
	bs.border_color = UI.LINE
	bs.content_margin_bottom = 14
	bottom.add_theme_stylebox_override("panel", bs)
	root.add_child(bottom)
	var bh := UI.hbox(10)
	bottom.add_child(bh)
	goal_btn = UI.soft_button("", _goal_pressed, true, 18)
	goal_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	goal_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	goal_btn.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	goal_btn.custom_minimum_size = Vector2(0, 60)
	bh.add_child(goal_btn)
	var qp := PanelContainer.new()
	qp.add_theme_stylebox_override("panel", UI.box(UI.GREEN, 40, Color(0, 0, 0, 0), 0, 4))
	quiz_btn = UI.ClockButton.new()
	quiz_btn.custom_minimum_size = Vector2(72, 72)
	quiz_btn.tooltip_text = "Time Quiz: every right answer moves farm time one step."
	quiz_btn.pressed.connect(_show_time_quiz)
	qp.add_child(quiz_btn)
	bh.add_child(qp)
	# --- the sheet that slides up from the bottom
	sheet = PanelContainer.new()
	var ss := UI.box(UI.PAPER, 0, UI.LINE, 2, 14)
	ss.corner_radius_top_left = 22
	ss.corner_radius_top_right = 22
	ss.border_width_bottom = 0
	ss.shadow_color = Color(0, 0, 0, 0.18)
	ss.shadow_size = 10
	sheet.add_theme_stylebox_override("panel", ss)
	sheet.visible = false
	add_child(sheet)
	var sv := UI.vbox(6)
	sheet.add_child(sv)
	var grip := ColorRect.new()
	grip.color = UI.LINE
	grip.custom_minimum_size = Vector2(60, 5)
	grip.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	sv.add_child(grip)
	var sh := UI.hbox(8)
	sv.add_child(sh)
	sheet_title = UI.label("", 23)
	sheet_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sheet_title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	sh.add_child(sheet_title)
	var close := UI.soft_button("✖", _close_sheet, true, 20)
	close.custom_minimum_size = Vector2(52, 44)
	sh.add_child(close)
	sheet_scroll = ScrollContainer.new()
	sheet_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sheet_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sv.add_child(sheet_scroll)
	content = UI.vbox(8)
	sheet_scroll.add_child(content)
	# --- toasts and the centred pop-up (quizzes, Rest, cards, gifts)
	toasts = UI.vbox(4)
	toasts.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(toasts)
	modal = Control.new()
	modal.set_anchors_preset(Control.PRESET_FULL_RECT)
	modal.visible = false
	add_child(modal)
	var dim := ColorRect.new()
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.1, 0.08, 0.05, 0.45)
	modal.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	modal.add_child(center)
	modal_card = UI.card(UI.PAPER, UI.LINE)
	center.add_child(modal_card)
	var msc := ScrollContainer.new()
	msc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	modal_card.add_child(msc)
	modal_box = UI.vbox(10)
	msc.add_child(modal_box)

func _on_resized() -> void:
	if sheet.visible: _fit_sheet()
	if modal.visible: _fit_modal()

func _queue_refresh() -> void:
	if _queued: return
	_queued = true
	call_deferred("_refresh")

func _refresh() -> void:
	_queued = false
	var S: Dictionary = G.S
	lbl_coins.text = "🪙 %d" % G.down(S["coins"])
	water_bar.have = float(S["water"]); water_bar.cap = G.water_cap(); water_bar.refresh()
	energy_bar.have = float(S["energy"]); energy_bar.cap = G.energy_max(); energy_bar.refresh()
	season_emoji.text = G.season_emoji()
	map.set_perks({"butterflies": G.perk_on("perk_butterflies"), "sparkles": G.perk_on("perk_sparkles"),
		"rainbow": G.perk_on("perk_rainbow"), "breeze": G.perk_on("perk_breeze")})
	var lk: Dictionary = S.get("look", {})
	var ls := JSON.stringify(lk)
	if ls != _look_sig and map.avatar:
		_look_sig = ls
		map.avatar.set_look(lk)
	var nxt_no: int = (G.season_no() + 1) % 4
	var nxt_emoji := str(G.meta.get("seasons", {}).get("mods", {}).get(G.SEASON_NAMES[nxt_no], {}).get("emoji", ""))
	var slen: int = G.season_len()
	season_bar.set_state(G.season(), slen, slen - G.questions_left_in_season(), "→ " + nxt_emoji)
	quiz_btn.show_time(float(slen - G.questions_left_in_season()) / float(slen))
	var ch: Dictionary = G.D["chapters"][G.chapter() - 1]
	lbl_info.text = "Chapter %d · %s · question %d%s" % [G.chapter(), ch["name"], S["step"], "  🌧️" if S.get("rain", false) else ""]
	# out of water: say so with a picture (once, when it runs out)
	if _last_water >= 1.0 and float(S["water"]) < 1.0 and not modal.visible: call_deferred("_show_no_water")
	_last_water = float(S["water"])
	var st := []
	if G.buff_mult() < 1.0: st.append("😋 −%d%% energy" % int(round((1.0 - G.buff_mult()) * 100)))
	if S.get("cold", false): st.append("❄️🏠 cold house")
	if G.luck() >= 0.2: st.append("🍀")
	if G.S["reading"] != "": st.append("📖 reading")
	lbl_status.text = "  ".join(st)
	bg.color = UI.SEASON_BG.get(G.season(), UI.BG)
	map.set_season(G.season(), _fence_level())
	# fields, add-ons and the house yard
	field_idx = clampi(field_idx, 0, maxi(0, G.field_names().size() - 1))
	map.refresh_fields(G)
	map.refresh_addons(G)
	map.set_house_built(_built("home"))
	# places on the map
	goal_id = _next_goal()
	for sid in map.slots: _update_slot(sid)
	map.set_road_badge(_badge("road"))
	map.set_critters(_critter_spec())
	map.set_cat(G.done("barn_cat"))
	_update_goal_bar()
	if sheet.visible:
		_rebuild_sheet()
		call_deferred("_fit_sheet")

func _fence_level() -> int:
	var lv := 0
	for i in range(1, MapScript.FENCES.size()):
		if G.satisfied(MapScript.FENCES[i][0]): lv = i
	return lv

func _clear(c: Node) -> void:
	for k in c.get_children():
		c.remove_child(k)
		k.queue_free()

func _cheat() -> void:
	G.cheat_max()

# ------------------------------------------------------------------ places on the map
## The newest thing built at a place (its picture and name stand for the place).
func _headline(sid: String) -> String:
	var best := ""
	if map.slots.has(sid):
		for id in Spots.ART_CHAINS.get(sid, []):
			if G.nodes.has(id) and G.done(id): best = id
	if best != "": return best
	# buildings and land stand for a place before its animals, and animals before its machines
	var rank := {"building": 3, "land": 3, "merchant": 3, "pet": 3, "animal": 2, "station": 1}
	var best_k := -1
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not rank.has(n["type"]): continue
		if not G.done(id) or G.superseded(id): continue
		var k: int = rank[n["type"]] * 100 + int(n.get("chapter", 1))
		if k >= best_k:
			best_k = k; best = id
	return best

func _spot_title(sid: String) -> String:
	if sid == "field":
		var names: Array = G.field_names()
		return names[clampi(field_idx, 0, names.size() - 1)] if names.size() > 0 else "Field"
	var info: Array = Spots.SPOTS.get(sid, [sid.capitalize(), "❔"])
	var parent := Spots.parent_of(sid)
	if parent != "" and _built(parent): return info[0]      # a corner inside a building: "Bed & home", "Kitchen" …
	var head := _headline(sid)
	if head != "":
		var nm := str(G.nodes[head]["name"])
		if nm.length() <= 14: return nm
	return info[0]

func _spot_emoji(sid: String) -> String:
	var parent := Spots.parent_of(sid)
	if parent != "" and _built(parent): return Spots.SPOTS.get(sid, ["", "❔"])[1]
	var head := _headline(sid)
	if head != "": return str(G.nodes[head].get("emoji", Spots.SPOTS.get(sid, ["", "❔"])[1]))
	return Spots.SPOTS.get(sid, ["", "❔"])[1]

func _is_open(sid: String) -> bool:
	return _headline(sid) != "" or Spots.ALWAYS_OPEN.has(sid)

## Does a building with an inside stand yet (house, barn, workshop)?
func _built(parent: String) -> bool:
	if not Spots.INTERIORS.has(parent): return false
	var b: String = Spots.INTERIORS[parent]["built"]
	return G.nodes.has(b) and G.satisfied(b)

## The place on the map that stands for sid: a corner inside a building shows as the building once it stands.
func _map_sid(sid: String) -> String:
	var parent := Spots.parent_of(sid)
	if parent != "" and (_built(parent) or not map.slots.has(sid)): return parent
	return sid

## First picture name of keys that exists in folder ("" if none).
func _first_key(folder: String, keys: Array) -> String:
	for k in keys:
		if str(k) != "" and Art.tex(folder, str(k)) != null: return str(k)
	return ""

## Picture names to try for a place: the newest thing built, then the earlier upgrades (so an upgrade without
## its own picture keeps the last one), then the place itself.
func _art_keys(sid: String) -> Array:
	var head := _headline(sid)
	var keys := [head]
	if map.slots.has(sid):
		var chain: Array = Spots.ART_CHAINS.get(sid, [])
		var at := chain.find(head)
		for i in range(at - 1, -1, -1): keys.append(chain[i])
	keys.append(sid)
	return keys

func _update_slot(sid: String) -> void:
	var slot = map.slots[sid]
	# the house: the yard with tent, book box and campfire until the house stands, then the house alone
	if sid == "home":
		slot.visible = _built("home")
	elif Spots.parent_of(sid) == "home":
		slot.visible = not _built("home")
	if not slot.visible: return
	slot.show_name = bool(G.settings.get("showPlaceNames", false))
	var open := _is_open(sid) or (Spots.INTERIORS.has(sid) and _built(sid))
	var key := ""
	var tex: Texture2D = null
	var st := ""
	var lk := {}
	if sid == "forest":
		st = "ghost"                                   # the trees are the place
	elif sid == "pond":
		var dug: bool = G.done("pond")
		key = "pond" if dug else "pond_wild"
		tex = Art.tex("plots", key)
		st = "pond"
		lk = {"wild": not dug}
	elif Spots.PENS.has(sid):
		st = "pen"                                     # a generic fence and ground; what is built stands inside
		lk = Spots.PENS[sid]
		slot.inside = _pen_inside(sid) if open else []
	elif open and _headline(sid).begins_with("ruins_"):
		st = "ruin"                                    # the old walls are cleared away: bare earth, ready to build on
		lk = {"material": Spots.RUINS.get(sid, "stone"), "cleared": true}
	elif open and _site_stage(sid) > 0 and _first_key("map", _art_keys(sid).filter(func(k): return G.nodes.has(k) and G.done(k))) == "":
		var stage := _site_stage(sid)                  # a building site: foundation, frame, walls … as the steps are done
		key = "site_%d" % stage
		tex = Art.first("construction", ["stage_%d" % stage, "stage_1"])
		if tex == null:
			st = "ruin"
			lk = {"material": "stone", "cleared": true}
	elif open:
		key = _first_key("map", _art_keys(sid))
		tex = Art.tex("map", key) if key != "" else null
		if key == "workbench" and Art.tex("map", "workbench_empty"):
			tex = Art.tex("map", "workbench_empty")        # the bench is empty; what has been made lies on it
	elif sid == "kitchen":
		st = "fireplace"                               # before the campfire: a few blackened rocks and a burnt log, no ruin
	elif Spots.RUINS.has(sid):
		st = "ruin"                                    # what is left of it: broken walls, rubble — less as it is cleared
		lk = {"material": Spots.RUINS[sid]}
		var rid := "ruins_" + sid
		if G.nodes.has(rid):
			lk["progress"] = float(G.step_index(rid)) / float(maxi(1, G.steps_of(rid).size()))
			lk["cleared"] = G.done(rid)
	else:
		st = "ghost"                                   # nothing there yet (the book cart has not come)
	slot.overlays = _bench_things() if key == "workbench" else []
	slot.set_state(_spot_title(sid), _spot_emoji(sid), tex, not open, _badge(sid), key, st, lk)

## How far a building at this place has come (1 … 5), or 0 when nothing is being built there.
func _site_stage(sid: String) -> int:
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not (n["type"] in ["building", "station"]) or G.done(id): continue
		var st: Array = G.steps_of(id)
		var i: int = G.step_index(id)
		if st.size() > 0 and i > 0: return clampi(1 + int(float(i) / float(st.size()) * 5.0), 1, 5)
	return 0

## What has been made so far, lying on the workbench (tools; rope once there is some).
func _bench_things() -> Array:
	var out := []
	for b in Spots.BENCH:
		var have: bool = G.count(str(b["id"])) >= 1.0 if b.get("item", false) else (G.nodes.has(b["id"]) and G.satisfied(b["id"]))
		var t: Texture2D = Art.tex("tools", str(b["pic"]))
		if have and t: out.append({"tex": t, "x": b["x"], "y": b["y"], "w": b["w"]})
	return out

## What stands inside a pen or garden besides its add-ons: the orchard's trees.
func _pen_inside(sid: String) -> Array:
	var out := []
	if sid == "orchard":
		var tree: Texture2D = Art.tex("deco", "tree_oak")
		for p in G.area("orchard"):
			if p["crop"] == "": out.append({"hole": true, "w": 30.0})
			else: out.append({"tex": Art.tex("crops", str(p["crop"])) if Art.tex("crops", str(p["crop"])) else tree, "w": 46.0 if p["ready"] else 38.0})
	return out

## A locked place with nothing to do yet: it only shows a mysterious sign and a promise.
func _mystery(sid: String) -> bool:
	if _is_open(sid) or (Spots.INTERIORS.has(sid) and _built(sid)): return false
	var lists := _goal_lists(sid)
	if not lists[0].is_empty() or not lists[1].is_empty(): return false
	for aid in Spots.nodes_at(G, sid):
		if G.nodes[aid]["type"] == "animal" and (G.done(aid) or G.missing_reqs(aid).is_empty()): return false
	return true

## Is a node part of the story so far (its chapter is now or earlier)? Sheets never show what lies beyond.
func _in_chapter(id: String) -> bool:
	return int(G.nodes.get(id, {}).get("chapter", 1)) <= G.chapter()

# ------------------------------------------------------------------ things flying to the store
func _on_gained(source: String, got: Dictionary, lost: Dictionary = {}) -> void:
	if source.begins_with("patch:") and not got.is_empty(): _sfx("pop")
	var pieces := []
	var bounce := []
	for k in got:
		var q := float(got[k])
		if q < 0.01: continue
		for _i in range(clampi(int(round(q)), 1, 12)): pieces.append([G.iemoji(k), Art.first("items", [k])])
	for k in lost:
		var q2 := float(lost[k])
		if q2 < 0.01: continue
		for _i in range(clampi(int(round(q2)), 1, 8)): bounce.append([G.iemoji(k), Art.first("items", [k])])
	if pieces.is_empty() and bounce.is_empty(): return
	var job := [_source_point(source), "well" if got.has("water") else "storage", pieces, bounce]
	if modal.visible: _fx_queue.append(job)
	else: map.fly(job[0], job[1], job[2], job[3])

func _source_point(source: String) -> Vector2:
	var parts := source.split(":")
	match parts[0]:
		"patch":
			if parts[1] == "field": return map.patch_point(int(parts[2]) / 9, int(parts[2]) % 9)
			return map.spot_point("orchard" if parts[1] == "orchard" else "greenhouse")
		"animal": return map.spot_point(_map_sid(Spots.spot_of(G, parts[1])))
		"recipe":
			var st: String = G.recipes[parts[1]]["station"]
			return map.spot_point(_map_sid(Spots.spot_of(G, st)))
		"water": return map.spot_point("pond")
		"node":
			var nid: String = parts[1]
			if G.nodes.has(nid) and G.nodes[nid].get("effects", {}).get("add", {}).has("plots"):
				var nxt: int = G.plots()                     # the patches being cleared
				return map.patch_point(nxt / 9, nxt % 9 + 1 if nxt % 9 < 8 else nxt % 9)
			return map.spot_point(_map_sid(Spots.spot_of(G, nid)))
	return map.spot_point("storage")

## What happened behind a pop-up plays when the farm is visible again.
func _play_fx() -> void:
	map.play_pending()
	for job in _fx_queue: map.fly(job[0], job[1], job[2], job[3])
	_fx_queue.clear()

## Small sign on a place: something to build (🔨), animals ready (🧺), a card quiz (❓), food going stale (🍂) …
func _badge(sid: String) -> String:
	if Spots.INTERIORS.has(sid) and _built(sid):
		for m in Spots.INTERIORS[sid]["members"]:
			var bm := _badge(m)
			if bm != "": return bm
		return ""
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not (n["type"] in GOAL_TYPES) or n.get("optional", false): continue
		if G.done(id) or G.satisfied(id): continue
		if G.can_unlock(id)["ok"]:
			match n["type"]:
				"delivery": return "📦"
				"sidequest": return "🤝"
				"pet": return "🐾"
				_: return "🔨"
	match sid:
		"library":
			for cid in G.card_ids:
				if G.card_status(cid) == "quiz": return "❓"
			if G.S["reading"] == "":
				for cid in G.card_ids:
					if G.card_status(cid) == "readable": return "📖"
		"storage":
			for k in G.S["inv"]:
				if G.stale_soon(k) >= 1.0: return "🍂"
		"living":
			if float(G.S["energy"]) < G.energy_max() * 0.25: return "😴"
	for aid in Spots.nodes_at(G, sid):
		if G.nodes[aid]["type"] == "animal" and G.S["animals"].has(aid):
			var a: Dictionary = G.S["animals"][aid]
			if int(a["count"]) > 0 and G.S["step"] >= int(a["ready"]): return "🧺"
	var busy := 0
	for root in G.S["running"]:
		if Spots.in_spot(G, root, sid): busy += G.S["running"][root].size()
	if busy > 0: return "⏳"
	return ""

func _critter_spec() -> Dictionary:
	var spec := {}
	for aid in ANIMALS:
		if not G.nodes.has(aid) or not G.S["animals"].has(aid): continue
		var c := int(G.S["animals"][aid]["count"])
		if c <= 0: continue
		var arr := []
		for _i in range(mini(4, c)): arr.append([G.nodes[aid].get("emoji", "🐾"), Art.tex("animals", aid), aid])
		spec[Spots.spot_of(G, aid)] = arr
	var pets := []
	for pid in PETS:
		if G.done(pid): pets.append([G.nodes[pid].get("emoji", "🐾"), Art.tex("animals", pid), pid])
	if pets.size() > 0: spec["pets"] = pets
	return spec

func _next_goal() -> String:
	var best := ""
	var bk := 1 << 30
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		var t: String = n["type"]
		if t in ["knowledge", "book", "polish", "animal", "crop", "merchant", "sidequest"]: continue
		if n.get("optional", false) or G.done(id) or G.satisfied(id): continue
		if not G.missing_reqs(id).is_empty(): continue
		var k := int(n.get("chapter", 1)) * 10 + (0 if G.can_unlock(id)["ok"] else 1)
		if k < bk:
			bk = k; best = id
	return best

func _readable_card() -> String:
	for cid in G.card_ids:
		if G.card_status(cid) in ["quiz", "readable"]: return cid
	return ""

func _update_goal_bar() -> void:
	if goal_id != "":
		var n: Dictionary = G.nodes[goal_id]
		var ok: bool = G.can_unlock(goal_id)["ok"]
		var c: Dictionary = G.node_cost(goal_id)
		goal_btn.text = "%s %s %s   %s" % ["✅" if ok else "🎯", n.get("emoji", ""), n["name"], G.cost_text(c) if not c.is_empty() else ""]
	elif _readable_card() != "":
		goal_btn.text = "🎯 📚 Learn a new card in the library"
	else:
		goal_btn.text = "🎯 Answer Time Quiz questions — things grow while you learn"

func _goal_pressed() -> void:
	if goal_id != "":
		var sid := Spots.spot_of(G, goal_id)
		_open_sheet_for(sid)
		_pulse(sid)
	elif _readable_card() != "":
		_open_sheet_for("library")
		_pulse("library")
	else:
		_show_time_quiz()

func _pulse(sid: String) -> void:
	var ms := _map_sid(sid)
	if map.slots.has(ms) and map.slots[ms].visible: map.slots[ms].pulse()

# ------------------------------------------------------------------ scrolling the map
func _scroll_to(y: float, smooth := true) -> void:
	var maxv := maxf(0.0, map.size.y - scroll.size.y)
	var t := clampf(y, 0.0, maxv)
	if _scroll_tw: _scroll_tw.kill()
	if not smooth:
		scroll.scroll_vertical = int(t)
		return
	_scroll_tw = create_tween()
	_scroll_tw.tween_property(scroll, "scroll_vertical", int(t), 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

## Scrolls so that a rectangle of the map is visible above the sheet.
func _reveal(r: Rect2) -> void:
	if r.size.y <= 0.0: return
	var visible_h := scroll.size.y - (sheet_h if sheet.visible else 0.0)
	var top := float(scroll.scroll_vertical)
	if r.position.y >= top + 6.0 and r.end.y <= top + visible_h - 6.0: return
	_scroll_to(r.position.y - maxf(12.0, (visible_h - r.size.y) * 0.25))

# ------------------------------------------------------------------ the sheet
## A tap on a place: a building with an inside opens its inside, everything else its sheet.
func _open_spot(sid: String) -> void:
	if Spots.INTERIORS.has(sid) and _built(sid):
		_open_interior(sid)
		return
	_open_sheet_for(sid)

## The sheet of a place or of a corner inside a building. Before a barn or workshop stands, its corners share one sheet.
func _open_sheet_for(sid: String) -> void:
	var parent := Spots.parent_of(sid)
	var target := sid
	if parent != "" and parent != "home" and not _built(parent): target = parent
	_open_sheet("spot:" + target)
	get_tree().create_timer(0.1).timeout.connect(_reveal_spot.bind(target))

func _reveal_spot(sid: String) -> void:
	_reveal(map.spot_rect(_map_sid(sid)))

# ------------------------------------------------------------------ inside a building
## A window over the farm (the farm stays visible, dimmed, behind it) with the building's inside: every corner
## (bed, books, kitchen; cellar, crocks …; benches, kiln & forge …) is tappable and opens its own sheet.
func _open_interior(parent: String) -> void:
	var info: Dictionary = Spots.INTERIORS[parent]
	var box := _open_modal("%s %s" % [_spot_emoji(parent), _spot_title(parent)])
	var w := _modal_w() - 40.0
	var bg_tex: Texture2D = Art.tex("interiors", str(info["art"]))
	var h := w * 0.8
	if bg_tex: h = w * float(bg_tex.get_height()) / float(bg_tex.get_width())
	var room := Control.new()
	room.custom_minimum_size = Vector2(w, h)
	room.mouse_filter = Control.MOUSE_FILTER_PASS
	box.add_child(room)
	if bg_tex:
		var tr := TextureRect.new()
		tr.texture = bg_tex
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_SCALE
		tr.size = Vector2(w, h)
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		room.add_child(tr)
	else:
		room.draw.connect(_draw_room.bind(room))
	var spots: Dictionary = map.L.get("interiors", {}).get(parent, {})
	var corners := []
	for m in info["members"]:
		var at: Dictionary = spots.get(m, {"x": 0.5, "y": 0.6, "w": 0.2})
		corners.append([float(at.get("y", 0.6)), m, at])
	corners.sort_custom(func(a, b): return a[0] < b[0])
	for c in corners:
		var m: String = c[1]
		var at: Dictionary = c[2]
		var cw := float(at.get("w", 0.2)) * w
		var s = SlotScript.new()
		s.setup(m, Vector2(float(at.get("x", 0.5)) * w, float(at.get("y", 0.6)) * h), cw, Vector2i(1, 1), cw * 0.9)
		room.add_child(s)
		var keys: Array = Spots.HOTSPOT_ART.get(m, []).filter(func(id): return G.nodes.has(id) and G.done(id))
		keys.reverse()
		var key := _first_key("interior", keys)
		var tex: Texture2D = Art.tex("interior", key) if key != "" else null
		if tex == null:
			key = _first_key("map", keys)
			tex = Art.tex("map", key) if key != "" else null
		var open := _is_open(m) or m in ["barn_build", "ws_build"]
		var info2: Array = Spots.SPOTS.get(m, [m.capitalize(), "❔"])
		s.set_state(info2[0], info2[1], tex, not open, _badge(m), key)
		s.tapped.connect(_enter_corner.bind(parent))
	if parent == "workshop" and G.nodes.has("tool_rack") and G.done("tool_rack"):
		var rack: Dictionary = spots.get("ws_tools", {"x": 0.5, "y": 0.5, "w": 0.2})
		var tools := []
		for b in Spots.BENCH:
			if b.get("item", false) or not G.nodes.has(b["id"]) or not G.satisfied(b["id"]): continue
			var tt: Texture2D = Art.tex("tools", str(b["pic"]))
			if tt: tools.append(tt)
		for ti in range(tools.size()):
			var tr2 := TextureRect.new()
			tr2.texture = tools[ti]
			tr2.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr2.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr2.rotation = -PI / 2.0                       # hanging handle down
			var tw2 := w * 0.07
			tr2.size = Vector2(tw2 * 1.6, tw2)
			tr2.pivot_offset = tr2.size / 2.0
			tr2.position = Vector2((float(rack["x"]) - 0.12 + ti * 0.035) * w, (float(rack["y"]) - 0.22) * h)
			tr2.mouse_filter = Control.MOUSE_FILTER_IGNORE
			room.add_child(tr2)
	box.add_child(UI.label("Tap a corner to see what you can do there.", 15, UI.MUTED, true))
	_fit_modal()

## Placeholder inside (until assets/interiors/<name>.png exists): a floor diamond and two back walls.
func _draw_room(room: Control) -> void:
	var w := room.size.x
	var h := room.size.y
	var top := Vector2(w / 2.0, h * 0.22)
	var lft := Vector2(0, h * 0.6)
	var rgt := Vector2(w, h * 0.6)
	var bot := Vector2(w / 2.0, h * 0.98)
	var up := Vector2(0, -h * 0.2)
	room.draw_colored_polygon(PackedVector2Array([lft + up, top + up, top, lft]), Color("efe3c8"))
	room.draw_colored_polygon(PackedVector2Array([top + up, rgt + up, rgt, top]), Color("e6d6b4"))
	room.draw_colored_polygon(PackedVector2Array([top, rgt, bot, lft]), Color("d9b98a"))
	room.draw_polyline(PackedVector2Array([lft + up, top + up, rgt + up, rgt, bot, lft, lft + up]), Color("8a6a44"), 3.0)
	room.draw_line(top + up, top, Color("8a6a44"), 3.0)

func _enter_corner(m: String, parent: String) -> void:
	_close_modal()
	_open_sheet("spot:" + m)
	_interior_back = parent

func _open_pantry() -> void: _open_spot("storage")
func _open_goals() -> void: _open_sheet("goals")
func _open_album() -> void: _open_sheet("album")

func _open_sheet(kind: String) -> void:
	_interior_back = ""
	var was := sheet.visible
	sheet_kind = kind
	sheet_scroll.scroll_vertical = 0
	sheet.visible = true
	_rebuild_sheet()
	_fit_sheet()
	call_deferred("_fit_sheet")
	get_tree().create_timer(0.06).timeout.connect(_fit_sheet)
	if not was:
		_slide = 0.0
		var tw := create_tween()
		tw.tween_method(_set_slide, 0.0, 1.0, 0.22).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

## 0 = hidden below the screen, 1 = fully up (used for the slide-in).
func _set_slide(v: float) -> void:
	_slide = v
	_place_sheet()

func _close_sheet() -> void:
	sheet.visible = false
	sheet_kind = ""
	sheet_h = 0.0
	map.set_extra_bottom(0.0)
	_clear(content)
	if _interior_back != "":
		var p := _interior_back
		_interior_back = ""
		_open_interior(p)

## The sheet grows with its content, up to 60% of the screen, and always leaves the bottom bar visible.
func _fit_sheet() -> void:
	if not sheet.visible: return
	var want := content.get_combined_minimum_size().y + 96.0
	sheet_h = clampf(want, 240.0, size.y * 0.6)
	_place_sheet()
	map.set_extra_bottom(sheet_h)
	_place_toasts()

func _place_sheet() -> void:
	var bottom_h: float = bottom.size.y
	sheet.size = Vector2(size.x, sheet_h)
	sheet.position = Vector2(0, size.y - bottom_h - sheet_h + (1.0 - _slide) * (sheet_h + bottom_h))

func _rebuild_sheet() -> void:
	_clear(content)
	var k := sheet_kind
	if k.begins_with("spot:"):
		var sid := k.substr(5)
		if _mystery(sid):
			sheet_title.text = "❔"
			_part_mystery()
			return
		sheet_title.text = "%s %s" % [_spot_emoji(sid), _spot_title(sid)]
		content.add_child(_spot_header(sid))
		_sheet_spot(sid)
	elif k.begins_with("patch:"):
		var parts := k.split(":")
		_sheet_patch(parts[1], int(parts[2]))
	else:
		match k:
			"mystery":
				sheet_title.text = "❔"
				_part_mystery()
			"goals":
				sheet_title.text = "📖 Quest book"
				content.add_child(UI.header(null, "📖", 80))
				_sheet_goals()
			"album":
				sheet_title.text = "🖼️ Album"
				content.add_child(UI.header(null, "🖼️", 80))
				_sheet_album()
			"log":
				sheet_title.text = "📜 What happened"
				_sheet_log()

## A short note when a bar is tapped (what it shows); it goes away sooner than other notes and not into the log.
func _hint(t: String) -> void:
	_toast(t, 3.0)

func _toast(t: String, secs := 6.5) -> void:
	# what flies to the store needs no words (it still goes into the log)
	if t.begins_with("🧺 Harvested") or t.contains(" Collected: ") or (t.begins_with("✨ ") and t.contains(" ready: ")): return
	var p := UI.card(Color(1, 0.98, 0.9, 0.97), UI.LINE)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var l := UI.label(t, 22, UI.INK, true)
	l.custom_minimum_size = Vector2(minf(size.x - 40.0, 720.0), 0)
	p.add_child(l)
	toasts.add_child(p)
	while toasts.get_child_count() > 3:
		var old := toasts.get_child(0)
		toasts.remove_child(old); old.queue_free()
	_place_toasts()
	call_deferred("_place_toasts")
	var tw := create_tween()
	tw.tween_interval(secs)
	tw.tween_property(p, "modulate:a", 0.0, 1.0)
	tw.tween_callback(_free_if_valid.bind(p))

func _place_toasts() -> void:
	if toasts == null: return
	var ts := toasts.get_combined_minimum_size()
	toasts.size = ts
	var floor_y: float = sheet.position.y if sheet.visible else bottom.global_position.y
	toasts.position = Vector2((size.x - ts.x) / 2.0, floor_y - ts.y - 10.0)

func _free_if_valid(n: Node) -> void:
	if is_instance_valid(n): n.queue_free()

# ------------------------------------------------------------------ pop-up helpers (quizzes, Rest, cards …)
func _modal_w() -> float:
	return minf(size.x - 36.0, 760.0)

func _open_modal(title: String) -> VBoxContainer:
	_clear(modal_box)
	var h := UI.hbox(8)
	var tl := UI.label(title, 24, UI.INK, true)
	h.add_child(tl)
	var close := UI.soft_button("✖", _close_modal, true, 20)
	close.custom_minimum_size = Vector2(52, 44)
	h.add_child(close)
	modal_box.add_child(h)
	modal.visible = true
	_fit_modal()
	call_deferred("_fit_modal")
	return modal_box

func _fit_modal() -> void:
	var w := _modal_w()
	modal_card.custom_minimum_size = Vector2(w, 0)
	var msc: ScrollContainer = modal_box.get_parent()
	modal_box.custom_minimum_size = Vector2(w - 40.0, 0)
	var h := modal_box.get_combined_minimum_size().y + 8.0
	msc.custom_minimum_size = Vector2(w - 24.0, clampf(h, 120.0, size.y - 120.0))
	get_tree().create_timer(0.05).timeout.connect(_fit_modal_again)

func _fit_modal_again() -> void:
	var msc: ScrollContainer = modal_box.get_parent()
	var h := modal_box.get_combined_minimum_size().y + 8.0
	msc.custom_minimum_size = Vector2(_modal_w() - 24.0, clampf(h, 120.0, size.y - 120.0))

func _close_modal() -> void:
	modal.visible = false
	_clear(modal_box)
	_rest = {}
	_queue_refresh()
	call_deferred("_play_fx")
	for t in _after_close: _toast(t)
	_after_close.clear()
	if G.S["gift_pending"].size() > 0: call_deferred("_show_gift")
	elif _celebrations.size() > 0: call_deferred("_show_celebration")

# ------------------------------------------------------------------ celebrations: something new was built or made
func _celebrate(id: String) -> void:
	if (not G.nodes.has(id) and not id.begins_with("perk:")) or _celebrations.has(id): return
	_celebrations.append(id)
	if not modal.visible: call_deferred("_show_celebration")

## The picture of a node for its celebration (the building, the tool on the bench, the helper, the cat).
func _node_picture(id: String) -> Texture2D:
	if id == "barn_cat": return Art.first("animals", ["cat_sit", "cat_walk_1"])
	var t: Texture2D = Art.first("map", [id])
	if t: return t
	t = Art.first("helpers", [id])
	if t: return t
	for b in Spots.BENCH:
		if b["id"] == id: return Art.first("tools", [str(b["pic"])])
	return Art.first("interior", [id])

func _show_celebration() -> void:
	if modal.visible or _celebrations.is_empty(): return
	var id: String = _celebrations.pop_front()
	_sfx("chime")
	var perk := id.begins_with("perk:")
	var n: Dictionary = G.perk_def(id.substr(5)) if perk else G.nodes[id]
	var box := _open_modal("✨ A new perk!" if perk else "✨ New!")
	box.add_child(UI.header(null if perk else _node_picture(id), str(n.get("emoji", "✨")), 180, Color.WHITE, true))
	var tl := UI.label("%s %s" % [n.get("emoji", ""), n["name"]], 30, UI.INK, true)
	tl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(tl)
	if str(n.get("desc", "")) != "": box.add_child(UI.label(str(n["desc"]), 18, UI.MUTED, true))
	if n.has("effects"):
		var et := _effect_text(n["effects"])
		if et != "": box.add_child(UI.label("✨ " + et, 18, UI.GREEN_DARK, true))
	if perk: box.add_child(UI.label("It only makes the farm prettier or livelier. Switch it on or off in the album 🖼️.", 16, UI.MUTED, true))
	var ok := UI.button("Hooray! 🎉", _close_modal, true, UI.GREEN, 24)
	ok.custom_minimum_size = Vector2(0, 62)
	box.add_child(ok)
	# a different effect every time: confetti, stars, fireworks, balloons, sun rays
	var kinds: Array = UI.Celebration.KINDS.duplicate()
	kinds.erase(_last_fx)
	_last_fx = kinds[randi() % kinds.size()]
	var fx = UI.Celebration.new()
	add_child(fx)
	fx.position = Vector2.ZERO
	fx.size = size
	fx.start(_last_fx, size / 2.0)
	modal_card.pivot_offset = modal_card.size / 2.0
	modal_card.scale = Vector2(0.4, 0.4)
	var tw := create_tween()
	tw.tween_property(modal_card, "scale", Vector2.ONE, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _speak(text: String) -> void:
	var voices := DisplayServer.tts_get_voices_for_language("en")
	if voices.size() > 0:
		DisplayServer.tts_stop()
		DisplayServer.tts_speak(text, voices[0])

func _atext(a) -> String:
	return str(a.get("text", "")) if typeof(a) == TYPE_DICTIONARY else str(a)

## A quiz picture: assets/<folder>/<name>.png for img "folder/name", else the emoji drawn big.
func _quiz_pic(img: String, emoji: String, size: float) -> Control:
	var t: Texture2D = null
	if img.contains("/"):
		var k := img.rfind("/")
		t = Art.tex(img.substr(0, k), img.substr(k + 1))
	var c: Control
	if t != null:
		var r := TextureRect.new()
		r.texture = t
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		c = r
	else:
		var l := UI.label(emoji, int(size * 0.6))
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		c = l
	c.custom_minimum_size = Vector2(size, size)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c

## One multiple-choice question (3–4 answers). It can have a picture above it, and picture answers (then shown as big
## picture buttons, two by two). Wrong picks grey out and show why; the right pick calls on_done(first_try).
func _question(box: VBoxContainer, q: Dictionary, on_done: Callable) -> void:
	var qh := UI.hbox(8)
	var ql := UI.label(str(q["q"]), 24, UI.INK, true)
	ql.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	qh.add_child(ql)
	var words := []
	for a in q["answers"]: words.append(_atext(a))
	var sp := UI.soft_button("🔊", _speak.bind(str(q["q"]) + ". " + ". ".join(words)), true, 20)
	sp.custom_minimum_size = Vector2(52, 44)
	qh.add_child(sp)
	box.add_child(qh)
	if str(q.get("img", "")) != "" or str(q.get("emoji", "")) != "":
		var pc := CenterContainer.new()
		pc.add_child(_quiz_pic(str(q.get("img", "")), str(q.get("emoji", "")), 150))
		box.add_child(pc)
	var feedback := UI.label("", 18, UI.MUTED, true)
	var buttons := []
	var state := {"first": true, "done": false}
	var grid: GridContainer = null
	if q.get("pictures", false):
		grid = GridContainer.new()
		grid.columns = 2
		grid.add_theme_constant_override("h_separation", 14)
		grid.add_theme_constant_override("v_separation", 14)
		var gc := CenterContainer.new()
		gc.add_child(grid)
		box.add_child(gc)
	for i in range(q["answers"].size()):
		var a = q["answers"][i]
		var b: Button
		if grid != null:
			b = UI.button("", Callable(), true, Color("fffaf0"), 21)
			for st in ["normal", "hover", "pressed"]:
				b.add_theme_stylebox_override(st, UI.box(Color("fffaf0") if st != "pressed" else Color("f1e6cc"), 16, Color("6c8fb3"), 3, 6))
			b.custom_minimum_size = Vector2(176, 176)
			b.tooltip_text = _atext(a)
			var cc := CenterContainer.new()
			cc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			cc.mouse_filter = Control.MOUSE_FILTER_IGNORE
			cc.add_child(_quiz_pic(str(a.get("img", "")), str(a.get("emoji", "")), 140))
			b.add_child(cc)
			b.set_meta("pic", cc)
			grid.add_child(b)
		else:
			b = UI.button(_atext(a), Callable(), true, Color("6c8fb3"), 21)
			b.custom_minimum_size = Vector2(0, 56)
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			box.add_child(b)
		buttons.append(b)
	box.add_child(feedback)
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_answer_pressed.bind(i, q, buttons, feedback, state, on_done))
	call_deferred("_fit_modal")

func _answer_pressed(i: int, q: Dictionary, buttons: Array, feedback: Label, state: Dictionary, on_done: Callable) -> void:
	if state["done"]: return
	var b: Button = buttons[i]
	if i == int(q["correct"]):
		state["done"] = true
		b.add_theme_stylebox_override("disabled", UI.box(UI.GREEN, 10, Color(0, 0, 0, 0), 0, 10))
		for x in buttons:
			x.disabled = true
			if x != b and x.has_meta("pic"): x.get_meta("pic").modulate.a = 0.35
		var why := str(q.get("why", ""))
		if why == "": why = _atext(q["answers"][i]) + "."
		var own := false     # the pack's own line already says "Yes!" / "Right!" …
		for w in ["Yes", "Right", "Correct", "Exactly", "Ja", "Richtig", "Genau", "Stimmt"]:
			if why.begins_with(w + "!"): own = true
		feedback.text = "✅ " + ("" if own else "Right! ") + why
		feedback.add_theme_color_override("font_color", UI.GREEN_DARK)
		on_done.call(state["first"])
		call_deferred("_fit_modal")
	else:
		state["first"] = false
		b.disabled = true
		b.add_theme_stylebox_override("disabled", UI.box(Color("d9a89c"), 10, Color(0, 0, 0, 0), 0, 10))
		if b.has_meta("pic"): b.get_meta("pic").modulate.a = 0.35
		var hint := str(q.get("wrong_text", ""))
		if hint == "": hint = "Not quite. " + str(q.get("why", ""))
		feedback.text = "❌ " + hint + "  Try again!"
		feedback.add_theme_color_override("font_color", UI.RED)

# ------------------------------------------------------------------ Time Quiz
func _show_quiz_id(id: String) -> void:
	for i in range(G.pack_questions.size()):
		if str(G.pack_questions[i].get("id", "")) == id:
			var q: Dictionary = G._shuffled_q(G.pack_questions[i], "", i, false)
			q["wrong_text"] = q["wrong"]
			q["source"] = "⏳ Time Quiz"
			_show_time_quiz(q)

func _show_time_quiz(forced: Dictionary = {}) -> void:
	var q: Dictionary = forced if not forced.is_empty() else G.next_time_question()
	var box := _open_modal("❓ Time Quiz")
	box.add_child(UI.header(null, "⏳", 64))
	box.add_child(UI.label(str(q.get("source", "")) + "   ·   every right answer moves farm time one step", 15, UI.MUTED, true))
	var qbox := UI.vbox(8)
	box.add_child(qbox)
	var after := UI.vbox(8)
	box.add_child(after)
	_question(qbox, q, _time_answered.bind(q, after))

func _time_answered(first_try: bool, q: Dictionary, after: VBoxContainer) -> void:
	if q.get("review", false): G.record_card_answer(q, first_try)
	else: G.time_result(q, first_try)
	var info: Dictionary = G.step_time()
	var msg := "⏳ Time moves on: question %d." % G.S["step"]
	if info.get("rain_stopped", false) and G.perk_on("perk_rainbow"):
		map.rainbow()
		_after_close.append("🌈 The rain has stopped — look, a rainbow!")
	if info.get("rain", false):
		msg += " 🌧️ It rained."
		_after_close.append("🌧️ Rain! The fields are watered — planting costs no water until the next question.")
	if int(info.get("removed", 0)) > 0: msg += " 🧍 The scarecrow chased off %d pest%s." % [int(info["removed"]), "" if int(info["removed"]) == 1 else "s"]
	if float(info.get("eat_share", 0.0)) >= 0.005: msg += " 🐦 Pests ate %d%% of what is growing." % int(round(float(info["eat_share"]) * 100.0))
	after.add_child(UI.label(msg, 17, UI.MUTED, true))
	var row := UI.hbox(8)
	var nb := UI.button("Next question ▶", _show_time_quiz, true, UI.GREEN, 21)
	nb.custom_minimum_size = Vector2(0, 56)
	nb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(nb)
	var back := UI.soft_button("⬅️ Back to the farm", _close_modal, true, 18)
	back.custom_minimum_size = Vector2(0, 56)
	row.add_child(back)
	after.add_child(row)
	call_deferred("_fit_modal")

# ------------------------------------------------------------------ Rest
## Quick sums: the answer is typed on a number pad (or the keyboard) and sent with ✔. A timer runs for
## Rest: sums on the number pad (learnkit/number_pad_quiz.gd asks, checks and remembers). A right answer gives energy:
## all of it when quick (the level's time — 2.5 s for a sum learned by heart), half when slow.
func _show_rest() -> void:
	var box := _open_modal("😴 Rest")
	var beds: Array = Spots.HOTSPOT_ART.get("living", []).filter(func(id): return G.nodes.has(id) and G.done(id))
	beds.reverse()
	var bed: Texture2D = Art.first("interior", beds)
	box.add_child(UI.header(bed if bed else Art.first("map", ["tent"]), "😴", 72))
	if G.S.get("cold", false): box.add_child(UI.label("❄️ The house is cold — stack firewood to rest better.", 17, UI.RED, true))
	var er := UI.hbox(6)
	er.alignment = BoxContainer.ALIGNMENT_CENTER
	er.add_child(UI.label("⚡", 24))
	var eb := UI.stock_bar(float(G.S["energy"]), G.energy_max(), UI.item_color("energy"), 420)
	UI.explain(eb, "⚡ Your energy: right sums fill it up.")
	er.add_child(eb)
	box.add_child(er)
	G.math_record()
	var pad = Pad.new()
	pad.setup(G.math, G._learn(), G.rng, {"scale": float(G.settings.get("restTimerScale", 1.0)), "streak": G.perk_on("perk_streak"),
		"colors": {"ink": UI.INK, "muted": UI.MUTED, "green": UI.GREEN, "green_dark": UI.GREEN_DARK, "red": UI.RED, "amber": UI.AMBER, "line": UI.LINE}})
	box.add_child(pad)
	pad.before_next.connect(_rest_before_next)
	pad.answered.connect(_rest_answered)
	box.add_child(UI.soft_button("⬅️ Back to the farm", _close_modal, true, 17))
	_rest = {"eb": eb, "pad": pad}
	pad.next()
	call_deferred("_fit_modal")

func _rest_before_next() -> void:
	if _rest.is_empty(): return
	if float(G.S["energy"]) >= G.energy_max() - 0.01: _rest["pad"].stop("Full of energy! Back to work.")
	call_deferred("_fit_modal")

## After each answer: energy, perks (lightning, streak), stars and a fanfare for medals and new levels.
func _rest_answered(res: Dictionary) -> void:
	G.after_rest_answer(res["right"], res["quick"])
	var fb: Dictionary = res["fb"]
	if res["right"]:
		var gained: float = G.rest_correct(res["quick"])
		var t := ("⚡ +%s  quick!" if res["quick"] else "⚡ +%s  (a bit slow: half)") % _num(gained)
		var txt := str(res["text"])
		res["text"] = t + (txt.substr(txt.find("\n")) if txt.contains("\n") else "")
		_rest["eb"].have = float(G.S["energy"])
		_rest["eb"].queue_redraw()
		if res["quick"] and G.perk_on("perk_lightning") and randf() < 1.0 / 3.0: _lightning()
	if not fb.get("medals", []).is_empty():
		_sfx("levelup")
		var fx = UI.Celebration.new()
		add_child(fx)
		fx.size = size
		fx.start("stars", _rest["pad"].ans_box.get_global_rect().get_center())
		for m in fb["medals"]:
			if m["medal"] != "bronze": _after_close.append(str(fb.get("comment", "")))
	elif int(fb.get("streak", 0)) in [5, 10, 20, 30]: _sfx("ding")
	call_deferred("_fit_modal")

## Lightning over the Rest window, down to the answer (perk "Lightning sums").
func _lightning() -> void:
	var lt = Fx.Lightning.new()
	add_child(lt)
	lt.position = Vector2.ZERO
	lt.size = size
	lt.start(_rest["pad"].ans_box.get_global_rect().get_center())
	_sfx("zap")

## A sound, if the "Farm sounds" perk is on.
func _sfx(name: String) -> void:
	if sfx and G.perk_on("perk_sounds"): sfx.play(name)

## Something was sold: a jingle, and coins fly into the purse (perk "Coin shower").
func _on_sold(_k: String, n: float, _coins: float) -> void:
	_sfx("coin")
	if not G.perk_on("perk_coins"): return
	var cs = Fx.CoinShower.new()
	add_child(cs)
	cs.position = Vector2.ZERO
	cs.size = size
	var from := Vector2(size.x / 2.0, size.y * 0.62)
	if sheet.visible: from = sheet.get_global_rect().get_center()
	cs.start(from, lbl_coins.get_global_rect().get_center(), clampi(int(n), 3, 12), _coin_landed)

func _coin_landed() -> void:
	lbl_coins.pivot_offset = lbl_coins.size / 2.0
	var tw := create_tween()
	tw.tween_property(lbl_coins, "scale", Vector2(1.15, 1.15), 0.06)
	tw.tween_property(lbl_coins, "scale", Vector2.ONE, 0.1)

## Taps on the farm make sparkles (perk "Magic sparkles").
func _input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT and not modal.visible:
		if not scroll.get_global_rect().has_point(e.position): return
		if sheet.visible and sheet.get_global_rect().has_point(e.position): return
		map.sparkle_global(e.position)

# ------------------------------------------------------------------ knowledge cards
## A knowledge card. Starting to read it (or reading it again) shows its page, with 🔊 to hear it; its quiz shows only
## the questions, not the page.
func _show_card(cid: String) -> void:
	var st: String = G.card_status(cid)
	if st == "quiz" and G.S.get("read_seen", {}).has(cid):
		_card_quiz_only(cid)
		return
	_card_page(cid)

## The card's page (to read now, or to read again). A card whose quiz is waiting gets a button to start it.
func _card_page(cid: String) -> void:
	var n: Dictionary = G.nodes[cid]
	if not G.S.has("read_seen"): G.S["read_seen"] = {}
	G.S["read_seen"][cid] = true
	var box := _open_modal("%s %s" % [n.get("emoji", "📖"), n["name"]])
	box.add_child(UI.header(Art.first("cards", [cid]), str(n.get("emoji", "📖")), 84))
	var page := str(n.get("page", n.get("desc", "")))
	box.add_child(UI.label(page, 20, UI.INK, true))
	box.add_child(UI.soft_button("🔊 Read aloud", _speak.bind(page), true, 17))
	var unl := []
	for u in n.get("unlocks", []):
		if G.nodes.has(u): unl.append(G.nodes[u].get("emoji", "") + " " + G.nodes[u]["name"])
		elif G.recipes.has(u): unl.append("🍳 " + str(G.recipes[u].get("name", G.iname(G.recipes[u]["outputs"].keys()[0]))))
	if unl.size() > 0: box.add_child(UI.label("Knowing this lets you: " + ", ".join(unl), 16, UI.MUTED, true))
	match G.card_status(cid):
		"learned":
			box.add_child(UI.label("✅ You already know this card.", 19, UI.GREEN_DARK))
		"reading":
			var left := maxi(1, G.up(G.read_needed(cid) - float(G.S["read_progress"])))
			var rr := UI.hbox(8)
			rr.add_child(UI.label("📖", 22))
			rr.add_child(UI.explain(UI.stock_bar(float(G.S["read_progress"]), ceilf(G.read_needed(cid)), UI.BLUE, 160), "📖 Pages read: each Time Quiz question turns one."))
			rr.add_child(UI.wait_button(left, _quiz_from_card))
			box.add_child(rr)
		"quiz":
			var sb := UI.button("❓ Take the quiz ▶", _card_quiz_only.bind(cid), true, UI.GREEN, 20)
			sb.custom_minimum_size = Vector2(0, 56)
			box.add_child(sb)

func _quiz_from_card() -> void:
	_close_modal()
	_show_time_quiz()

## The card's quiz: only the questions (the page was read before).
func _card_quiz_only(cid: String) -> void:
	var n: Dictionary = G.nodes[cid]
	var box := _open_modal("❓ %s %s" % [n.get("emoji", "📖"), n["name"]])
	var qs: Array = G.card_quiz(cid)
	var qbox := UI.vbox(8)
	box.add_child(qbox)
	_card_q(cid, qs, 0, qbox, {"all_first": true})

func _card_q(cid: String, qs: Array, idx: int, qbox: VBoxContainer, acc: Dictionary) -> void:
	var last := modal_box.get_child(modal_box.get_child_count() - 1)
	if last is Button: modal_box.remove_child(last); last.queue_free()
	_clear(qbox)
	if idx >= qs.size():
		G.finish_card(cid, acc["all_first"])
		qbox.add_child(UI.label("🎓 You learned \"%s\"!" % G.nodes[cid]["name"], 24, UI.GREEN_DARK, true))
		qbox.add_child(UI.soft_button("⬅️ Back to the farm", _close_modal, true, 18))
		call_deferred("_fit_modal")
		return
	var q: Dictionary = qs[idx]
	qbox.add_child(UI.label(("📚 Review: " + G.nodes[q["card"]]["name"]) if q["review"] else "Question %d" % (idx + 1), 15, UI.MUTED))
	var inner := UI.vbox(8)
	qbox.add_child(inner)
	_question(inner, q, _card_answered.bind(cid, qs, idx, qbox, acc))

func _card_answered(first_try: bool, cid: String, qs: Array, idx: int, qbox: VBoxContainer, acc: Dictionary) -> void:
	G.record_card_answer(qs[idx], first_try)
	if not first_try and not qs[idx]["review"]: acc["all_first"] = false
	var nb := UI.button("Next ▶" if idx + 1 < qs.size() else "Finish ▶", _card_q.bind(cid, qs, idx + 1, qbox, acc), true, UI.GREEN, 19)
	nb.custom_minimum_size = Vector2(0, 52)
	qbox.add_child(nb)
	call_deferred("_fit_modal")

# ------------------------------------------------------------------ patches (field, orchard, greenhouse)
func _on_patch(a: String, i: int) -> void:
	if not G.patch_usable(a, i):
		# an overgrown patch: show what clears the land — a field for later chapters only shows the mysterious sign
		if a == "field":
			if i / 9 > 0 and not _field_within_reach(i / 9):
				_open_sheet("mystery")
				return
			field_idx = mini(i / 9, maxi(0, G.field_names().size() - 1))
			_open_spot("field")
		return
	_open_sheet("patch:%s:%d" % [a, i])
	if a == "field":
		field_idx = i / 9
		get_tree().create_timer(0.1).timeout.connect(_reveal.bind(map.patch_rect(i / 9, i % 9)))

## Can anything be done for field f (North Field, River Meadow) in this chapter?
func _field_within_reach(f: int) -> bool:
	var slot := "field%d" % (f + 1)
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		if str(n.get("slot", "")) == slot and not G.satisfied(id) and _in_chapter(id) and G.missing_reqs(id).is_empty(): return true
	return G.S["patches"].size() > f * 9

func _sheet_patch(a: String, i: int) -> void:
	var p: Dictionary = G.area(a)[i]
	sheet_title.text = ("🟫 Patch %d" % (i % 9 + 1)) if a == "field" else (("🌳 Tree spot %d" % (i + 1)) if a == "orchard" else ("🪴 Bed %d" % (i + 1)))
	if p["crop"] == "":
		content.add_child(UI.header(Art.tex("deco", "soil_heap"), "🟫", 80))
		if float(p.get("quality", 1.0)) < 0.99:
			content.add_child(UI.label("🚧 Not fully cleared yet: it gives %d%% of a full harvest. Finish clearing it at the 🪧 sign." % int(round(float(p["quality"]) * 100)), 16, UI.MUTED, true))
		var cap: int = G.plants_per_patch(a)
		content.add_child(UI.label("🌱".repeat(cap) + "  fits here", 17, UI.MUTED, true))
		var cs: Array = G.crops_for(a)
		if cs.is_empty(): content.add_child(UI.label("No seeds you can plant here yet. Learn crop cards in the 📦 library.", 17, UI.MUTED, true))
		for cid in cs:
			var n: Dictionary = G.nodes[cid]
			var plan: Dictionary = G.plant_plan(a, cid)
			var pc := UI.card()
			var row := UI.hbox(8)
			pc.add_child(row)
			var ct: Texture2D = Art.tex("crops", cid)
			if ct:
				var tr := TextureRect.new()
				tr.texture = ct
				tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				tr.custom_minimum_size = Vector2(52, 52)
				row.add_child(tr)
			else:
				row.add_child(UI.label(str(n.get("emoji", "🌱")), 36))
			var v := UI.vbox(2)
			row.add_child(v)
			var plants := int(plan["plants"])
			v.add_child(UI.label("%s   %s   ⏳%d" % [n["name"], "🌱".repeat(maxi(plants, 0)) if plants > 0 else "—", int(n.get("grow", 0))], 17, UI.INK, true))
			# short of water: show the water a full patch needs, so the missing cubes show up hollow
			var short: bool = plan["reasons"].has("water")
			var c := {"water": float(plan["water_full" if short else "water"]), "energy": float(plan["energy"])}
			var base := {"water": float(plan["water_full_base" if short else "water_base"]), "energy": float(plan["energy_base"])}
			var cr := UI.hbox(10)
			cr.add_child(_costs(c, base))
			cr.add_child(UI.label("🌰 %d" % G.down(G.seed_have(cid)), 16, UI.INK if G.seed_have(cid) >= 1.0 else UI.RED))
			v.add_child(cr)
			if plants < int(plan["max"]) and plan["reasons"].size() > 0:
				var why := []
				for rk in plan["reasons"]: why.append(G.iemoji(rk) if rk != "seeds" else "🌰")
				v.add_child(UI.label("fewer: " + " ".join(why), 14, UI.MUTED))
			var pb := UI.action_button("plant", _do_plant.bind(a, i, cid), plants >= 1)
			row.add_child(pb)
			content.add_child(pc)
			if G.seed_have(cid) < 1.0 and not n.has("seedItem"):
				v.add_child(UI.soft_button("🛒 Buy seeds at the market", _go_spot.bind("market"), true, 15))
	else:
		var n2: Dictionary = G.nodes[p["crop"]]
		var ct2: Texture2D = Art.tex("crops", str(p["crop"]))
		var young: bool = float(p["growth"]) < G.grow_target(p) * 0.5 and not p["ready"]
		content.add_child(UI.header(ct2 if not young else Art.tex("deco", "sprout"), "🌱" if young else str(n2.get("emoji", "")), 96,
			Color(1.1, 0.95, 0.55) if p["ready"] else Color.WHITE, p["ready"]))
		var shown := clampi(G.shown_plants(float(p["plants"])), 1, 9)
		var row2 := UI.hbox(8)
		row2.add_child(UI.label(("🌱" if young else str(n2.get("emoji", ""))).repeat(shown), 24))
		if not p["ready"]:
			row2.add_child(UI.explain(UI.stock_bar(float(p["growth"]), ceilf(G.grow_target(p)), Color("8cc63f"), 160), "🌱 Growing: a bit more with every Time Quiz question. Full = ready to harvest."))
			row2.add_child(UI.wait_button(_grow_left(a, p), _show_time_quiz))
		content.add_child(row2)
		if n2.has("regrow") and G.crops_for(a).size() > 1:
			# a tree stays for good, so one can be cut down to plant another kind
			var cr2 := UI.hbox(8)
			cr2.add_child(UI.label("Want another tree here?", 15, UI.MUTED, true))
			cr2.add_child(_costs({"energy": G.ecost("wood", 3.0)}, {"energy": 3.0}))
			cr2.add_child(UI.action_button("wood", _do_cut_tree.bind(a, i), float(G.S["energy"]) + 0.001 >= G.ecost("wood", 3.0), UI.SOIL, "🪓", "Cut down"))
			content.add_child(cr2)
		if float(p.get("soil", 1.0)) < 0.99: content.add_child(UI.label("😴 Tired soil: the same crop as last time grows slower. Swap crops next time (beans and clover rest the soil).", 15, UI.MUTED, true))
		elif float(p.get("soil", 1.0)) > 1.01: content.add_child(UI.label("💚 Rested soil after beans or clover: grows faster.", 15, UI.GREEN_DARK, true))
		if p["ready"]:
			var ys := ""
			for k in n2.get("yields", {}): ys += G.iemoji(k).repeat(clampi(G.down(float(n2["yields"][k]) * float(p["plants"])), 1, 12))
			var hr := UI.hbox(8)
			var hb := UI.button("🧺 Harvest   " + ys, _do_harvest.bind(a, i), true, UI.GREEN, 20)
			hb.custom_minimum_size = Vector2(0, 56)
			hb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hr.add_child(hb)
			var e1: float = G.ecost("harvest", 1.0) * G.m("energy:field")
			hr.add_child(_costs({"energy": e1}, {"energy": 1.0}))
			content.add_child(hr)
	if a == "field":
		if float(p["weeds"]) >= 0.5:
			var wr := UI.hbox(8)
			wr.add_child(UI.label("🌿", 22))
			wr.add_child(UI.explain(UI.stock_bar(float(p["weeds"]), maxf(6.0, ceilf(float(p["weeds"]))), UI.item_color("fiber"), 150), "🌿 Weeds here: they make the harvest smaller. Pull them!"))
			var pull := minf(3.0, float(p["weeds"]))
			wr.add_child(_costs({"energy": G.ecost("weed", pull) * G.m("energy:field")}, {"energy": pull}))
			wr.add_child(UI.action_button("weed", _do_weed.bind(i), true, UI.GREEN_DARK, "💪", "Pull"))
			content.add_child(wr)
		if float(p["stones"]) >= 0.5:
			var sr := UI.hbox(8)
			sr.add_child(UI.label("🪨", 22))
			sr.add_child(UI.explain(UI.stock_bar(float(p["stones"]), maxf(6.0, ceilf(float(p["stones"]))), UI.item_color("stone"), 150), "🪨 Stones in the soil: they make the harvest smaller. Pick them out."))
			sr.add_child(UI.action_button("field", _do_stones.bind(i), true, UI.SOIL, "🤏", "Pick"))
			content.add_child(sr)

func _do_plant(a: String, i: int, cid: String) -> void:
	var plan: Dictionary = G.plant_plan(a, cid)
	if int(plan["plants"]) < 1 and plan["reasons"].has("water"):
		_show_no_water()
		return
	if G.plant(a, i, cid): _close_sheet()

## No water left: a drop with a red line through it, and the bucket to fetch more from the pond.
func _show_no_water() -> void:
	if modal.visible: return
	var box := _open_modal("💧")
	box.add_child(UI.NoWater.new())
	var l := UI.label("No water left!", 24, UI.RED, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(l)
	var fr := UI.hbox(8)
	var fb := UI.button("🪣  %s" % "💧".repeat(clampi(int(round(G.fetch_amount())), 1, 8)), _fetch_and_close, true, UI.BLUE, 24)
	fb.custom_minimum_size = Vector2(0, 60)
	fb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fr.add_child(fb)
	fr.add_child(_costs({"energy": G.fetch_cost()}, {"energy": float(G.meta.get("water", {}).get("fetchEnergy", 1.0))}))
	box.add_child(fr)
	box.add_child(UI.soft_button("⬅️ Back to the farm", _close_modal, true, 17))

func _fetch_and_close() -> void:
	if G.fetch_water() and float(G.S["water"]) + 0.5 >= G.water_cap(): _close_modal()

func _do_harvest(a: String, i: int) -> void:
	if G.harvest(a, i): _close_sheet()

func _do_weed(i: int) -> void:
	G.weed(i)

func _do_stones(i: int) -> void:
	G.pick_stones(i)

func _pick_all() -> void:
	for i in range(field_idx * 9, field_idx * 9 + 9):
		if i < G.S["patches"].size() and G.patch_usable("field", i) and float(G.S["patches"][i]["stones"]) >= 0.5:
			if not G.pick_stones(i): break

## Harvest everything that is ready in an area (all fields, the orchard or the greenhouse).
func _harvest_all(a := "field") -> void:
	var arr: Array = G.area(a)
	for i in range(arr.size()):
		if arr[i]["ready"]:
			if not G.harvest(a, i): break

func _ready_count(a: String) -> int:
	var n := 0
	for p in G.area(a):
		if p["crop"] != "" and p["ready"]: n += 1
	return n

# ------------------------------------------------------------------ gift cards, names, menu, welcome
## A postcard from a friend (someone you helped) who heard of your success, with a gift: pick one of 1–3.
func _show_gift(_offer = null) -> void:
	if modal.visible: return
	var pc: Dictionary = G.postcard_pending()
	if pc.is_empty(): return
	_sfx("chime")
	var box := _open_modal("📬 A postcard!")
	box.add_child(_postcard(pc))
	var offer: Array = pc.get("offer", [])
	box.add_child(UI.label("Pick one gift:" if offer.size() > 1 else "A gift for you:", 18, UI.MUTED))
	for gid in offer:
		var c: Dictionary = G.gift_card(gid)
		var b := UI.button("%s  %s\n%s" % [c.get("emoji", "🎁"), c["name"], c.get("desc", "")], _pick_gift.bind(gid), true, Color("7a9a4a"), 19)
		b.custom_minimum_size = Vector2(0, 96)
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(b)
	if G.friends().size() < 3:
		box.add_child(UI.label("💡 More friends, more postcards — and more gifts to choose from. Help a neighbour (📖 Quest book)!", 15, UI.MUTED, true))
	modal_card.pivot_offset = modal_card.size / 2.0
	modal_card.scale = Vector2(0.6, 0.6)
	create_tween().tween_property(modal_card, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	call_deferred("_fit_modal")

## The postcard itself: the friend's words on the left, a stamp with their picture on the right.
func _postcard(pc: Dictionary, small := false) -> PanelContainer:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", UI.box(Color("fffaf0"), 8, Color("c9b48a"), 2, 10 if small else 16))
	var h := UI.hbox(12)
	card.add_child(h)
	var txt := UI.vbox(6)
	txt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	txt.add_child(UI.label(str(pc.get("text", "")), 15 if small else 20, UI.INK, true))
	var sig := UI.label("— %s %s" % [pc.get("emoji", ""), pc.get("from", "")], 15 if small else 19, Color("6b4a2b"), true)
	sig.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	txt.add_child(sig)
	if small and pc.has("gift"):
		var c: Dictionary = G.gift_card(str(pc["gift"]))
		txt.add_child(UI.label("🎁 %s %s" % [c.get("emoji", ""), c.get("name", "")], 14, UI.MUTED))
	h.add_child(txt)
	var st := PanelContainer.new()
	st.add_theme_stylebox_override("panel", UI.box(Color("f6e7c8"), 3, Color("b5562b"), 3, 6))
	st.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var sv := UI.vbox(0)
	st.add_child(sv)
	# assets/friends/<side quest>.png when drawn; a friend helped twice has one portrait, under the first favour
	var pkeys := [str(pc.get("quest", ""))]
	for sq in G.nodes:
		if G.nodes[sq]["type"] == "sidequest" and str(G.nodes[sq].get("friend", {}).get("name", "")) == str(pc.get("from", "")): pkeys.append(sq)
	var portrait: Texture2D = Art.first("friends", pkeys)
	if portrait:
		var pt := TextureRect.new()
		pt.texture = portrait
		pt.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pt.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pt.custom_minimum_size = Vector2(48, 56) if small else Vector2(96, 112)
		sv.add_child(pt)
	else:
		var se := UI.label(str(pc.get("emoji", "💌")), 26 if small else 44)
		se.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		sv.add_child(se)
	var sl := UI.label("FARM POST", 9 if small else 11, Color("b5562b"))
	sl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sv.add_child(sl)
	h.add_child(st)
	return card

func _pick_gift(gid: String) -> void:
	G.pick_gift(gid)
	_close_modal()

func _show_name(pet_id: String, default_name: String) -> void:
	var box := _open_modal("%s A new friend!" % G.nodes[pet_id].get("emoji", "🐾"))
	box.add_child(UI.label("What should we call your new pet?", 20))
	var le := LineEdit.new()
	le.text = default_name
	le.custom_minimum_size = Vector2(0, 56)
	le.add_theme_font_size_override("font_size", 24)
	box.add_child(le)
	var ok := UI.button("That's the name! ✔", _name_done.bind(pet_id, le), true, UI.GREEN, 20)
	ok.custom_minimum_size = Vector2(0, 56)
	box.add_child(ok)

func _name_done(pet_id: String, le: LineEdit) -> void:
	G.set_pet_name(pet_id, le.text)
	_close_modal()

## Who is playing? Everyone has their own farm and their own record of sums and questions practised.
func _ask_player() -> void:
	var box := _open_modal("👋 Who is playing?")
	box.add_child(UI.label("Your name keeps your own farm and remembers which sums and questions you have practised.", 18, UI.MUTED, true))
	var known: Array = G.players()
	if known.size() > 0:
		var fl := HFlowContainer.new()
		fl.add_theme_constant_override("h_separation", 8)
		fl.add_theme_constant_override("v_separation", 8)
		for nm in known:
			var b := UI.button("🧑‍🌾 " + str(nm), _player_chosen.bind(str(nm)), true, UI.GREEN, 22)
			b.custom_minimum_size = Vector2(0, 58)
			fl.add_child(b)
		box.add_child(fl)
		box.add_child(UI.label("Someone new?", 18))
	var le := LineEdit.new()
	le.placeholder_text = "Your name"
	le.custom_minimum_size = Vector2(0, 58)
	le.add_theme_font_size_override("font_size", 26)
	box.add_child(le)
	var ok := UI.button("That's me! ✔", _player_typed.bind(le), true, UI.GREEN, 22)
	ok.custom_minimum_size = Vector2(0, 58)
	box.add_child(ok)

func _player_typed(le: LineEdit) -> void:
	if le.text.strip_edges() != "": _player_chosen(le.text.strip_edges())

func _player_chosen(name: String) -> void:
	G.set_player(name)
	field_idx = 0
	for f in range(map.fields.size()): map.fields[f].show_area("field", f)
	_close_sheet()
	_close_modal()
	_refresh()
	_toast("👋 Hello, %s!" % name)
	if G.S["step"] == 0 and not G.done("k_wheat"): _show_welcome()

func _show_menu() -> void:
	var box := _open_modal("⚙️ Settings")
	if G.player != "": box.add_child(UI.soft_button("👤 %s — someone else is playing" % G.player, _ask_player, true, 18))
	else: box.add_child(UI.soft_button("👤 Who is playing?", _ask_player, true, 18))
	box.add_child(UI.label("Question packs, the share of knowledge reviews in the Time Quiz and the size of Rest sums are set in data/settings.json and data/quiz_packs/.", 16, UI.MUTED, true))
	box.add_child(UI.label("Knowledge reviews in the Time Quiz: %d%%" % int(round(float(G.settings.get("knowledgeReviewShare", 0.25)) * 100)), 17))
	box.add_child(UI.soft_button("📜 What happened (log)", _open_log, true, 18))
	box.add_child(UI.soft_button("📊 Learning record (sums and questions)", _show_learning, true, 18))
	box.add_child(UI.soft_button("%s 🎚️ Prices fit my farm (dynamic difficulty)" % ("✅" if G.flex_on() else "⬜"), _toggle_flex, true, 16))
	box.add_child(UI.button("🗑️ Start a new game (deletes the save)", _reset, true, UI.RED, 17))

## For parents: the player's learning record — a plain JSON file (learnkit/learner.gd) that can be opened, copied,
## edited (learnkit/tools/learning-editor.html) and pasted back; and which maths categories are practised.
func _show_learning() -> void:
	var box := _open_modal("📊 Learning record")
	var L: Dictionary = G._learn()
	var r: Dictionary = G.math_record()
	var qs: Dictionary = G.quiz.stats(L)
	box.add_child(UI.label("%s — Rest sums: %d answered, %d known by heart, %d medals.  Time Quiz: %d questions seen, %d known." % [
		G.player if G.player != "" else "(no name yet)", int(r.get("n", 0)), G.math.known_count(L), G.math.medal_count(L), int(qs["seen"]), int(qs["known"])], 17, UI.INK, true))
	var folder: String = G.learner.folder()
	if folder != "":
		box.add_child(UI.label("The file: " + folder + "/learning.json", 14, UI.MUTED, true))
		box.add_child(UI.soft_button("📂 Open the folder", func(): OS.shell_open(folder), true, 17))
	box.add_child(UI.label("Copy it out to look at it or change it (learnkit/tools/learning-editor.html opens it), then paste it back in.", 15, UI.MUTED, true))
	box.add_child(UI.soft_button("📋 Copy the record", _copy_learning, true, 17))
	var te := TextEdit.new()
	te.placeholder_text = "Paste a learning record here …"
	te.custom_minimum_size = Vector2(0, 90)
	box.add_child(te)
	box.add_child(UI.soft_button("📥 Use the pasted record", _paste_learning.bind(te), true, 17))
	_section_in(box, "➕ What the Rest sums practise")
	for cat in G.math.C.get("categories", []):
		var on: bool = r["active"].has(cat["id"])
		var b := UI.soft_button("%s %s %s  (classes %s)" % ["✅" if on else "⬜", cat.get("emoji", ""), cat.get("name", ""), cat.get("classes", "")], _toggle_category.bind(str(cat["id"])), true, 17)
		box.add_child(b)
	call_deferred("_fit_modal")

func _rainbow_now() -> void:
	map.rainbow()

func _copy_learning() -> void:
	DisplayServer.clipboard_set(G.learner.export_text())
	_toast("📋 Copied.")

func _section_in(box: VBoxContainer, title: String) -> void:
	box.add_child(UI.label(title, 19, UI.INK, true))

func _paste_learning(te: TextEdit) -> void:
	if G.learner.import_text(te.text):
		G.L = G.learner.data
		_toast("📥 Learning record loaded.")
		_show_learning()
	else: _toast("❌ That is not a learning record.")

func _toggle_category(id: String) -> void:
	var r: Dictionary = G.math_record()
	if r["active"].has(id):
		if r["active"].size() > 1: r["active"].erase(id)
	else: r["active"].append(id)
	G.save_learning()
	_show_learning()

func _open_log() -> void:
	_close_modal()
	_open_sheet("log")

func _reset() -> void:
	G.reset_game()
	field_idx = 0
	for f in range(map.fields.size()): map.fields[f].show_area("field", f)
	_close_sheet()
	_close_modal()
	_show_welcome()

func _show_welcome() -> void:
	var box := _open_modal("🔥 Ashes")
	box.add_child(UI.header(null, "🔥", 72))
	box.add_child(UI.label("Your farm burned down. All that's left: a tent, an old bucket by a wild pond, a tin pot, a few sticks and stones, five wheat seeds — and a box with a book in it.", 20, UI.INK, true))
	box.add_child(UI.label("Tap places on the farm to see what you can do there. Every right answer in the ❓ Time Quiz moves farm time forward. When you're tired, tap ⚡ to rest.", 17, UI.MUTED, true))
	var ob := UI.button("📗 Open the book", _open_first_book, true, UI.GREEN, 20)
	ob.custom_minimum_size = Vector2(0, 56)
	box.add_child(ob)

func _open_first_book() -> void:
	_close_modal()
	_show_card("k_wheat")

# ------------------------------------------------------------------ text helpers
const CAT_LABEL := {"field": "Field work", "weed": "Weeding", "plant": "Planting", "harvest": "Harvesting", "gather": "Gathering", "wood": "Wood work",
	"build": "Building", "craft": "Crafting", "smith": "Smithing", "kiln": "Kiln work", "cook": "Cooking", "prep": "Prep", "mill": "Milling",
	"process": "Dairy & press", "textile": "Textiles", "animal": "Animal care", "errand": "Errands"}

## Whole numbers for kids: 0.5 shows as ½, 1.5 as 1½, anything else is rounded.
func _num(v: float) -> String:
	var r := snappedf(v, 0.5)
	if absf(v - r) > 0.15: return str(int(round(v)))
	var whole := int(floor(r))
	if absf(r - whole) > 0.01: return ("%d½" % whole) if whole > 0 else "½"
	return str(whole)

func _pct(v: float) -> String:
	return ("−%d%%" % int(round((1.0 - v) * 100))) if v < 1.0 else ("+%d%%" % int(round((v - 1.0) * 100)))

func _effect_text(e: Dictionary) -> String:
	var out := []
	for k in e.get("set", {}):
		var v = e["set"][k]
		match k:
			"energyMax": out.append("energy max %d" % int(v))
			"energyPerRest": out.append("%s ⚡ per Rest answer" % _num(float(v)))
			"waterPerStep": out.append("+%s 💧 per question" % _num(float(v)))
			"waterCap": out.append("holds %d 💧" % int(v))
			"storageCap": out.append("holds %d of each item" % int(v))
			"patchCap": out.append("%d plants per patch" % int(v))
			"scare": out.append("chases %s pests per question" % _num(float(v)))
			"pestBlock": out.append("%d%% fewer pests get in" % int(round(float(v) * 100)))
			"bookSlots": out.append("holds %d books" % int(v))
			"waterMult": out.append("plants need %d%% water" % int(round(float(v) * 100)))
			_:
				if k.begins_with("cap_"): out.append("room for %d %s" % [int(v), k.substr(4)])
	for k in e.get("add", {}):
		var v2 := float(e["add"][k])
		if k == "energyPerRest": out.append("+%s ⚡ per Rest answer" % _num(v2))
		elif k == "energyMax": out.append("energy max +%d" % int(v2))
		elif k == "plots": out.append("+%d field patches" % int(v2))
		elif k == "waterPerStep": out.append("+%s 💧 per question" % _num(v2))
		elif k == "scare": out.append("chases %s more pests" % _num(v2))
		elif k == "sellBonusPct": out.append("+%d%% when selling" % int(v2))
		elif k.begins_with("slots:"): out.append("+%d batch at %s" % [int(v2), G.nodes.get(k.substr(6), {}).get("name", k.substr(6))])
		elif k.begins_with("yield_"): out.append("+%d %s per harvest" % [int(v2), G.iname(k.substr(6))])
		elif k == "shelfLife": out.append("food keeps %d season longer" % int(v2))
		else: out.append("%s +%s" % [k, _num(v2)])
	for k in e.get("mult", {}):
		var v3 := float(e["mult"][k])
		var parts: PackedStringArray = k.split(":")
		var kind: String = parts[0]
		var a: String = parts[1] if parts.size() > 1 else ""
		match kind:
			"energy": out.append("%s %s" % [CAT_LABEL.get(a, a), _pct(v3)])
			"water": out.append("%s water %s" % ["field" if a == "field" else "animal", _pct(v3)])
			"weeds": out.append("weeds %s" % _pct(v3))
			"grow": out.append("growing time %s" % _pct(v3))
			"pests": out.append("pests %s" % _pct(v3))
			"stones": out.append("stones %s" % _pct(v3))
			"fuel": out.append("firewood %s" % _pct(v3))
			"muck": out.append("muck %s" % _pct(v3))
			"read": out.append("reading time %s" % _pct(v3))
			"out": out.append("%s output %s" % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"feed": out.append("%s eat %s" % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"time": out.append("%s time %s" % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"in": out.append("%s needed %s" % [G.iname(parts[2]) if parts.size() > 2 else a, _pct(v3)])
			_: out.append("%s %s" % [k, _pct(v3)])
	for k in e.get("produces", {}): out.append("+1 %s every %d questions" % [G.iname(k), int(round(1.0 / maxf(0.01, float(e["produces"][k]))))])
	return ", ".join(out)

func _cost_bb(c: Dictionary) -> String:
	var parts := []
	for k in c:
		var need := float(c[k])
		var have: float = G.have(k)
		var col := "#3b6a26" if have + 0.0001 >= need else "#b9472f"
		var t := "%s%d" % [G.iemoji(k), G.up(need)]
		if have + 0.0001 < need and k != "energy": t += " (have %d)" % G.down(have)
		parts.append("[color=%s]%s[/color]" % [col, t])
	return "  ".join(parts)

## Costs as cube bars: filled = you have it, hollow = still missing, faint grey = saved by upgrades, practice and meals.
func _costs(c: Dictionary, base := {}) -> Control:
	return UI.cost_row(c, base, _have_any, _emoji_any, G.items)

func _have_any(k: String) -> float:
	if k == "fuel": return float(G.S["woodpile"])     # only what is on the woodpile burns: stoke it first
	return G.have(k)

func _emoji_any(k: String) -> String:
	if k == "fuel": return "🔥"
	return G.iemoji(k)

## How many questions until patch p is grown.
func _grow_left(a: String, p: Dictionary) -> int:
	var left: float = G.grow_target(p) - float(p["growth"])
	return maxi(1, int(ceil(left / maxf(0.05, G.grow_speed(a, p)) - 0.001)))

func _section(title: String, note := "") -> void:
	var l := UI.label(title, 20, UI.INK)
	content.add_child(l)
	if note != "": content.add_child(UI.label(note, 15, UI.MUTED, true))

## A picture for what the button of a goal does.
const VERB := {"building": "🔨", "station": "🔨", "tool": "🛠️", "gear": "🧵", "helper": "🔨", "land": "💪",
	"patch": "🟫", "delivery": "📦", "pet": "🐾", "sidequest": "🤝", "book": "🛒"}

func _node_row(id: String, show_button := true, show_place := false) -> PanelContainer:
	var n: Dictionary = G.nodes[id]
	var pc := UI.card()
	var v := UI.vbox(3)
	pc.add_child(v)
	var h := UI.hbox(6)
	v.add_child(h)
	h.add_child(UI.label("%s %s" % [n.get("emoji", ""), n["name"]], 19, UI.INK, true))
	if show_place:
		var sid := Spots.spot_of(G, id)
		var pb := UI.soft_button("📍 " + Spots.SPOTS.get(sid, [sid])[0], _go_spot.bind(sid), true, 15)
		h.add_child(pb)
	var ck: Dictionary = G.can_unlock(id)
	var steps: Array = G.steps_of(id)
	if show_button:
		var verb: String = VERB.get(n["type"], "✔")
		if steps.size() > 0: verb = str(steps[mini(G.step_index(id), steps.size() - 1)].get("emoji", verb))
		if n.get("perPatch", false): verb += " %d/%d" % [G.patch_progress(id), G.plots()]
		if str(ck.get("why", "")) == "wait":
			h.add_child(UI.wait_button(int(ck["wait"]), _show_time_quiz))      # the mortar is drying: wait for the next step
		else:
			var b := UI.action_button("", _do_unlock.bind(id), ck["ok"], UI.GREEN, verb, _node_word(id))
			h.add_child(b)
	if steps.size() > 0:
		# done in steps: how far it is (cubes) and what the next step is
		var sr := UI.hbox(6)
		sr.add_child(UI.explain(UI.stock_bar(float(G.step_index(id)), float(steps.size()), Color("7cc04a"), 160), "🔨 Steps done so far."))
		var nx: Dictionary = steps[mini(G.step_index(id), steps.size() - 1)]
		sr.add_child(UI.label("%s %s" % [nx.get("emoji", ""), nx.get("name", "")], 16, UI.INK, true))
		var gv := ""
		for k in nx.get("gives", {}): gv += G.iemoji(k).repeat(clampi(int(round(float(nx["gives"][k]))), 1, 5))
		if gv != "": sr.add_child(UI.label("→ " + gv, 16))
		if int(nx.get("wait", 0)) > 0 and G.step_index(id) < steps.size() - 1: sr.add_child(UI.label("then ⏳%d" % int(nx["wait"]), 15, UI.MUTED))
		v.add_child(sr)
	var c: Dictionary = G.node_cost(id)
	if not c.is_empty():
		if n.get("perPatch", false): v.add_child(UI.label("each patch:", 13, UI.MUTED))
		v.add_child(_costs(c, G.node_cost_base(id)))
	var d := str(n.get("desc", ""))
	if d != "": v.add_child(UI.label(d, 15, UI.MUTED, true))
	if G.flex_on() and not c.is_empty():
		var tip: String = G.flex_tip(id)       # dynamic difficulty: the improvement that makes this quicker
		if tip != "": v.add_child(UI.label("💡 Quicker with: %s %s" % [G.nodes[tip].get("emoji", ""), G.nodes[tip]["name"]], 15, UI.BLUE, true))
	if n.has("effects"):
		var et := _effect_text(n["effects"])
		if et != "": v.add_child(UI.label("✨ " + et, 15, UI.GREEN_DARK, true))
	return pc

## One word for a goal's button: the step's own word ("Lay", "Raise", "Pull" …), the node's "verb", or by its kind.
func _node_word(id: String) -> String:
	var n: Dictionary = G.nodes[id]
	if n.has("verb"): return str(n["verb"])
	var st: Array = G.steps_of(id)
	if st.size() > 0: return str(st[mini(G.step_index(id), st.size() - 1)].get("name", "Go")).split(" ")[0]
	var first := str(n["name"]).split(" ")[0]
	if first in ["Fill", "Dig", "Clear", "Clean", "Lay", "Plant", "Edge", "Mend", "Fix", "Feed", "Pull", "Root", "Oil", "Sharpen"]: return first
	match str(n["type"]):
		"building", "station", "helper", "patch": return "Build"
		"tool": return {"smith": "Forge", "wood": "Carve"}.get(G.node_cat(id), "Craft")
		"gear": return "Sew" if G.node_cat(id) == "textile" else "Craft"
		"land": return "Clear"
		"delivery": return "Give" if id.begins_with("present_") else "Deliver"
		"pet": return "Welcome"
		"sidequest": return "Help"
		"book": return "Buy"
		"knowledge": return "Learn"
		"animal": return "Buy"
	return "Go"

func _go_spot(sid: String) -> void:
	_open_sheet_for(sid)
	_pulse(sid)

func _do_unlock(id: String) -> void:
	G.unlock(id)

# ------------------------------------------------------------------ what a place shows
## A locked place with nothing within reach: only a weathered sign and a promise.
func _part_mystery() -> void:
	content.add_child(UI.header(Art.first("deco", ["mystery_sign", "signpost"]), "🪧", 130))
	var l := UI.label("Something stood here once…\nYou will find out what belongs here later — when you have what it needs.", 19, UI.MUTED, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(l)

## The picture at the top of a place's sheet: what stands there now (or the first thing built in a pen).
func _spot_header(sid: String) -> Control:
	if sid == "road": return UI.header(Art.first("map", _art_keys("road")), "🛤️", 90)
	var ms := _map_sid(sid)
	var tex: Texture2D = null
	if map.slots.has(ms) and map.slots[ms].visible and map.slots[ms].pic.texture: tex = map.slots[ms].pic.texture
	if Spots.parent_of(sid) != "" and _built(Spots.parent_of(sid)):
		var keys: Array = Spots.HOTSPOT_ART.get(sid, []).filter(func(id): return G.nodes.has(id) and G.done(id))
		keys.reverse()
		var kk := _first_key("interior", keys)
		tex = Art.tex("interior", kk) if kk != "" else null
	if tex == null and Spots.PENS.has(sid):
		for a in map.addon_nodes:
			if a["sid"] == sid and a["node"].visible: tex = a["node"].texture
	return UI.header(tex, _spot_emoji(sid), 100)

func _sheet_spot(sid: String) -> void:
	var head := _headline(sid)
	if head != "" and str(G.nodes[head].get("desc", "")) != "" and not (sid in ["market", "board"]):
		content.add_child(UI.label(str(G.nodes[head]["desc"]), 16, UI.MUTED, true))
	elif not _is_open(sid):
		content.add_child(UI.label("Build it to open this place.", 17, UI.MUTED, true))
	var lists := _goal_lists(sid)
	if sid != "market": _part_main_goals(sid, lists[0])   # what to do here comes first (the market: selling first, orders at the bottom)
	match sid:
		"living": _part_home()
		"library": _part_library()
		"storage": _part_pantry()
		"market": _part_market()
		"bookcart": _part_bookcart()
		"board": _part_jobs()
		"field": _part_field()
		"orchard": _part_area("orchard")
		"greenhouse": _part_area("gh")
		"pets": _part_pets()
		"kitchen", "forest": _part_woodpile()
		"pond", "well": _part_water(sid)
		"road": _part_road()
	for aid in Spots.nodes_at(G, sid):
		if G.nodes[aid]["type"] != "animal": continue
		if not G.missing_reqs(aid).is_empty() and not G.done(aid): continue
		content.add_child(_animal_card(aid))
	for root in G.stations():
		if Spots.in_spot(G, root, sid): content.add_child(_station_card(root))
	_part_more_goals(sid, lists[0], lists[1], lists[2])
	_part_polish_here(sid)
	if sid == "market": _part_main_goals(sid, lists[0])

## [main goals open now, optional upgrades open now, [id, missing] one step away] at a place.
func _goal_lists(sid: String) -> Array:
	var main := []
	var opt := []
	var soon := []
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not (n["type"] in GOAL_TYPES): continue
		if G.done(id) or G.satisfied(id) or not _in_chapter(id): continue
		var mr: Array = G.missing_reqs(id)
		if mr.is_empty():
			if n.get("optional", false): opt.append(id)
			else: main.append(id)
		elif mr.size() == 1 and not n.get("optional", false):
			soon.append([id, mr[0]])
	var key := func(a): return int(G.nodes[a].get("chapter", 1)) * 10 + (0 if G.can_unlock(a)["ok"] else 1)
	main.sort_custom(func(a, b): return key.call(a) < key.call(b))
	opt.sort_custom(func(a, b): return key.call(a) < key.call(b))
	return [main, opt, soon]

func _part_main_goals(sid: String, main: Array) -> void:
	if main.is_empty(): return
	_section("🤝 Favours for neighbours" if sid == "board" else ("📦 Orders to deliver" if sid == "market" else "🔨 To do here"),
		"Help someone: the reward is a picture for your album, and a bit of luck." if sid == "board" else "")
	for id in main: content.add_child(_node_row(id))

func _part_more_goals(sid: String, main: Array, opt: Array, soon: Array) -> void:
	if not opt.is_empty():
		_section("🧰 Upgrades (optional)", "Never required — they make work cheaper for good.")
		for id in opt: content.add_child(_node_row(id))
	# what comes later is not shown here: only what can be done now (the quest book has this chapter's next steps)

func _part_polish_here(sid: String) -> void:
	var ids := []
	for pid in G.polish_ids:
		if Spots.in_spot(G, pid, sid) and G.polish_open(pid): ids.append(pid)
	if ids.is_empty(): return
	_section("✨ Polish", "Sharpen, oil, clean… The first time helps most; every next time adds half as much and costs more. Use wears it off slowly.")
	for pid in ids: content.add_child(_polish_card(pid))

func _polish_card(pid: String) -> PanelContainer:
	var n: Dictionary = G.nodes[pid]
	var p: float = G.polish_level(pid)
	var pc := UI.card()
	var v := UI.vbox(2)
	pc.add_child(v)
	var h := UI.hbox(6)
	h.add_child(UI.label("%s %s" % [n.get("emoji", ""), n["name"]], 17, UI.INK, true))
	h.add_child(UI.explain(UI.bar(G.polish_gain(pid, p), 80, 10, UI.AMBER), "✨ How polished it is: the fuller, the stronger it works."))
	h.add_child(UI.label("%d%%→%d%%" % [int(round(G.polish_gain(pid, p) * 100)), int(round(G.polish_gain(pid, floorf(p) + 1.0) * 100))], 14, UI.MUTED))
	var c: Dictionary = G.polish_cost(pid)
	h.add_child(UI.button("✨ " + G.cost_text(c), G.do_polish.bind(pid), G.missing_cost(c).is_empty(), UI.AMBER, 15))
	v.add_child(h)
	v.add_child(UI.label("At full polish: " + _effect_text(n.get("effects", {})), 14, UI.GREEN_DARK, true))
	return pc

func _part_woodpile() -> void:
	var wp := UI.card(Color("f6ecd8"))
	var wv := UI.vbox(4)
	wp.add_child(wv)
	wv.add_child(UI.label("🪵 Woodpile: %d / %d fuel — ovens, kilns and the forge burn it; the house too in winter." % [G.down(G.S["woodpile"]), G.down(G.woodpile_cap())], 16, UI.INK, true))
	var wh := HFlowContainer.new()
	wv.add_child(wh)
	for k in G.meta.get("fuel", {}).get("values", {}):
		if G.count(k) >= 1.0:
			wh.add_child(UI.soft_button("+ %s %s (%d)" % [G.iemoji(k), G.iname(k), G.down(G.count(k))], _stack.bind(k), true, 16))
	content.add_child(wp)

func _stack(k: String) -> void:
	var n: float = G.stack_wood(k, G.count(k))
	if n > 0.0: G.say("🪵 Stacked %d %s on the woodpile." % [int(n), G.iname(k)])
	G.save_game(); _queue_refresh()

func _station_card(root: String) -> PanelContainer:
	var act: String = G.active_of(root)
	var n: Dictionary = G.nodes[act]
	var pc := UI.card()
	var v := UI.vbox(4)
	pc.add_child(v)
	var running: Array = G.S["running"].get(root, [])
	var stars: int = G.stars(root)
	var now: bool = G.output_now(root)      # gathering: things come at once, each spot then refills (hourglass in its row)
	v.add_child(UI.label("%s %s   %s" % [n.get("emoji", ""), n["name"], "⭐".repeat(stars)], 19, UI.INK, true))
	var soonest := 999
	for job in running: soonest = mini(soonest, G.up(job["left"]))
	var att := []
	for hid in G.nodes:
		if G.nodes[hid].has("attach") and G.chain_members(root).has(G.nodes[hid]["attach"]): att.append(hid)
	if att.size() > 0:
		var ah := HFlowContainer.new()
		ah.add_child(UI.label("Choice slot: ", 14, UI.MUTED))
		for hid in att:
			var hn: Dictionary = G.nodes[hid]
			if G.done(hid):
				var active: bool = G.S["attach"].get(hn["attach"], "") == hid
				if active: ah.add_child(UI.button("✔ " + hn.get("emoji", "") + " " + hn["name"], Callable(), true, UI.GREEN, 14))
				else: ah.add_child(UI.soft_button("use " + hn.get("emoji", "") + " " + hn["name"], G.set_attach.bind(hn["attach"], hid), true, 14))
			else:
				ah.add_child(UI.label("(%s %s: build it below) " % [hn.get("emoji", ""), hn["name"]], 13, UI.MUTED))
		v.add_child(ah)
	for rid in G.station_recipes_for(root):
		var r: Dictionary = G.recipes[rid]
		var title := str(r.get("name", G.iname(r["outputs"].keys()[0])))
		if not G.recipe_open(rid):
			var why := []
			var later := false
			for q in r.get("requires", []):
				if not G.satisfied(q):
					why.append(G.nodes[q].get("emoji", "") + " " + G.nodes[q]["name"])
					if not _in_chapter(q) or not G.missing_reqs(q).is_empty(): later = true
			if not later: v.add_child(UI.label("🔒 %s — needs %s" % [title, ", ".join(why)], 14, UI.MUTED, true))
			continue
		var row := UI.hbox(6)
		var outs := []
		var batch: int = G.recipe_batch(rid)     # carrying gear: a bigger load per tap (and more energy)
		for k in r["outputs"]: outs.append("%s%s" % [G.iemoji(k), _num(float(r["outputs"][k]) * G.m("out:" + r["station"]) * batch)])
		var pay: Dictionary = G.recipe_cost(rid)
		var c: Dictionary = pay.duplicate()
		var base: Dictionary = G.recipe_cost_base(rid)
		var fuel: float = G.recipe_fuel(rid)
		if fuel > 0.0:
			c["fuel"] = fuel
			base["fuel"] = float(r.get("fuel", 0))
		var extra := []
		var tm: float = G.recipe_time(rid)
		if batch > 1: extra.append("🧺×%d" % batch)
		if tm > 0.0: extra.append("⏳%d" % G.up(tm))
		for k in r.get("keeps", []): extra.append("keeps %s" % G.iemoji(k))
		var wv: Vector2 = G.recipe_worth(rid)
		if wv.y > 0.0: extra.append("[color=#3c8a3c]🪙%s → 🪙%s[/color]" % [_num(wv.x), _num(wv.y)])
		var rv := UI.vbox(2)
		rv.add_child(UI.rich("[b]%s[/b] → %s  [color=#7a705c]%s[/color]" % [title, " ".join(outs), " ".join(extra)], 16))
		rv.add_child(_costs(c, base))
		row.add_child(rv)
		var have_all: bool = G.missing_cost(G.recipe_cost(rid, 1)).is_empty() and _have_any("fuel") + 0.001 >= fuel   # a smaller load still works
		# everything else is there, only the woodpile needs wood first: then the button stokes it
		var stoke_now: bool = fuel > 0.0 and _have_any("fuel") + 0.001 < fuel and G.missing_cost(G.recipe_cost(rid, 1)).is_empty()
		var left: float = G.recipe_left(rid)
		if left > 0.0:
			row.add_child(UI.wait_button(G.up(left), _show_time_quiz))                         # this one is cooking / refilling
		elif running.size() >= G.station_slots(root):
			row.add_child(UI.wait_button(soonest if soonest < 999 else 1, _show_time_quiz))    # busy: wait for a batch
		elif stoke_now:
			var can: bool = G.fuel_in_store() + float(G.S["woodpile"]) + 0.001 >= fuel
			var sb := UI.action_button("cook", _stoke.bind(fuel), can, UI.AMBER, "🪵", "Stoke" if can else "Need wood")
			sb.tooltip_text = "Put wood on the woodpile first: %d fuel." % G.up(fuel)
			row.add_child(sb)
		else:
			row.add_child(UI.action_button(G.recipe_cat(rid), G.start_recipe.bind(rid), have_all, UI.GREEN, "", str(r.get("verb", ""))))
		v.add_child(row)
	return pc

func _do_cut_tree(a: String, i: int) -> void:
	if G.cut_tree(a, i): _open_sheet("patch:%s:%d" % [a, i])

func _toggle_flex() -> void:
	G.toggle_flex()
	_close_modal()
	_show_menu()

func _stoke(need: float) -> void:
	G.stoke(need)
	_queue_refresh()

func _animal_card(aid: String) -> PanelContainer:
	var n: Dictionary = G.nodes[aid]
	var a: Dictionary = G.animal(aid)
	var pc := UI.card()
	var v := UI.vbox(4)
	pc.add_child(v)
	var h := UI.hbox(6)
	v.add_child(h)
	h.add_child(UI.label("%s %s  %d / %d" % [n.get("emoji", ""), n["name"], int(a["count"]), G.animal_cap(aid)], 20, UI.INK, true))
	var can_buy: bool = int(a["count"]) < G.animal_cap(aid) and G.missing_cost(G.animal_price(aid)).is_empty()
	h.add_child(UI.button("Buy one  " + G.cost_text(G.animal_price(aid)), G.buy_animal.bind(aid), can_buy, UI.GREEN, 16))
	v.add_child(UI.label(str(n.get("desc", "")), 15, UI.MUTED, true))
	if G.animal_cap(aid) <= 0: v.add_child(UI.label("No room yet: build them a home first.", 15, UI.RED, true))
	if int(a["count"]) > 0:
		var ready: bool = G.S["step"] >= int(a["ready"])
		var row := UI.hbox(6)
		row.add_child(_costs(G.feed_needs(aid), _feed_base(aid)))
		if ready:
			var cb := UI.action_button("animal", G.collect_animal.bind(aid), true)
			row.add_child(cb)
		else:
			row.add_child(UI.wait_button(int(a["ready"]) - G.S["step"], _show_time_quiz))
		v.add_child(row)
		if n.get("needsFlowers", false):
			v.add_child(UI.label("🌼 Flowers on the farm: %s" % ("yes" if G.has_flowers() else "none — plant clover, flax or sunflowers"), 15, UI.GREEN_DARK if G.has_flowers() else UI.RED, true))
		if float(n.get("muck", 0.0)) > 0.0:
			var mf: float = G.muck_factor(aid)
			var mrow := UI.hbox(6)
			mrow.add_child(UI.label("💩 Muck %d %s" % [G.down(a["muck"]), "" if mf >= 1.0 else "— animals give %d%% less!" % int(round((1.0 - mf) * 100))], 16, UI.INK if mf >= 1.0 else UI.RED, true))
			mrow.add_child(_costs({"energy": G.ecost("animal", float(a["muck"]) * 0.5)}, {"energy": float(a["muck"]) * 0.5}))
			mrow.add_child(UI.action_button("animal", G.muck_out.bind(aid), float(a["muck"]) >= 0.5, UI.SOIL, "🧹", "Clean"))
			v.add_child(mrow)
	return pc

## What a collection would need without any upgrade (to show the saving as grey cubes).
func _feed_base(aid: String) -> Dictionary:
	var n: Dictionary = G.nodes[aid]
	var cnt := int(G.animal(aid)["count"])
	var out := {}
	for k in n.get("feed", {}): out[k] = float(n["feed"][k]) * cnt
	if float(n.get("feedWater", 0)) > 0.0: out["water"] = float(n["feedWater"]) * cnt
	out["energy"] = float(n.get("collectEnergy", 1)) * cnt
	return out

const GEAR_SLOTS := [["feet", "👣"], ["hands", "🧤"], ["back", "🎒"], ["bottle", "🫗"], ["head", "👒"], ["apron", "🥼"], ["pillow", "🛌"], ["bed", "🛏️"]]

func _part_home() -> void:
	var rc := UI.card(Color("e8f0f7"))
	var rv := UI.vbox(4)
	rc.add_child(rv)
	var eh := UI.hbox(6)
	eh.add_child(UI.label("⚡", 22))
	eh.add_child(UI.explain(UI.stock_bar(float(G.S["energy"]), G.energy_max(), UI.item_color("energy")), "⚡ Your energy: work uses it, rest fills it."))
	rv.add_child(eh)
	var rb := UI.button("😴 Rest", _show_rest, true, UI.BLUE, 19)
	rb.custom_minimum_size = Vector2(0, 50)
	rv.add_child(rb)
	content.add_child(rc)
	var foods := []
	for k in G.S["inv"]:
		if G.items.has(k) and G.items[k].has("buff") and G.count(k) >= 1.0: foods.append(k)
	if foods.size() > 0:
		_section("😋 Eat something", "A good meal makes work cheaper for the next few questions.")
		for k in foods:
			var it: Dictionary = G.items[k]
			var row := UI.hbox(6)
			row.add_child(UI.label("%s %s × %d" % [it.get("emoji", ""), it["name"], G.down(G.count(k))], 17, UI.INK, true))
			row.add_child(UI.soft_button("😋 Eat (−%d%% ⚡ for %d)" % [int(round((1.0 - float(it["buff"]["energy"])) * 100)), int(it["buff"]["questions"])], G.eat.bind(k), true, 16))
			content.add_child(row)
	var worn := []
	for s in GEAR_SLOTS:
		var cur := ""
		for id in Spots.nodes_at(G, "living"):
			if str(G.nodes[id].get("slot", "")) == "gear:" + s[0] and G.nodes[id]["type"] in ["gear", "helper"] and G.done(id): cur = id
		worn.append("%s %s" % [s[1], G.nodes[cur]["name"] if cur != "" else "—"])
	_section("👕 What you wear and sleep on")
	content.add_child(UI.label("   ".join(worn), 15, UI.INK, true))

func _part_field() -> void:
	var pc := UI.card(Color("f3f7ea"))
	var pv := UI.vbox(4)
	pc.add_child(pv)
	var r1 := UI.hbox(8)
	var n_p: int = G.down(float(G.S["pests"]) + 0.5)
	r1.add_child(UI.label("🐦" if n_p > 0 else "🐦 0", 22))
	if n_p > 0: r1.add_child(UI.explain(UI.stock_bar(float(G.S["pests"]), maxf(4.0, ceilf(float(G.S["pests"]))), Color("8a6f5f"), 200), "🐦 Pests on the farm: they nibble what grows."))
	r1.add_child(UI.label("eat %d%% 🌾 each question" % int(round(G.pest_eat_share() * 100.0)), 17, UI.RED if G.pest_eat_share() >= 0.05 else UI.MUTED))
	pv.add_child(r1)
	var r2 := UI.hbox(8)
	r2.add_child(UI.label("🧍", 22))
	if G.pest_scare() > 0.0: r2.add_child(UI.explain(UI.stock_bar(G.pest_scare(), G.pest_scare(), Color("c98a12"), 160), "🧍 Pests chased away every question."))
	else: r2.add_child(UI.label("—", 18, UI.MUTED))
	if G.pest_block() > 0.0:
		r2.add_child(UI.label("🚧 %d%%" % int(round(G.pest_block() * 100)), 17))
	pv.add_child(r2)
	content.add_child(pc)
	var qa := HFlowContainer.new()
	qa.add_child(UI.soft_button("🌿 Weed all", func(): G.weed_field(field_idx), true, 17))
	qa.add_child(UI.soft_button("🪨 Pick stones", _pick_all, true, 17))
	content.add_child(qa)

func _part_area(a: String) -> void:
	var arr: Array = G.area(a)
	if arr.is_empty(): return
	var fv = FieldView.new()
	fv.area_name = a
	fv.custom_minimum_size = Vector2(0, 110 * int(ceil(arr.size() / 3.0)))
	content.add_child(fv)
	fv.patch_pressed.connect(_on_patch)
	content.add_child(UI.button("🧺 Harvest all", _harvest_all.bind(a), _ready_count(a) > 0, UI.GREEN, 18))

## Water: how much there is (cubes), and the bucket trips to the wild pond.
func _part_water(sid: String) -> void:
	var wc := UI.card(Color("e8f2f8"))
	var wv := UI.vbox(6)
	wc.add_child(wv)
	var wr := UI.hbox(8)
	wr.add_child(UI.label("💧", 24))
	wr.add_child(UI.explain(UI.stock_bar(float(G.S["water"]), G.water_cap(), UI.item_color("water"), 320), "💧 Water you carry: planting and cooking use it."))
	wv.add_child(wr)
	wv.add_child(UI.label("🪣 Every trip brings %s 💧 · holds %s" % [_num(G.fetch_amount()), _num(G.water_cap())], 16, UI.INK, true))
	if G.S.get("rain", false): wv.add_child(UI.label("🌧️ It rained: planting costs no water until the next question.", 15, UI.GREEN_DARK, true))
	var fr := UI.hbox(8)
	var room: float = G.water_cap() - float(G.S["water"])
	var fb := UI.button("🪣  %s" % "💧".repeat(clampi(int(round(minf(room, G.fetch_amount()))), 1, 8)), _fetch_water, room >= 0.5, UI.BLUE, 22)
	fb.custom_minimum_size = Vector2(0, 54)
	fb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fr.add_child(fb)
	fr.add_child(_costs({"energy": G.fetch_cost()}, {"energy": float(G.meta.get("water", {}).get("fetchEnergy", 1.0))}))
	wv.add_child(fr)
	content.add_child(wc)
	if sid == "pond" and not G.done("pond"):
		content.add_child(UI.label("A wild pond, full of reeds. Someday it could be dug out again.", 15, UI.MUTED, true))

func _fetch_water() -> void:
	G.fetch_water()

## The road: how good it is, and who can come along it to the market.
func _part_road() -> void:
	var lv := int(round(G.g("roadLevel", 1.0)))
	var rc := UI.card(Color("f6efe0"))
	var rv := UI.vbox(4)
	rc.add_child(rv)
	var stars := UI.hbox(4)
	for i in range(5): stars.add_child(UI.label("🟫" if i < lv else "▫️", 22))
	rv.add_child(stars)
	var who := []
	for mid in G.nodes:
		var mn: Dictionary = G.nodes[mid]
		if mn["type"] == "merchant" and G.done(mid): who.append(str(mn.get("emoji", "🧑")))
	if who.size() > 0: rv.add_child(UI.label("Coming to your market:  " + " ".join(who), 17, UI.INK, true))
	var blocked := 0
	for mid in G.nodes:
		var mn2: Dictionary = G.nodes[mid]
		if mn2["type"] != "merchant" or G.done(mid) or not _in_chapter(mid): continue
		var road_only := false
		var other := false
		for q in mn2.get("requires", []):
			if G.satisfied(q): continue
			if str(q).begins_with("road_"): road_only = true
			else: other = true
		if road_only and not other: blocked += 1
	if blocked > 0: rv.add_child(UI.label("🚧 %s can't get through yet — a better road lets them come." % "🧑‍🌾".repeat(mini(blocked, 5)), 16, UI.RED, true))
	content.add_child(rc)

func _part_pets() -> void:
	var any := false
	for pid in PETS:
		if not G.done(pid): continue
		any = true
		var n: Dictionary = G.nodes[pid]
		var row := UI.hbox(6)
		row.add_child(UI.label("%s %s — %s" % [n.get("emoji", ""), G.S["pet_names"].get(pid, n.get("defaultName", "")), _effect_text(n.get("effects", {}))], 17, UI.INK, true))
		row.add_child(UI.soft_button("✏️ Name", _show_name.bind(pid, str(G.S["pet_names"].get(pid, n.get("defaultName", "")))), true, 15))
		content.add_child(row)
	if not any: content.add_child(UI.label("Your first pet, a bunny, comes home at the end of chapter 1.", 16, UI.MUTED, true))

func _part_jobs() -> void:
	_section("📋 Little jobs", "A few coins and a bit of luck for each.")
	for j in G.S["jobs"]:
		var h := UI.hbox(6)
		h.add_child(UI.label("• " + str(j["text"]), 17, UI.INK, true))
		h.add_child(UI.label("%d/%d" % [G.down(float(j["got"])), int(j["n"])], 17, UI.MUTED))
		content.add_child(h)

const CAT_ORDER := ["crop", "animal", "ingredient", "dish", "material", "textile", "fertilizer", "byproduct", "feed", "fuel", "container", "craft", "find", "seed", "keeper", "pet-item"]

## A grid for long lists (the store, the market): 3 tiles in a row (4 on wide screens).
func _grid() -> GridContainer:
	var g := GridContainer.new()
	g.columns = 4 if size.x >= 900 else 3
	g.add_theme_constant_override("h_separation", 8)
	g.add_theme_constant_override("v_separation", 8)
	return g

## One tile of a grid: a picture (or emoji), a name, and room below for amounts and buttons.
func _tile(pic: Texture2D, emoji: String, title: String, bg := UI.PAPER) -> VBoxContainer:
	var pc := UI.card(bg)
	pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := UI.vbox(3)
	pc.add_child(v)
	var top := UI.hbox(6)
	if pic:
		var tr := TextureRect.new()
		tr.texture = pic
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.custom_minimum_size = Vector2(40, 40)
		top.add_child(tr)
	else:
		top.add_child(UI.label(emoji, 28))
	var tl := UI.label(title, 14, UI.MUTED, true)
	tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(tl)
	v.add_child(top)
	v.set_meta("panel", pc)
	return v

func _part_pantry() -> void:
	var ready_n := _ready_count("field") + _ready_count("orchard") + _ready_count("gh")
	var hb := UI.button("🧺 Harvest all  (%d ready)" % ready_n if ready_n > 0 else "🧺 Harvest all — nothing is ready yet", _harvest_everything, ready_n > 0, UI.GREEN, 20)
	hb.custom_minimum_size = Vector2(0, 58)
	content.add_child(hb)
	_section("🧺 What you have", "🍂 = goes stale at the next change of season — sell it, eat it or cook it into something that keeps. 🪙 = what one sells for; ↓ = the market has had lots of it lately and pays less for a while.")
	var grid := _grid()
	content.add_child(grid)
	var cap: float = G.storage_cap()
	var keys: Array = G.S["inv"].keys()
	keys.sort_custom(func(a, b):
		return CAT_ORDER.find(G.items[a].get("category", "")) * 1000 + G.items.keys().find(a) < CAT_ORDER.find(G.items[b].get("category", "")) * 1000 + G.items.keys().find(b))
	for k in keys:
		var q: float = G.count(k)
		if q < 0.999 and G.items[k].get("category", "") != "keeper": continue
		var it: Dictionary = G.items[k]
		var v := _tile(Art.first("items", [k]), str(it.get("emoji", "")), str(it["name"]) + ("  🍂" if G.stale_soon(k) >= 1.0 else ""))
		var keeper: bool = it.get("category", "") == "keeper"
		v.add_child(UI.explain(UI.stock_bar(q, q if keeper else cap, UI.item_color(k, G.items), 190),
			("%s %d %s" % [str(it.get("emoji", "")), G.down(q), str(it["name"])]) + ("" if keeper else " — your store holds %d of each." % G.down(cap))))
		var row := HFlowContainer.new()
		if it.has("buff"): row.add_child(UI.soft_button("😋", G.eat.bind(k), true, 20))
		if G.fuel_value(k) > 0.0: row.add_child(UI.soft_button("🔥", _stack.bind(k), true, 20))
		if G.sellable(k):
			# "1 🥣 = 4 🪙" and "5 🥕 = 10 🪙": what you give and what you get
			var em := str(it.get("emoji", "📦"))
			var have: int = G.down(q)
			row.add_child(UI.soft_button("1 %s = %d 🪙" % [em, G.down(G.sell_total(k, 1))], G.sell.bind(k, 1.0), true, 17))
			if have > 1: row.add_child(UI.soft_button("%d %s = %d 🪙" % [have, em, G.down(G.sell_total(k, have))], G.sell.bind(k, 999.0), true, 17))
			if G.demand_factor(k) < 0.999: v.add_child(UI.label("↓ lots sold lately — pays less for a while", 13, Color("b5562b"), true))
		if row.get_child_count() > 0: v.add_child(row)
		grid.add_child(v.get_meta("panel"))
	var seeds := []
	for cid in G.S["seeds"]:
		if float(G.S["seeds"][cid]) >= 1.0: seeds.append(cid)
	if seeds.size() > 0:
		_section("🌱 Seeds")
		var sg := _grid()
		content.add_child(sg)
		for cid in seeds:
			var sv := _tile(Art.tex("crops", cid), str(G.nodes[cid].get("emoji", "")), str(G.nodes[cid]["name"]))
			sv.add_child(UI.explain(UI.stock_bar(float(G.S["seeds"][cid]), maxf(10.0, ceilf(float(G.S["seeds"][cid]))), Color("a3c26a"), 190), "🌰 Seeds you have to plant."))
			sg.add_child(sv.get_meta("panel"))

func _harvest_everything() -> void:
	var n := _ready_count("field") + _ready_count("orchard") + _ready_count("gh")
	for a in ["field", "orchard", "gh"]: _harvest_all(a)
	if n > 0 and G.perk_on("perk_confetti"):
		var fx = UI.Celebration.new()
		add_child(fx)
		fx.size = size
		fx.start("confetti", size / 2.0)

func _part_market() -> void:
	_section("🌱 Seed merchant", "Only seeds you have can be planted — buy them here.")
	var sg := _grid()
	content.add_child(sg)
	for cid in G.nodes:
		var n: Dictionary = G.nodes[cid]
		if n["type"] != "crop" or not G.done(cid) or n.has("seedItem"): continue
		var v := _tile(Art.tex("crops", cid), str(n.get("emoji", "")), "%s\n🪙%s · 🌰 %d" % [n["name"], str(n.get("seedCost", 0)), G.down(G.seed_have(cid))])
		var row := UI.hbox(6)
		row.add_child(UI.soft_button("🛒 1", G.buy_seeds.bind(cid, 1), G.S["coins"] + 0.001 >= float(n.get("seedCost", 0)), 18))
		row.add_child(UI.soft_button("🛒 5", G.buy_seeds.bind(cid, 5), G.S["coins"] + 0.001 >= 5.0 * float(n.get("seedCost", 0)), 18))
		v.add_child(row)
		sg.add_child(v.get_meta("panel"))
	for mid in G.nodes:
		var mn: Dictionary = G.nodes[mid]
		if mn["type"] != "merchant" or not G.done(mid) or mid == "book_cart": continue
		if mn.get("sells", {}).is_empty() and mn.get("barter", {}).is_empty(): continue
		_section("%s %s" % [mn.get("emoji", ""), mn["name"]], str(mn.get("desc", "")))
		var mg := _grid()
		content.add_child(mg)
		for k in mn.get("sells", {}):
			var v2 := _tile(Art.first("items", [k]), G.iemoji(k), "%s\n🪙%s" % [G.iname(k), str(mn["sells"][k])])
			var row2 := UI.hbox(6)
			row2.add_child(UI.soft_button("🛒 1", G.buy_item.bind(mid, k, 1), true, 18))
			row2.add_child(UI.soft_button("🛒 5", G.buy_item.bind(mid, k, 5), true, 18))
			v2.add_child(row2)
			mg.add_child(v2.get_meta("panel"))
		for k in mn.get("barter", {}):
			var row3 := UI.hbox(6)
			var c := {}
			for x in mn["barter"][k]: c[x] = float(mn["barter"][k][x])
			var bq := int(mn.get("barterGives", {}).get(k, 1))
			row3.add_child(UI.rich("%s%s %s  for  %s" % ["%d × " % bq if bq > 1 else "", G.iemoji(k), G.iname(k), _cost_bb(c)], 17))
			row3.add_child(UI.soft_button("🤝", G.barter.bind(mid, k), true, 20))
			content.add_child(row3)

func _part_bookcart() -> void:
	if not G.done("book_cart"):
		var mr: Array = G.missing_reqs("book_cart")
		content.add_child(UI.label("The book cart comes by once you have: " + ", ".join(mr), 17, UI.MUTED, true))
		return
	content.add_child(UI.label("Books hold new cards. Your library holds %d books (%d now)." % [int(round(G.g("bookSlots", 1.0))), G.books_owned()], 16, UI.MUTED, true))
	var books := []
	for bid in G.nodes:
		if G.nodes[bid]["type"] == "book" and not G.done(bid) and _in_chapter(bid): books.append(bid)
	books.sort_custom(func(a, b): return int(G.nodes[a]["chapter"]) < int(G.nodes[b]["chapter"]))
	for bid in books:
		var bn: Dictionary = G.nodes[bid]
		var ck: Dictionary = G.can_unlock(bid)
		var pc := UI.card()
		var v := UI.vbox(2)
		pc.add_child(v)
		var row := UI.hbox(6)
		row.add_child(UI.label("%s %s — %s" % [bn.get("emoji", ""), bn["name"], bn.get("desc", "")], 16, UI.INK if ck["ok"] else UI.MUTED, true))
		row.add_child(UI.button("Buy", _do_unlock.bind(bid), ck["ok"], UI.GREEN, 16))
		v.add_child(row)
		v.add_child(_costs(G.node_cost(bid)))
		if not ck["ok"] and not G.missing_reqs(bid).is_empty(): v.add_child(UI.label(str(ck["why"]), 14, UI.MUTED, true))
		content.add_child(pc)

func _part_library() -> void:
	content.add_child(UI.label("%d / %d books · %d of %d cards learned. Read a card (takes a few Time Quiz questions), then answer its quiz. Due reviews pop up in the Time Quiz." % [G.books_owned(), int(round(G.g("bookSlots", 1.0))), G.cards_learned(), G.card_ids.size()], 16, UI.MUTED, true))
	if G.S["reading"] != "":
		var rc: String = G.S["reading"]
		var row := UI.hbox(8)
		row.add_child(UI.label("📖 %s" % G.nodes[rc]["name"], 18))
		row.add_child(UI.explain(UI.stock_bar(float(G.S["read_progress"]), ceilf(G.read_needed(rc)), UI.BLUE, 160), "📖 Pages read: each Time Quiz question turns one."))
		row.add_child(UI.wait_button(maxi(1, G.up(G.read_needed(rc) - float(G.S["read_progress"]))), _show_time_quiz))
		content.add_child(row)
	var due: int = G.due_cards().size()
	if due > 0: content.add_child(UI.label("🔁 %d card%s due for a review — they'll show up in the Time Quiz." % [due, "" if due == 1 else "s"], 16, UI.BLUE, true))
	for bid in G.nodes:
		if G.nodes[bid]["type"] != "book" or not G.done(bid): continue
		var bn2: Dictionary = G.nodes[bid]
		_section("%s %s" % [bn2.get("emoji", ""), bn2["name"]])
		for cid in G.card_ids:
			if G.nodes[cid]["requires"][0] != bid: continue
			if not _in_chapter(cid) and not G.done(cid): continue
			content.add_child(_card_row(cid))

## Starting to read a card shows its page at once (and the reading takes a few Time Quiz questions).
func _start_reading(cid: String) -> void:
	if G.start_reading(cid): _card_page(cid)

func _card_row(cid: String) -> HBoxContainer:
	var n: Dictionary = G.nodes[cid]
	var st: String = G.card_status(cid)
	var row := UI.hbox(6)
	var t := "%s %s" % [n.get("emoji", ""), n["name"]]
	match st:
		"learned":
			var box_n := int(G.S["cards"].get(cid, {}).get("box", 1))
			row.add_child(UI.label("✅ " + t + "  " + "⭐".repeat(box_n), 17, UI.GREEN_DARK, true))
			row.add_child(UI.soft_button("📖", _card_page.bind(cid), true, 20))
		"quiz":
			row.add_child(UI.label("❓ " + t, 17, UI.INK, true))
			var qb := UI.button("❓", _show_card.bind(cid), true, UI.GREEN, 22)
			qb.custom_minimum_size = Vector2(0, 46)
			row.add_child(qb)
		"reading":
			row.add_child(UI.label("📖 " + t, 17, UI.BLUE, true))
			row.add_child(UI.explain(UI.stock_bar(float(G.S["read_progress"]), ceilf(G.read_needed(cid)), UI.BLUE, 120), "📖 Pages read: each Time Quiz question turns one."))
			row.add_child(UI.wait_button(maxi(1, G.up(G.read_needed(cid) - float(G.S["read_progress"]))), _show_time_quiz))
		"readable":
			var rq: int = G.up(G.read_needed(cid) * G.m("read"))
			row.add_child(UI.label("📖 %s  (reading takes %d question%s)" % [t, rq, "" if rq == 1 else "s"], 17, UI.INK, true))
			var sb := UI.button("📖", _start_reading.bind(cid), G.S["reading"] == "", UI.BLUE, 22)
			sb.custom_minimum_size = Vector2(0, 46)
			row.add_child(sb)
		"prereq":
			var miss := []
			for r in n["requires"]:
				if not G.satisfied(r): miss.append(G.nodes[r]["name"])
			row.add_child(UI.label("🔒 %s — first: %s" % [t, ", ".join(miss)], 15, UI.MUTED, true))
		"discover":
			var miss2 := []
			for k in n.get("discover", []):
				if not G.S["seen"].has(k): miss2.append(G.iemoji(k) + " " + G.iname(k))
			row.add_child(UI.label("🔍 %s — find %s first" % [t, ", ".join(miss2)], 15, UI.MUTED, true))
		_:
			row.add_child(UI.label("🔒 " + t, 15, UI.MUTED, true))
	return row

# ------------------------------------------------------------------ quest book, album, log
func _sheet_goals() -> void:
	var main := []
	var opt := []
	var side := []
	var soon := []
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		var t: String = n["type"]
		if t in ["knowledge", "book", "polish", "animal", "crop", "merchant"]: continue
		if G.done(id) or G.satisfied(id) or not _in_chapter(id): continue
		var mr: Array = G.missing_reqs(id)
		if mr.is_empty():
			if t == "sidequest": side.append(id)
			elif n.get("optional", false): opt.append(id)
			else: main.append(id)
		elif mr.size() == 1 and not n.get("optional", false) and t != "sidequest":
			soon.append([id, mr[0]])
	var key := func(a): return int(G.nodes[a].get("chapter", 1)) * 10 + (0 if G.can_unlock(a)["ok"] else 1)
	main.sort_custom(func(a, b): return key.call(a) < key.call(b))
	opt.sort_custom(func(a, b): return key.call(a) < key.call(b))
	var few: bool = G.friends().size() < 2
	if few and not side.is_empty():
		_section("⭐ Recommended: help a neighbour", "People you help become your friends — and friends send postcards with a gift when they hear of your successes.")
		for id in side: content.add_child(_node_row(id, true, true))
	_section("🎯 Next goals", "Build, make and deliver these to move the story on. Green costs you have, red ones you still need. 📍 shows where.")
	if main.is_empty(): content.add_child(UI.label("Nothing open right now — learn a new card in the 📦 library, or keep farming.", 16, UI.MUTED, true))
	for id in main: content.add_child(_node_row(id, true, true))
	if not side.is_empty() and not few:
		_section("🤝 Favours for neighbours", "Friends send postcards with gifts.")
		for id in side: content.add_child(_node_row(id, true, true))
	if not opt.is_empty():
		_section("🧰 Upgrades (optional)", "Never required — they make work cheaper for good.")
		for id in opt: content.add_child(_node_row(id, true, true))
	if not soon.is_empty():
		_section("🔒 Coming up", "One thing missing for each of these.")
		for pair in soon.slice(0, 8):
			var n2: Dictionary = G.nodes[pair[0]]
			content.add_child(UI.label("%s %s — needs %s" % [n2.get("emoji", ""), n2["name"], pair[1]], 15, UI.MUTED, true))

func _sheet_album() -> void:
	_section("🐾 Pets")
	_part_pets()
	_section("🖼️ Pictures", "Every favour you do for a neighbour gives a picture.")
	for a in G.S["album"]:
		var pc := UI.card(Color("fff6e0"))
		var av := UI.vbox(4)
		pc.add_child(av)
		var atex: Texture2D = Art.first("album", [str(a.get("id", ""))])     # assets/album/<side quest>.png when drawn
		if atex:
			var tr := TextureRect.new()
			tr.texture = atex
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr.custom_minimum_size = Vector2(0, 180)
			av.add_child(tr)
		av.add_child(UI.label("%s  %s" % [a.get("emoji", "🖼️"), a["text"]], 17, UI.INK, true))
		content.add_child(pc)
	_section("🏅 Sum medals", "🥉 level passed · 🥈 every task quick · 🥇 still quick a week later · 🏆 a whole section silver · 👑 all gold")
	for cs in G.math.overview(G._learn()):
		if not cs["active"]: continue
		content.add_child(UI.label("%s %s — %s" % [cs["emoji"], cs["name"], cs["rank"]], 19, UI.INK, true))
		for ss in cs["sections"]:
			# the medals won so far, and only the next one to win (the level being learned now)
			content.add_child(UI.label("%s %s%s%s" % [ss["emoji"], ss["name"], "  🏆" if ss["trophy"] else "", " 👑" if ss["crown"] else ""], 16, UI.MUTED))
			var fl := HFlowContainer.new()
			fl.add_theme_constant_override("h_separation", 10)
			fl.add_theme_constant_override("v_separation", 10)
			var next_shown := false
			for lv in ss["levels"]:
				if lv["bronze"]:
					fl.add_child(_medal_tile("🥇" if lv["gold"] else ("🥈" if lv["silver"] else "🥉"), lv, false))
				elif lv["current"] and not next_shown:
					fl.add_child(_medal_tile("🥉", lv, true))
					next_shown = true
			if fl.get_child_count() > 0: content.add_child(fl)
	var acorns: Array = G.meta.get("acorns", {}).get("list", [])
	_section("🌰 Golden acorns: %d / %d" % [G.S["acorns"].size(), acorns.size()], "Each one gives +3 energy max for good. They hide in different places.")
	var hidden_shown := false
	for a in acorns:
		if G.S["acorns"].has(a["id"]): content.add_child(UI.label("🌰 " + str(a["name"]), 17))
		elif not hidden_shown:
			content.add_child(UI.label("❔ The next one is still hidden somewhere…", 17, UI.MUTED))
			hidden_shown = true
	var fr: Array = G.friends()
	_section("🤝 Friends: %d" % fr.size(), "The people you helped. When they hear of your successes, they send postcards with a gift.")
	if fr.is_empty(): content.add_child(UI.label("No friends yet — help a neighbour (📖 Quest book)!", 16, UI.MUTED, true))
	else:
		var ff := HFlowContainer.new()
		ff.add_theme_constant_override("h_separation", 6)
		ff.add_theme_constant_override("v_separation", 6)
		for f in fr: ff.add_child(UI.pill("%s %s" % [f["emoji"], f["name"]], 15))
		content.add_child(ff)
	var pcs: Array = G.S.get("postcards", [])
	if not pcs.is_empty():
		_section("💌 Postcards: %d" % pcs.size())
		for i in range(pcs.size() - 1, -1, -1): content.add_child(_postcard(pcs[i], true))
	_section("✨ Perks", "Little extras for favours and achievements. Tap to switch one on or off.")
	var pg := _grid()
	content.add_child(pg)
	var next_perk := false      # only the next perk to earn is shown, as a surprise
	for p in G.meta.get("perks", {}).get("list", []):
		var pid: String = p["id"]
		if G.perk_owned(pid):
			var on: bool = G.perk_on(pid)
			var pv := _tile(null, str(p.get("emoji", "✨")), "%s\n%s" % [p["name"], p.get("desc", "")], Color("eef6e4") if on else Color("f1ede4"))
			if on: pv.add_child(UI.button("✅ On", G.toggle_perk.bind(pid), true, UI.GREEN, 16))
			else: pv.add_child(UI.soft_button("💤 Off — switch on", G.toggle_perk.bind(pid), true, 15))
			pg.add_child(pv.get_meta("panel"))
		elif not next_perk:
			var lv := _tile(null, "❔", "Next perk\n" + _perk_hint(p), Color("f1ede4"))
			pg.add_child(lv.get_meta("panel"))
			next_perk = true
	_section("🎁 Gifts from postcards", "%d gifts can work at the same time; the others rest here until you swap them in." % G.gift_max())
	var gg := _grid()
	content.add_child(gg)
	for gid in G.S["gift_owned"]:
		var c: Dictionary = G.gift_card(gid)
		var on: bool = G.gift_is_active(gid)
		var v := _tile(null, str(c.get("emoji", "🎁")), "%s\n%s" % [c["name"], c.get("desc", "")], Color("eef6e4") if on else Color("f1ede4"))
		if on: v.add_child(UI.button("✅ Working", G.toggle_gift.bind(gid), true, UI.GREEN, 16))
		else: v.add_child(UI.soft_button("💤 Resting — use it", G.toggle_gift.bind(gid), true, 15))
		gg.add_child(v.get_meta("panel"))

## A big medal with the level's name under it; next = the medal still to win (faint).
func _medal_tile(md: String, lv: Dictionary, next: bool) -> Control:
	var v := UI.vbox(0)
	v.custom_minimum_size = Vector2(112, 0)
	v.mouse_filter = Control.MOUSE_FILTER_PASS
	v.tooltip_text = "%s · class %s" % [lv["example"], str(lv["class"])]
	var big := UI.label(md, 48)
	big.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if next: big.modulate = Color(1, 1, 1, 0.35)
	v.add_child(big)
	var nm := UI.label(("Next: " if next else "") + "%s %s" % [lv["emoji"], lv["name"]], 13, UI.MUTED if next else UI.INK, true)
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.custom_minimum_size = Vector2(112, 0)
	v.add_child(nm)
	return v

## How a perk not yet owned is earned (shown in the album).
func _perk_hint(p: Dictionary) -> String:
	var w := str(p.get("when", ""))
	if w == "": return "A thank-you from a neighbour you help."
	var parts := w.split(">=")
	var n := parts[1] if parts.size() > 1 else ""
	match parts[0]:
		"rest_quick": return "Answer %s Rest sums quickly." % n
		"medals": return "Win %s medals with the Rest sums." % n
		"arith_level": return "Reach level %s of the Rest sums." % n
		"sold_kinds": return "Sell %s different things." % n
		"harvests": return "Harvest %s times." % n
		"seasons": return "Live through %s seasons." % n
		"cards": return "Learn %s knowledge cards." % n
		"sidequests": return "Help %s neighbours." % n
	return "Keep playing!"

func _sheet_log() -> void:
	var lines: Array = G.S["log"].duplicate()
	lines.reverse()
	for t in lines: content.add_child(UI.label(str(t), 16, UI.INK, true))
