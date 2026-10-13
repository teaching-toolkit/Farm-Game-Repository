extends Control
class_name FarmMain
## Hazelwood Harvest (the farm quiz game) — the farm-map interface, made for an iPad held upright (834×1194 design size).
## Tap a place on the map (house, kitchen, coop, market stall …) and a sheet slides up with everything you can do there.
## Pictures come from assets/ when they exist (see kits/ui/art.gd); emojis stand in for the rest.
const UI = preload("res://kits/ui/ui.gd")
const MAP_SCENE = preload("res://game/farm/map/farm_map.tscn")
const Notifications = preload("res://kits/ui/notifications.gd")
const GOAL_TYPES := ["building", "station", "tool", "gear", "helper", "land", "patch", "delivery", "pet", "sidequest"]

const DevFlags = preload("res://game/farm/dev/dev_flags.gd")
var G: FarmGame

## The parts of the interface (game/farm/ui/): each does one job and works through M (this screen) and G (the rules).
var album: FarmUiAlbum
var animalsheet: FarmUiAnimalSheet
var cards: FarmUiCards
var celebrations: FarmUiCelebrations
var feedback: FarmUiFeedback
var gifts: FarmUiGifts
var goalbar: FarmUiGoalBar
var home: FarmUiHome
var interiors: FarmUiInteriors
var mapview: FarmUiMapView
var market: FarmUiMarket
var menu: FarmUiMenu
var modals: FarmUiModals
var notes: FarmUiNotes
var pantry: FarmUiPantry
var patches: FarmUiPatches
var playback: FarmUiPlayback
var bag_bar: ProgressBar       # the thin bar under the bag icon
var icon_buttons := {}      # the icons of the top bar by id (bag, book, album, settings): shown when G.reveal says so
var placesheet: FarmUiPlaceSheet
var questlog: FarmUiQuestLog
var rest: FarmUiRest
var sheets: FarmUiSheets
var stations: FarmUiStations
var story: FarmUiStory
var timequiz: FarmUiTimeQuiz
var waterroad: FarmUiWaterRoad
var welcome: FarmUiWelcome
var widgets: FarmUiWidgets
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
var hud_panel: PanelContainer     # the top bar
var quiz_holder: PanelContainer   # the round frame of the Time Quiz clock, hanging from the top bar
var cheat_box: VBoxContainer      # the testing buttons, floating below the top bar in the left corner (⚙️ → grown-up settings)
var goal_btn: Button
var quiz_btn          # UI.ClockButton: the Time Quiz (an old clock; its hand goes round once when tapped)
var sheet: PanelContainer
var sheet_title: Label
var sheet_scroll: ScrollContainer
var content: VBoxContainer
var sheet_kind := ""
var sheet_h := 0.0
var toasts          # the notifications (kits/ui/notifications.gd): small cards stacked just below the top bar
var modal: Control
var modal_card: PanelContainer
var modal_box: VBoxContainer
var field_idx := 0        # the field whose patch was tapped last (the field sheet works on it)
var _last_season := ""     # to notice a new season (music, breeze)
var patch_note := -1     # an overgrown patch that was tapped: the field sheet says which one and why it is not ready
var interior_back := ""  # reopen this building's inside when the corner's sheet closes
var goal_id := ""
var _queued := false
var shot_path := ""
var shot_at := 45              # the frame the screenshot is taken at (--shotframes=N)
var shot_frames := 0
var step_at := -1
var rest_state := {}               # the Rest pop-up: question, typed answer, when it was asked, its nodes
var celebration_queue: Array = []  # new buildings, tools and helpers waiting for their big pop-up
var after_close: Array = []   # messages shown when the pop-up closes (rain …)
var _look_sig := "-"


func _make_parts() -> void:
	album = FarmUiAlbum.new(self)
	animalsheet = FarmUiAnimalSheet.new(self)
	cards = FarmUiCards.new(self)
	celebrations = FarmUiCelebrations.new(self)
	feedback = FarmUiFeedback.new(self)
	gifts = FarmUiGifts.new(self)
	goalbar = FarmUiGoalBar.new(self)
	home = FarmUiHome.new(self)
	interiors = FarmUiInteriors.new(self)
	mapview = FarmUiMapView.new(self)
	market = FarmUiMarket.new(self)
	menu = FarmUiMenu.new(self)
	modals = FarmUiModals.new(self)
	notes = FarmUiNotes.new(self)
	pantry = FarmUiPantry.new(self)
	patches = FarmUiPatches.new(self)
	playback = FarmUiPlayback.new(self)
	placesheet = FarmUiPlaceSheet.new(self)
	questlog = FarmUiQuestLog.new(self)
	rest = FarmUiRest.new(self)
	sheets = FarmUiSheets.new(self)
	stations = FarmUiStations.new(self)
	story = FarmUiStory.new(self)
	timequiz = FarmUiTimeQuiz.new(self)
	waterroad = FarmUiWaterRoad.new(self)
	welcome = FarmUiWelcome.new(self)
	widgets = FarmUiWidgets.new(self)

