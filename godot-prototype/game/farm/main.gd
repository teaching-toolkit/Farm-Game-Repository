extends Control
## Hazelwood Harvest (the farm quiz game) — the farm-map interface, made for an iPad held upright (834×1194 design size).
## Tap a place on the map (house, kitchen, coop, market stall …) and a sheet slides up with everything you can do there.
## Pictures come from assets/ when they exist (see kits/ui/art.gd); emojis stand in for the rest.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")
const MAP_SCENE = preload("res://game/farm/map/farm_map.tscn")
const MapScript = preload("res://game/farm/map/farm_map.gd")
const SlotScript = preload("res://game/farm/map/slot.gd")

const GOAL_TYPES := ["building", "station", "tool", "gear", "helper", "land", "patch", "delivery", "pet", "sidequest"]

const DevFlags = preload("res://game/farm/dev/dev_flags.gd")
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
var _last_season := ""     # to notice a new season (music, breeze)
var _patch_note := -1     # an overgrown patch that was tapped: the field sheet says which one and why it is not ready
var _interior_back := ""  # reopen this building's inside when the corner's sheet closes
var goal_id := ""
var _queued := false
var _scroll_tw: Tween
var shot_path := ""
var shot_at := 45              # the frame the screenshot is taken at (--shotframes=N)
var shot_frames := 0
var step_at := -1
var _fx_queue: Array = []      # things that arrived while a pop-up was open: they fly to the store when it closes
var _rest := {}               # the Rest pop-up: question, typed answer, when it was asked, its nodes
var _celebrations: Array = []  # new buildings, tools and helpers waiting for their big pop-up
var _last_fx := ""             # the celebration effect shown last time (the next one is different)
var _after_close: Array = []   # messages shown when the pop-up closes (rain …)
const Fx = preload("res://game/farm/fx.gd")
const Pad = preload("res://kits/learn/number_pad_quiz.gd")
var _look_sig := "-"
## The parts of the screen (game/farm/ui/, R5): each gets M = this screen and G = the rules.
var ui_top = preload("res://game/farm/ui/top_bar.gd").new()
var ui_play = preload("res://game/farm/ui/playback.gd").new()   # back on the farm after the Time Quiz (J4)
var ui_acts = preload("res://game/farm/ui/farmer_acts.gd").new()
var ui_animals = preload("res://game/farm/ui/places/animals.gd").new()
var ui_board = preload("res://game/farm/ui/places/board.gd").new()
var ui_card = preload("res://game/farm/ui/card.gd").new()
var ui_celebrate = preload("res://game/farm/ui/celebrations.gd").new()
var ui_fields = preload("res://game/farm/ui/places/fields.gd").new()
var ui_home = preload("res://game/farm/ui/places/home.gd").new()
var ui_map = preload("res://game/farm/ui/map_view.gd").new()
var ui_menus = preload("res://game/farm/ui/menus.gd").new()
var ui_modal = preload("res://game/farm/ui/modal.gd").new()
var ui_notes = preload("res://game/farm/ui/notifications.gd").new()
var ui_pets = preload("res://game/farm/ui/places/pets.gd").new()
var ui_place = preload("res://game/farm/ui/places/place_sheet.gd").new()
var ui_postcards = preload("res://game/farm/ui/postcards.gd").new()
var ui_quiz = preload("res://game/farm/ui/time_quiz.gd").new()
var ui_rest = preload("res://game/farm/ui/rest.gd").new()
var ui_road = preload("res://game/farm/ui/places/road.gd").new()
var ui_settings = preload("res://game/farm/ui/settings.gd").new()
var ui_sheets = preload("res://game/farm/ui/sheets.gd").new()
var ui_sounds = preload("res://game/farm/ui/sounds.gd").new()
var ui_stations = preload("res://game/farm/ui/places/stations.gd").new()
var ui_village = preload("res://game/farm/ui/places/village.gd").new()
var ui_water = preload("res://game/farm/ui/places/water.gd").new()
var ui_welcome = preload("res://game/farm/ui/welcome.gd").new()
var ui_widgets = preload("res://game/farm/ui/widgets.gd").new()

