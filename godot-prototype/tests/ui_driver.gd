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
func celebrations() -> Array: return M._celebrations
func rest_state() -> Dictionary: return M._rest
func is_open(spot: String) -> bool: return M.ui_map._is_open(spot)
func mystery(spot: String) -> bool: return M.ui_map._mystery(spot)

# --- what a child does
func close_modal() -> void: M.ui_modal._close_modal()
func close_sheet() -> void: M.ui_sheets._close_sheet()
func show_card(cid: String) -> void: M.ui_card._show_card(cid)
func tap_patch(area: String, i: int) -> void: M.ui_fields._on_patch(area, i)
func show_time_quiz() -> void: M.ui_quiz._show_time_quiz()
func show_question(box: VBoxContainer, q: Dictionary, on_done: Callable) -> void: M.ui_quiz._question(box, q, on_done)
func show_rest() -> void: M.ui_rest._open_rest()      # (the farmer's walk home first: _show_rest)
func rest_go() -> void: M.ui_rest._rest_go()
func open_spot(spot: String) -> void: M.ui_sheets._open_spot(spot)
func open_sheet(kind: String) -> void: M.ui_sheets._open_sheet(kind)
func enter_corner(corner: String, parent: String) -> void: M.ui_sheets._enter_corner(corner, parent)
func press_goal() -> void: M.ui_map._goal_pressed()
func show_menu() -> void: M.ui_settings._show_menu()
func play_fx() -> void: M.ui_map._play_fx()
func refresh() -> void: M._refresh()

# --- the grown-up lock
func grownup_open() -> bool: return M.ui_settings._grownup_open()
func password_ok(t: String) -> bool: return M.ui_settings._password_ok(t)
func set_grownup_open(on: bool) -> void: M.ui_settings._grownup_until = 1e12 if on else 0.0