func _ready() -> void:
	G = get_node("/root/Game")
	_make_parts()
	for a in OS.get_cmdline_user_args():      # screenshots and tests: --lang=de shows the whole game in German (not saved)
		if a.begins_with("--lang=") and a.substr(7) != I18n.lang: G.set_language(a.substr(7), false)
	_setup_theme()
	_build()
	G.changed.connect(queue_refresh)
	G.toast.connect(notes.toast)
	G.revealed.connect(notes.on_revealed)
	UI.explain_hook = notes.hint
	G.offer_cards.connect(gifts.show_gift)
	G.sold.connect(feedback.on_sold)
	Sound.perk_on = func(id): return G.rewards.perk_on(id)
	if map.actor: map.actor.resolve = feedback.act_place
	var amb := Timer.new()          # now and then an animal on the farm makes itself heard (perk "Farm sounds")
	amb.wait_time = 30.0
	amb.timeout.connect(feedback.animal_ambience.bind(amb))
	add_child(amb)
	amb.start()
	G.ask_name.connect(welcome.show_name)
	G.gained.connect(mapview.on_gained)
	G.celebrate.connect(celebrations.celebrate)
	for fv in map.fields: fv.patch_pressed.connect(patches.on_patch)
	map.spot_tapped.connect(sheets.open_spot)
	resized.connect(_on_resized)
	_parse_args()
	refresh()
	if G.player == "" and shot_path == "" and DisplayServer.get_name() != "headless":
		welcome.ask_player()
	elif G.S["gift_pending"].size() > 0: gifts.show_gift()
	elif G.S["step"] == 0 and not G.done("k_wheat"):
		if not story.pump(): welcome.show_welcome()
	else: story.queue_pump()

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

