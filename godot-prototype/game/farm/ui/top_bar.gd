extends RefCounted
## The top bar (J8, phase 3): coins, water and energy on the left with the season under them; the next goal's text fills
## the space in the middle; the 🎒 📖 🖼️ ⚙️ buttons on the right; the Time Quiz clock hangs from the bar's bottom edge in
## the right corner. The cheat buttons (J9) float below the bar on the left when a grown-up has switched them on.
## M = the main screen, G = Game.
const UI = preload("res://kits/ui/ui.gd")

var M
var G
var hud: PanelContainer
var quiz_hang: PanelContainer     # the green circle with the clock, hanging from the bar
var cheats: HBoxContainer         # the floating cheat buttons

func build(root: Control) -> void:
	hud = PanelContainer.new()
	var hs := UI.box(UI.PAPER, 0, UI.LINE, 0, 10)
	hs.border_width_bottom = 2
	hs.border_color = UI.LINE
	hud.add_theme_stylebox_override("panel", hs)
	root.add_child(hud)
	var h := UI.hbox(10)
	hud.add_child(h)
	# left: coins, water, energy; under them the season and the chapter
	var left := UI.vbox(4)
	h.add_child(left)
	var r1 := UI.hbox(8)
	left.add_child(r1)
	M.lbl_coins = UI.label("", 22); r1.add_child(M.lbl_coins)
	var wp = UI.TapPanel.new()
	wp.add_theme_stylebox_override("panel", UI.box(Color("dcecf6"), 10, Color("9fc3dc"), 1, 6))
	wp.tooltip_text = M.tr("Water: tap to carry more from the pond or the well.")
	var wbox := UI.hbox(3)
	wbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wbox.add_child(UI.label("💧", 20))
	M.water_bar = UI.stock_bar(0.0, 10.0, UI.item_color("water"), 130)
	wbox.add_child(M.water_bar)
	wbox.add_child(UI.label("🪣", 18))
	wp.add_child(wbox)
	wp.pressed.connect(M.ui_sheets._open_spot.bind("well"))
	r1.add_child(wp)
	var ep = UI.TapPanel.new()
	ep.add_theme_stylebox_override("panel", UI.box(Color("dbe8f4"), 10, Color("9fbbd6"), 1, 6))
	ep.tooltip_text = M.tr("Rest: answer sums to get energy back (sleep, food, a sip of water).")
	var ebox := UI.hbox(3)
	ebox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ebox.add_child(UI.label("⚡", 20))
	M.energy_bar = UI.stock_bar(0.0, 20.0, UI.item_color("energy"), 130)
	ebox.add_child(M.energy_bar)
	ebox.add_child(UI.label("😴", 18))
	ep.add_child(ebox)
	ep.pressed.connect(M.ui_rest._show_rest)
	r1.add_child(ep)
	var r2 := UI.hbox(8)
	left.add_child(r2)
	M.season_emoji = UI.label("", 18); r2.add_child(M.season_emoji)
	M.season_bar = UI.SeasonBar.new(); r2.add_child(M.season_bar)
	UI.explain(M.season_bar, M.tr("🗓️ The season: one mark per Time Quiz question. The number = questions until the next season."))
	M.lbl_info = UI.label("", 15, UI.MUTED); r2.add_child(M.lbl_info)
	M.lbl_status = UI.label("", 15, UI.MUTED); r2.add_child(M.lbl_status)
	# middle: the next goal (tap: go there)
	M.goal_btn = UI.soft_button("", M.ui_map._goal_pressed, true, 16)
	M.goal_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	M.goal_btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
	M.goal_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	M.goal_btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	M.goal_btn.clip_text = true
	M.goal_btn.custom_minimum_size = Vector2(120, 0)
	M.goal_btn.tooltip_text = M.tr("The next goal: tap to go there.")
	h.add_child(M.goal_btn)
	# right: bag, quest book, album, settings (two by two); the clock hangs below them
	var icons := GridContainer.new()
	icons.columns = 2
	icons.add_theme_constant_override("h_separation", 6)
	icons.add_theme_constant_override("v_separation", 6)
	h.add_child(icons)
	for pair in [["🎒", M.ui_sheets._open_pantry, M.tr("Pantry: what you have")], ["📖", M.ui_sheets._open_goals, M.tr("Quest book: everything you can do next")],
			["🖼️", M.ui_sheets._open_album, M.tr("Album: pets, friends, postcards, perks, acorns")], ["⚙️", M.ui_settings._show_menu, M.tr("Settings")]]:
		var b := UI.soft_button(pair[0], pair[1], true, 20)
		b.custom_minimum_size = Vector2(48, 38)
		b.tooltip_text = pair[2]
		icons.add_child(b)
	# the Time Quiz clock, hanging from the bar's bottom edge in the right corner (placed by place())
	quiz_hang = PanelContainer.new()
	quiz_hang.add_theme_stylebox_override("panel", UI.box(UI.GREEN, 44, UI.PAPER, 3, 4))
	M.quiz_btn = UI.ClockButton.new()
	M.quiz_btn.custom_minimum_size = Vector2(74, 74)
	M.quiz_btn.tooltip_text = M.tr("Time Quiz: every right answer moves farm time one step.")
	M.quiz_btn.pressed.connect(M.ui_quiz._show_time_quiz)
	quiz_hang.add_child(M.quiz_btn)
	# cheat buttons (testing; a grown-up setting), floating below the bar on the left
	cheats = UI.hbox(6)
	var cb := UI.button(M.tr("⏩ Cheat"), M._cheat, true, UI.AMBER, 14)
	cb.custom_minimum_size = Vector2(0, 30)
	cb.tooltip_text = M.tr("Testing only: lets time pass until everything growing or cooking is done, then fills energy and water.")
	cheats.add_child(cb)
	var cc := UI.button("🪙+50", func(): G.cheat_coins(50), true, UI.AMBER, 14)
	cc.custom_minimum_size = Vector2(0, 30)
	cheats.add_child(cc)
	var ck := UI.button(M.tr("📚 Skip card quizzes"), _skip_card_quizzes, true, UI.AMBER, 14)
	ck.custom_minimum_size = Vector2(0, 30)
	ck.tooltip_text = M.tr("Testing only: every knowledge card waiting for its quiz counts as learned.")
	cheats.add_child(ck)

## Adds the hanging clock and the cheat buttons over the map (after the map, before the sheet and the pop-up).
func add_overlays(parent: Control) -> void:
	parent.add_child(cheats)
	parent.add_child(quiz_hang)
	hud.resized.connect(place)

func place() -> void:
	if hud == null: return
	var bottom_y: float = hud.position.y + hud.size.y
	var qs: Vector2 = quiz_hang.get_combined_minimum_size()
	quiz_hang.size = qs
	quiz_hang.position = Vector2(M.size.x - qs.x - 14.0, bottom_y - 12.0)
	cheats.size = cheats.get_combined_minimum_size()
	cheats.position = Vector2(10.0, bottom_y + 8.0)
	cheats.visible = bool(G.device_get("cheats", G.settings.get("showCheatButton", false)))

## The top of the free space below the bar and the cheat buttons (notifications start there).
func bottom_y() -> float:
	if hud == null: return 0.0
	var y: float = hud.position.y + hud.size.y
	if cheats and cheats.visible: y += cheats.size.y + 8.0
	return y

func _skip_card_quizzes() -> void:
	for cid in G.card_ids:
		if G.card_status(cid) == "quiz": G.finish_card(cid, true)
