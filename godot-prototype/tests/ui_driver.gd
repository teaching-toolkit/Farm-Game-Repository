extends RefCounted
## UI test driver: the one place where tests reach into the main screen. Tests say what a child does ("open the
## pond", "answer the Time Quiz") and the driver knows which parts of the screen do it. When the screen is split
## into smaller parts (restructuring R5), only this file changes, not the tests.
##   var D = preload("res://tests/ui_driver.gd").new(main_screen)
var M

func _init(main_screen) -> void:
	M = main_screen

# --- what is on screen
func map(): return M.map
func modal_box() -> VBoxContainer: return M.modal_box
func modal_visible() -> bool: return M.modal.visible
func content() -> VBoxContainer: return M.content
func sheet_visible() -> bool: return M.sheet.visible
func sheet_kind() -> String: return M.sheet_kind
func sheet_title() -> String: return M.sheet_title.text
func sheet_close_shown() -> bool: return M.sheet_close.visible      # the sheet's ✖
func bag_bar_value() -> float: return M.bag_bar.value      # the thin bar under the 🎒 icon in the top bar
## The two bars at the top of the village square window: "sell" (what is still in the bag to sell or hand over) and "home" (what is bought for the way home). -1 when not shown.
func square_bar(which: String) -> float:
	var b = M.content.find_child("sq_%s_bar" % which, true, false)
	return float(b.value) if b is ProgressBar else -1.0
func square_shown() -> bool: return M.square.active()      # the village square stands where the farm was (money-market/07)
func square_covers_farm() -> bool: return M.square.active() and M.square.root().get_global_rect().encloses(M.scroll.get_global_rect()) and M.square.root().mouse_filter == Control.MOUSE_FILTER_STOP
func square_stalls() -> Array: return M.square.stalls()      # the stalls that stand there now
func square_stall() -> String: return M.square.stall         # the one whose things the window shows
func square_orders() -> bool: return not M.market.orders().is_empty()      # an order can be handed over now (the cart for the orders stands on the square)
func square_scene_full() -> bool: return M.square.active() and M.square._box.y >= M.square.root().size.y - 1.0      # the scene was laid out for the whole screen (no window)
func square_arrive() -> void: M.square.arrive()
func square_scene_tap() -> void:      # a tap on the bare scene (no stall)
	var e := InputEventMouseButton.new()
	e.button_index = MOUSE_BUTTON_LEFT
	e.pressed = true
	M.square._scene_tapped(e)
func sheet_height() -> float: return M.sheet_h
func figures_here() -> Array: return M.figures.ids(M.square._layer) if M.square._layer != null else []      # the people standing on the square (people/06)
func figure_tap(id: String) -> void: M.figures._tapped(id)      # what a tap on a person calls
func figure_saying(id: String) -> String: return M.figures.saying(id)
func figure_rel(id: String) -> Vector2: return M.figures.feet(id) / M.square._fbox      # where the person stands, as a share of the scene
func square_tap(id: String) -> bool:      # a tap on a stall's picture (false: it does not stand there)
	var b = M.square.root().find_child("stall_" + id, true, false) if M.square.root() != null else null
	if not (b is Button): return false
	b.emit_signal("pressed")
	return true