func _build() -> void:
	bg = ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = UI.BG
	add_child(bg)
	var root := UI.vbox(0)
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)
	# --- the top bar: coins, water, energy and the season on the left, the next goal in the middle (the whole height of the bar),
	# the buttons at the right; the Time Quiz clock hangs from the bar's lower edge in the right corner (there is no bottom bar)
	var hud := PanelContainer.new()
	hud_panel = hud
	var hs := UI.box(UI.PAPER, 0, UI.LINE, 0, 10)
	hs.border_width_bottom = 2
	hs.border_color = UI.LINE
	hud.add_theme_stylebox_override("panel", hs)
	root.add_child(hud)
	var hh := UI.hbox(8)
	hud.add_child(hh)
	var hv := UI.vbox(2)
	hh.add_child(hv)
	var r1 := UI.hbox(8)
	hv.add_child(r1)
	lbl_coins = UI.label("", 22); r1.add_child(lbl_coins)
	var wp = UI.TapPanel.new()
	wp.add_theme_stylebox_override("panel", UI.box(Color("dcecf6"), 10, Color("9fc3dc"), 1, 6))
	wp.tooltip_text = tr("Water: tap to carry more from the pond or the well.")
	var wbox := UI.hbox(3)
	wbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wbox.add_child(UI.label("💧", 20))
	water_bar = UI.stock_bar(0.0, 10.0, UI.item_color("water"), 150)
	wbox.add_child(water_bar)
	wbox.add_child(UI.label("🪣", 18))
	wp.add_child(wbox)
	wp.pressed.connect(sheets.open_spot.bind("well"))
	r1.add_child(wp)
	var ep = UI.TapPanel.new()
	ep.add_theme_stylebox_override("panel", UI.box(Color("dbe8f4"), 10, Color("9fbbd6"), 1, 6))
	ep.tooltip_text = tr("Rest: answer sums to get energy back (sleep, food, a sip of water).")
	var ebox := UI.hbox(3)
	ebox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ebox.add_child(UI.label("⚡", 20))
	energy_bar = UI.stock_bar(0.0, 20.0, UI.item_color("energy"), 150)
	ebox.add_child(energy_bar)
	ebox.add_child(UI.label("😴", 18))
	ep.add_child(ebox)
	ep.pressed.connect(rest.go_rest)
	r1.add_child(ep)
	var r2 := UI.hbox(8)
	hv.add_child(r2)
	season_emoji = UI.label("", 18); r2.add_child(season_emoji)
	season_bar = UI.SeasonBar.new(); r2.add_child(season_bar)
	UI.explain(season_bar, tr("🗓️ The season: one mark per Time Quiz question. The number = questions until the next season."))
	lbl_info = UI.label("", 15, UI.MUTED)
	lbl_info.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	lbl_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl_info.custom_minimum_size = Vector2(60, 0)
	r2.add_child(lbl_info)
	lbl_status = UI.label("", 15, UI.MUTED); r2.add_child(lbl_status)
	# the next goal: the whole width and height between the energy bar and the buttons
	goal_btn = UI.soft_button("", goalbar.goal_pressed, true, 16)
	goal_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	goal_btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
	goal_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	goal_btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	goal_btn.clip_text = true
	goal_btn.custom_minimum_size = Vector2(90, 0)
	hh.add_child(goal_btn)
	var rv := UI.vbox(0)
	hh.add_child(rv)
	var ir := UI.hbox(6)
	rv.add_child(ir)
	for pair in [["bag", "🎒", sheets.open_bag, tr("Bag: what you will take to the village")], ["book", "📖", sheets.open_goals, "Quest book: everything you can do next"],
			["scroll", "📜", sheets.open_scroll, tr("Story: what you have read")],
			["album", "🖼️", sheets.open_album, tr("Album: pets, friends, postcards, perks, acorns")], ["settings", "⚙️", menu.show_menu, tr("Settings")]]:
		var b := UI.soft_button(pair[1], pair[2], true, 22)
		b.custom_minimum_size = Vector2(48, 46)
		b.tooltip_text = pair[3]
		if pair[0] == "bag":          # a thin bar under the bag icon shows how full the bag is
			var bv := UI.vbox(1)
			bv.add_child(b)
			bag_bar = UI.bar(0.0, 44, 5, UI.AMBER)
			bv.add_child(bag_bar)
			ir.add_child(bv)
			icon_buttons["bag_box"] = bv
		else: ir.add_child(b)
		icon_buttons[pair[0]] = b
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
	# --- the Time Quiz: a green round clock that hangs from the lower edge of the top bar in the right corner
	quiz_holder = PanelContainer.new()
	quiz_holder.add_theme_stylebox_override("panel", UI.box(UI.GREEN, 40, UI.LINE, 2, 4))
	quiz_btn = UI.ClockButton.new()
	quiz_btn.custom_minimum_size = Vector2(72, 72)
	quiz_btn.tooltip_text = tr("Time Quiz: every right answer moves farm time one step.")
	quiz_btn.pressed.connect(timequiz.show_time_quiz)
	quiz_holder.add_child(quiz_btn)
	add_child(quiz_holder)
	hud.resized.connect(_place_quiz_button)
	# --- the testing buttons: small, floating below the bar at the left; a grown-up setting shows or hides them
	cheat_box = UI.vbox(4)
	for c in [[tr("⏩ Cheat"), G.cheat_max, tr("Testing only: lets time pass until everything growing or cooking is done, then fills energy and water.")],
			[tr("🪙 +50"), G.cheat_coins.bind(50), tr("Testing only: 50 bronze.")],
			[tr("🎓 Quizzes"), G.knowledge.cheat_skip_card_quizzes, tr("Testing only: passes the quiz of every card that is waiting for it.")]]:
		var cb := UI.button(c[0], c[1], true, UI.AMBER, 13)
		cb.custom_minimum_size = Vector2(0, 28)
		cb.tooltip_text = c[2]
		cheat_box.add_child(cb)
	add_child(cheat_box)
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
	var close := UI.soft_button("✖", sheets.close_sheet, true, 20)
	close.custom_minimum_size = Vector2(52, 44)
	sh.add_child(close)
	sheet_scroll = ScrollContainer.new()
	sheet_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sheet_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sv.add_child(sheet_scroll)
	content = UI.vbox(8)
	sheet_scroll.add_child(content)
	# --- toasts and the centred pop-up (quizzes, Rest, cards, gifts)
	toasts = Notifications.new()
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

## The Time Quiz clock sits in the right corner, its upper part over the bar and the rest over the map.
func _place_quiz_button() -> void:
	if notes != null: notes.place_toasts()
	if cheat_box != null and hud_panel != null:
		cheat_box.size = cheat_box.get_combined_minimum_size()
		cheat_box.position = Vector2(8.0, hud_panel.size.y + 6.0)
	if quiz_holder == null or hud_panel == null: return
	var qs := quiz_holder.get_combined_minimum_size()
	quiz_holder.size = qs
	quiz_holder.position = Vector2(size.x - qs.x - 10.0, hud_panel.size.y - qs.y * 0.42)

func _on_resized() -> void:
	_place_quiz_button()
	if sheet.visible: sheets.fit_sheet()
	if modal.visible: modals.fit_modal()