func _ready() -> void:
	G = get_node("/root/Game")
	for p in [ui_acts, ui_animals, ui_board, ui_card, ui_celebrate, ui_fields, ui_home, ui_map, ui_menus, ui_modal, ui_notes, ui_pets, ui_place, ui_postcards, ui_quiz, ui_rest, ui_road, ui_settings, ui_sheets, ui_sounds, ui_stations, ui_village, ui_water, ui_welcome, ui_widgets, ui_top, ui_play]:
		p.M = self
		p.G = G
	for a in OS.get_cmdline_user_args():      # screenshots and tests: --lang=de shows the whole game in German (not saved)
		if a.begins_with("--lang=") and a.substr(7) != I18n.lang: G.set_language(a.substr(7), false)
	_setup_theme()
	_build()
	G.changed.connect(_queue_refresh)
	G.toast.connect(ui_notes._toast)
	UI.explain_hook = ui_notes._hint
	G.offer_cards.connect(ui_postcards._show_gift)
	G.sold.connect(ui_sounds._on_sold)
	Sound.perk_on = func(id): return G.perk_on(id)
	if map.actor: map.actor.resolve = ui_acts._act_place
	var amb := Timer.new()          # now and then an animal on the farm makes itself heard (perk "Farm sounds")
	amb.wait_time = 30.0
	amb.timeout.connect(ui_sounds._animal_ambience.bind(amb))
	add_child(amb)
	amb.start()
	G.ask_name.connect(ui_postcards._show_name)
	G.gained.connect(ui_map._on_gained)
	G.celebrate.connect(ui_celebrate._celebrate)
	for fv in map.fields: fv.patch_pressed.connect(ui_fields._on_patch)
	map.spot_tapped.connect(ui_sheets._open_spot)
	resized.connect(_on_resized)
	_parse_args()
	_refresh()
	if G.player == "" and shot_path == "" and DisplayServer.get_name() != "headless":
		ui_settings._ask_player()
	elif G.S["gift_pending"].size() > 0: ui_postcards._show_gift()
	elif G.S["step"] == 0 and not G.done("k_wheat"): ui_welcome._show_welcome()

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
	DevFlags.apply(self, G)     # test and screenshot flags: game/farm/dev/dev_flags.gd

func _process(_d: float) -> void:
	if shot_path != "":
		shot_frames += 1
		if shot_frames == step_at: G.step_time()
		if shot_frames == shot_at:
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
	# --- top bar (HUD): game/farm/ui/top_bar.gd
	ui_top.build(root)
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
	# the clock hanging from the top bar and the cheat buttons, over the map
	ui_top.add_overlays(self)
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
	var close := UI.soft_button("✖", ui_sheets._close_sheet, true, 20)
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
	ui_top.place()
	if sheet.visible: ui_sheets._fit_sheet()
	if modal.visible: ui_modal._fit_modal()

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
	if G.season() != _last_season:            # a new season: its music on the farm, a breeze with the perk
		if _last_season != "": ui_sounds._sfx("breeze")
		_last_season = G.season()
	if not modal.visible: Sound.music("farm", G.season())
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
	lbl_info.text = tr("Chapter %d · %s · question %d%s") % [G.chapter(), ch["name"], S["step"], "  🌧️" if S.get("rain", false) else ""]
	# out of water: say so with a picture (once, when it runs out)
	if _last_water >= 1.0 and float(S["water"]) < 1.0 and not modal.visible: ui_fields.call_deferred("_show_no_water")
	_last_water = float(S["water"])
	var st := []
	if G.buff_mult() < 1.0: st.append(tr("😋 −%d%% energy") % int(round((1.0 - G.buff_mult()) * 100)))
	if S.get("cold", false): st.append(tr("❄️🏠 cold house"))
	if G.luck() >= 0.2: st.append("🍀")
	if G.S["reading"] != "": st.append(tr("📖 reading"))
	lbl_status.text = "  ".join(st)
	bg.color = UI.SEASON_BG.get(G.season(), UI.BG)
	map.set_season(G.season(), _fence_level())
	# fields, add-ons and the house yard
	field_idx = clampi(field_idx, 0, maxi(0, G.field_names().size() - 1))
	if not ui_play.hold and not ui_play.playing: map.refresh_fields(G)
	map.refresh_addons(G)
	map.set_house_built(ui_map._built("home"))
	# places on the map
	goal_id = ui_map._next_goal()
	for sid in map.slots: ui_map._update_slot(sid)
	map.set_road_badge(ui_map._badge("road"))
	map.set_critters(ui_map._critter_spec())
	map.set_cat(G.done("barn_cat"))
	ui_map._update_goal_bar()
	ui_top.place()
	if sheet.visible:
		ui_sheets._rebuild_sheet()
		ui_sheets.call_deferred("_fit_sheet")

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

# ------------------------------------------------------------------ Rest

## Taps on the farm make sparkles (perk "Magic sparkles").
func _input(e: InputEvent) -> void:
	if ui_play.playing and e is InputEventMouseButton and e.pressed: ui_play.skip()     # any tap: to the end of the playback
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT and not modal.visible:
		if not scroll.get_global_rect().has_point(e.position): return
		if sheet.visible and sheet.get_global_rect().has_point(e.position): return
		map.sparkle_global(e.position)