func goal_id() -> String: return M.goal_id
func celebrations() -> Array: return M.interrupts.q.in_line("celebration")
func clear_celebrations() -> void: M.interrupts.q.clear("celebration")
func rest_state() -> Dictionary: return M.rest_state
func info_text() -> String: return M.lbl_info.text         # "Chapter 1 · question 12": only changes when the farm has caught up (hidden since interface-feel/06; still set by refresh)
func info_shown() -> bool: return M.lbl_info.is_visible_in_tree()
func goal_text() -> String: return M.goal_btn.text
func goal_text_size() -> int: return M.goalbar.text_size()
func goal_box() -> Rect2: return M.goal_btn.get_global_rect()
func season_box() -> Rect2: return M.season_bar.get_global_rect()
func bars_box() -> Rect2: return M.water_bar.get_parent().get_parent().get_global_rect().merge(M.energy_bar.get_parent().get_parent().get_global_rect())
func screen_size() -> Vector2: return M.size
func set_screen_size(v: Vector2) -> void: M.set_deferred("size", v)
func coins_shown() -> bool: return M.lbl_coins.visible
func icon_shown(id: String) -> bool: return M.icon_buttons[id].visible
func cheats_shown() -> bool: return M.cheat_box.visible      # the testing buttons below the top bar
func hud_fits() -> bool: return M.hud_panel.get_combined_minimum_size().x <= M.size.x + 0.5     # the top bar is not wider than the screen
func playback_held() -> bool: return M.playback.held
func playback_playing() -> bool: return M.playback.playing
func is_open(spot: String) -> bool: return M.mapview.is_open(spot)
func mystery(spot: String) -> bool: return M.mapview.mystery(spot)
func interior_corners() -> Dictionary:      # the corners drawn in the open building window: id -> drawn faded (locked)
	var out := {}
	var stack: Array = [M.modal_box]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n.get("spot_id") != null and str(n.get("spot_id")) != "": out[str(n.get("spot_id"))] = bool(n.get("locked"))
		stack.append_array(n.get_children())
	return out
func badge(spot: String) -> String: return M.mapview.badge(spot)      # the small sign on a place (📖 a card to read, ❓ a card quiz …)

# --- what a child does
func close_modal() -> void: M.modals.close_modal()
func celebrate(id: String) -> void: M.celebrations.celebrate(id)      # what the rules signal when something new is done
func close_sheet() -> void: M.sheets.close_sheet()
func show_card(cid: String) -> void: M.cards.show_card(cid)
func tap_patch(area: String, i: int) -> void: M.patches.on_patch(area, i)
func show_time_quiz() -> void: M.timequiz.show_time_quiz()
func answer_right() -> void: M.timequiz.answer_right()      # the question on screen: the right answer…
func answer_wrong() -> void: M.timequiz.answer_wrong()      # … or a wrong pick first
func show_question(box: VBoxContainer, q: Dictionary, on_done: Callable) -> void: M.timequiz.question(box, q, on_done)
func playback_speed(f: float) -> void: M.playback.speed = f     # 0 = the farm catches up after the Time Quiz without waiting
func tap_playback() -> void: M.playback.finish()
func show_rest() -> void: M.rest.show_rest()
func go_rest() -> void: M.rest.go_rest()
func rest_go() -> void: M.rest.rest_go()
func farmer_shown() -> bool: return M.map.avatar.visible and M.map.avatar.modulate.a > 0.99     # Rest: he is out of the tent or house
func farmer_hidden() -> bool: return not M.map.avatar.visible                                   # … or inside it
func farmer_feet() -> Vector2: return M.map.avatar.feet
func tap_rest_walk() -> bool:      # a tap on the screen while the farmer walks in or comes out (false: nothing caught it)
	var c = M.rest._catcher
	if c == null or not is_instance_valid(c): return false
	var e := InputEventMouseButton.new()
	e.button_index = MOUSE_BUTTON_LEFT
	e.pressed = true
	c.gui_input.emit(e)
	return true
func open_spot(spot: String) -> void: M.sheets.open_spot(spot)
func open_sheet(kind: String) -> void: M.sheets.open_sheet(kind)
func window_key() -> String: return M.sheets.window_key()
func enter_corner(corner: String, parent: String) -> void: M.interiors.enter_corner(corner, parent)
func press_goal() -> void: M.goalbar.goal_pressed()
func show_menu() -> void: M.menu.show_menu()
func play_fx() -> void: M.mapview.play_fx()
func refresh() -> void: M.refresh()
func item_panel(k: String) -> void: M.pantry.item_panel(k)
func story_enabled(on: bool) -> void: M.story.enabled = on
func story_pump() -> bool: return M.story.pump()      # what the start of a new game asks before its welcome
func frame_close() -> void: M.frame_scene.close()      # leaves the frame scene (a no-op when none is open)
func frame_open() -> bool: return M.frame_scene.active()      # story/11: the grandchildren's full-screen frame scene
func frame_id() -> String: return M.frame_scene.shown_id()
func frame_page() -> int: return M.frame_scene.page_no()
func frame_skip_shown() -> bool: return M.frame_scene.skip_shown()
func frame_covers_screen() -> bool:      # a black, opaque scene over the whole screen, the top bar included
	var r: Control = M.frame_scene.root()
	if r == null: return false
	var black := r.get_child(0) as ColorRect
	return black != null and black.color == Color.BLACK and r.get_global_rect().encloses(M.get_global_rect()) and r.get_global_rect().encloses(M.hud_panel.get_global_rect())