## The top bar has to fit the screen: on a narrower screen (or with bigger bars) the two bars get smaller cubes.
func _fit_hud() -> void:
	var bw := clampf(size.x - 700.0, 80.0, 150.0)
	for b in [water_bar, energy_bar]:
		if b.max_w != bw:
			b.max_w = bw
			b.refresh()

func queue_refresh() -> void:
	if _queued: return
	_queued = true
	refresh.call_deferred()

func refresh() -> void:
	_queued = false
	if playback.held: return          # the Time Quiz is open (or its playback has not caught up): the screen keeps the old state
	var S: Dictionary = G.S
	lbl_coins.text = G.purse_text()
	lbl_coins.visible = G.reveal.shown("coins")          # what is shown when: data/farm/rules/60-reveal.json
	for id in icon_buttons: if id != "bag_box": icon_buttons[id].visible = G.reveal.shown(id)
	icon_buttons["bag_box"].visible = icon_buttons["bag"].visible
	bag_bar.value = G.trip.fill()
	bag_bar.get_theme_stylebox("fill").bg_color = UI.AMBER if G.trip.fill() < 0.999 else UI.RED
	_fit_hud()
	water_bar.have = float(S["water"]); water_bar.cap = G.needs.water_cap(); water_bar.refresh()
	energy_bar.have = float(S["energy"]); energy_bar.cap = G.needs.energy_max(); energy_bar.refresh()
	season_emoji.text = G.seasons.season_emoji()
	if G.seasons.season() != _last_season:            # a new season: its music on the farm, a breeze with the perk
		if _last_season != "": feedback.sfx("breeze")
		_last_season = G.seasons.season()
	if not modal.visible: Sound.music("farm", G.seasons.season())
	map.set_perks({"butterflies": G.rewards.perk_on("perk_butterflies"), "sparkles": G.rewards.perk_on("perk_sparkles"),
		"rainbow": G.rewards.perk_on("perk_rainbow"), "breeze": G.rewards.perk_on("perk_breeze")})
	var lk: Dictionary = S.get("look", {})
	var ls := JSON.stringify(lk)
	if ls != _look_sig and map.avatar:
		_look_sig = ls
		map.avatar.set_look(lk)
	var nxt_no: int = (G.seasons.season_no() + 1) % 4
	var nxt_emoji := str(G.meta.get("seasons", {}).get("mods", {}).get(G.SEASON_NAMES[nxt_no], {}).get("emoji", ""))
	var slen: int = G.seasons.season_len()
	season_bar.set_state(G.seasons.season(), slen, slen - G.seasons.questions_left_in_season(), "→ " + nxt_emoji)
	quiz_btn.show_time(float(slen - G.seasons.questions_left_in_season()) / float(slen))
	lbl_info.text = tr("Chapter %d · question %d%s") % [G.chapter(), S["step"], "  🌧️" if S.get("rain", false) else ""]
	# out of water: say so with a picture (once, when it runs out)
	if _last_water >= 1.0 and float(S["water"]) < 1.0 and not modal.visible: patches.show_no_water.call_deferred()
	_last_water = float(S["water"])
	var st := []
	if G.needs.buff_mult() < 1.0: st.append(tr("😋 −%d%% energy") % int(round((1.0 - G.needs.buff_mult()) * 100)))
	if S.get("cold", false): st.append(tr("❄️🏠 cold house"))
	if G.rewards.luck() >= 0.2: st.append("🍀")
	if G.S["reading"] != "": st.append(tr("📖 reading"))
	lbl_status.text = "  ".join(st)
	bg.color = UI.SEASON_BG.get(G.seasons.season(), UI.BG)
	cheat_box.visible = G.cheats_visible()
	map.ground.set_season(G.seasons.season(), mapview.fence_level())
	# fields, add-ons and the house yard
	field_idx = clampi(field_idx, 0, maxi(0, G.fields.field_names().size() - 1))
	map.refresh_fields(G, playback.flicking)
	map.refresh_addons(G)
	map.set_house_built(mapview.built("home"))
	# places on the map
	goal_id = goalbar.next_goal()
	for sid in map.slots: mapview.update_slot(sid)
	map.set_road_badge(mapview.badge("road"))
	map.set_field_badge(mapview.badge("field"))
	map.critters.set_critters(mapview.critter_spec())
	map.farmcat.set_cat(G.done("barn_cat"))
	goalbar.update_goal_bar()
	if sheet.visible:
		sheets.rebuild_sheet()
		sheets.fit_sheet.call_deferred()
	story.queue_pump()

## Taps on the farm make sparkles (perk "Magic sparkles").
func _input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT and not modal.visible:
		if not scroll.get_global_rect().has_point(e.position): return
		if sheet.visible and sheet.get_global_rect().has_point(e.position): return
		map.sparkle_global(e.position)
