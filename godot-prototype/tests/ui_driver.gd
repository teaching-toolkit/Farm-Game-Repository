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
func goal_id() -> String: return M.goal_id
func celebrations() -> Array: return M.celebration_queue
func rest_state() -> Dictionary: return M.rest_state
func info_text() -> String: return M.lbl_info.text         # "Chapter 1 · question 12": only changes when the farm has caught up
func screen_size() -> Vector2: return M.size
func set_screen_size(v: Vector2) -> void: M.set_deferred("size", v)
func coins_shown() -> bool: return M.lbl_coins.visible
func icon_shown(id: String) -> bool: return M.icon_buttons[id].visible
func hud_fits() -> bool: return M.hud_panel.get_combined_minimum_size().x <= M.size.x + 0.5     # the top bar is not wider than the screen
func playback_held() -> bool: return M.playback.held
func playback_playing() -> bool: return M.playback.playing
func is_open(spot: String) -> bool: return M.mapview.is_open(spot)
func mystery(spot: String) -> bool: return M.mapview.mystery(spot)

# --- what a child does
func close_modal() -> void: M.modals.close_modal()
func close_sheet() -> void: M.sheets.close_sheet()
func show_card(cid: String) -> void: M.cards.show_card(cid)
func tap_patch(area: String, i: int) -> void: M.patches.on_patch(area, i)
func show_time_quiz() -> void: M.timequiz.show_time_quiz()
func show_question(box: VBoxContainer, q: Dictionary, on_done: Callable) -> void: M.timequiz.question(box, q, on_done)
func playback_speed(f: float) -> void: M.playback.speed = f     # 0 = the farm catches up after the Time Quiz without waiting
func tap_playback() -> void: M.playback.finish()
func show_rest() -> void: M.rest.show_rest()
func go_rest() -> void: M.rest.go_rest()
func rest_go() -> void: M.rest.rest_go()
func open_spot(spot: String) -> void: M.sheets.open_spot(spot)
func open_sheet(kind: String) -> void: M.sheets.open_sheet(kind)
func enter_corner(corner: String, parent: String) -> void: M.interiors.enter_corner(corner, parent)
func press_goal() -> void: M.goalbar.goal_pressed()
func show_menu() -> void: M.menu.show_menu()
func play_fx() -> void: M.mapview.play_fx()
func refresh() -> void: M.refresh()
func item_panel(k: String) -> void: M.pantry.item_panel(k)
func story_enabled(on: bool) -> void: M.story.enabled = on
func bubbles() -> int:      # sticky speech bubbles on the screen
	var n := 0
	for c in M.toasts.get_children():
		if c.get_meta("sticky", false): n += 1
	return n
func clear_toasts() -> void:
	for c in M.toasts.get_children(): c.queue_free()

# --- the grown-up lock
func grownup_open() -> bool: return M.menu.grownup_open()
func password_ok(t: String) -> bool: return M.menu.password_ok(t)
func set_grownup_open(on: bool) -> void: M.menu.grownup_until = 1e12 if on else 0.0
