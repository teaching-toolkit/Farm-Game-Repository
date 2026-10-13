extends Node
## Screenshots of the playback after the Time Quiz (J4): plants wheat, opens the quiz, lets 8 questions pass, closes it
## and saves the screen at a few moments. Run with a display (xvfb-run …) and: res://tests/playback_shots.tscn -- --seed=1 --out=DIR
var G
var M
var D
var out := "/tmp"

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="): out = a.substr(6)
	G = get_node("/root/Game")
	G.S["step"] = 1
	G.S["unlocked"]["k_wheat"] = true; G.S["unlocked"]["crop_wheat"] = true; G.S["unlocked"]["clear_thistles"] = true
	G.S["seeds"]["crop_wheat"] = 10.0
	G.S["water"] = 10.0; G.S["energy"] = 20.0
	G._dirty()
	for i in range(3):
		if G.patch_usable("field", i): G.plant("field", i, "crop_wheat")
	M = load("res://main.tscn").instantiate()
	add_child(M)
	D = preload("res://tests/ui_driver.gd").new(M)
	await _frames(10)
	D.close_modal()
	await _frames(5)
	await _shot("0-before")
	D.show_time_quiz()
	await _frames(3)
	for k in range(8): G.step_time()
	G.S["energy"] = 14.0
	G.changed.emit()
	await _frames(3)
	await _shot("1-quiz")
	D.close_modal()
	for t in [0.4, 1.0, 1.4, 2.0, 3.2]:
		await get_tree().create_timer(t - (0.0 if t == 0.4 else 0.0)).timeout
		await _shot("2-after-%.1f" % t)
	print("playing at the end: ", M.ui_play.playing)
	get_tree().quit()

func _frames(n: int) -> void:
	for _i in range(n): await get_tree().process_frame

func _shot(name: String) -> void:
	await get_tree().process_frame
	get_viewport().get_texture().get_image().save_png("%s/playback-%s.png" % [out, name])
	print("saved ", name)