func frame_tap() -> void:      # a tap on the scene, as the screen gets it
	var e := InputEventMouseButton.new()
	e.button_index = MOUSE_BUTTON_LEFT
	e.pressed = true
	M.frame_scene.root().gui_input.emit(e)
func frame_press(text: String) -> bool:      # press a button of the scene (Skip, Read aloud)
	var stack: Array = [M.frame_scene.root()]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		if n is Button and n.text.contains(text) and not n.disabled:
			n.emit_signal("pressed")
			return true
		stack.append_array(n.get_children())
	return false
func interrupts_request() -> void: M.interrupts.request()      # something waits for the screen: pump at the end of the frame
func bubbles() -> int:      # sticky speech bubbles on the screen
	var n := 0
	for c in M.toasts.get_children():
		if c.get_meta("sticky", false): n += 1
	return n
func toast_texts() -> Array:      # the texts of the notes on the screen now
	var out := []
	for c in M.toasts.get_children():
		if not c.is_queued_for_deletion(): out.append(str(c.get_meta("text", "")))
	return out
func playback_waiting() -> bool: return M.playback.waiting
func playback_step(info: Dictionary) -> void: M.playback._on_step(info)     # what a step of time reports, as the playback hears it
func playback_begin() -> void: M.playback.begin()
func playback_postpone() -> void: M.playback.postpone()
func clear_toasts() -> void:
	for c in M.toasts.get_children(): c.queue_free()

# --- the grown-up lock
func grownup_open() -> bool: return M.menu.grownup_open()
func password_ok(t: String) -> bool: return M.menu.password_ok(t)
func set_grownup_open(on: bool) -> void: M.menu.grownup_until = 1e12 if on else 0.0

# --- interface-feel/01 and 02: the short note on tap (game/farm/ui/info.gd)
func info_note() -> Dictionary: return M.info.now()          # what the note on the screen says ({} when none): kind, icon, title, lines, spoken, action, extra
func info_card() -> Control: return M.info.card
func info_close() -> void: M.info.close()
func info_spoken() -> String: return M.info.spoken           # the last text given to the voice
func info_forget_spoken() -> void: M.info.spoken = ""
func info_item(k: String, need := 0.0) -> void: M.info.item(k, null, need)
func read_aloud(mode: String) -> void: M.G.prefs.set_value("readAloud", mode)      # "off", "button" or "auto" (this device only; tests keep nothing)
func bar_control(which: String) -> Control:      # the control a finger taps for a bar of the top bar
	match which:
		"energy": return M.energy_bar.get_parent().get_parent()
		"water": return M.water_bar.get_parent().get_parent()
		"bag": return M.bag_bar.get_parent()
		"coins": return M.lbl_coins
	return null
func reveal(c: Control) -> void:      # scrolls the sheet so that the control can be tapped
	if M.sheet_scroll.is_ancestor_of(c): M.sheet_scroll.ensure_control_visible(c)
func tap_at(p: Vector2) -> void:      # a finger tap at a point of the screen, through the real input path (press, then release)
	for down in [true, false]:
		var ev := InputEventMouseButton.new()
		ev.button_index = MOUSE_BUTTON_LEFT
		ev.pressed = down
		ev.button_mask = MOUSE_BUTTON_MASK_LEFT if down else 0
		ev.position = p
		ev.global_position = p
		M.get_viewport().push_input(ev, true)
func tap(c: Control) -> void: tap_at(c.get_global_rect().get_center())
func sheet_settled() -> bool: return not M.sheet.visible or M.sheets._slide >= 0.999      # the sheet is all the way up (a tap on it would miss while it slides)
