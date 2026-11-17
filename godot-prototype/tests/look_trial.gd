extends Control
## THROWAWAY TRIAL (people/05): three looks for the farmer and the village people side by side.
## A = the rig restyled ("style": "painted"), B = A plus faces and cloth patterns made in code ("painted_face"),
## C = a 2D cut-out puppet (tests/look_trial_puppet.gd). Run (needs a real window, headless draws no 3D):
##   godot --path . --resolution 1200x900 res://tests/look_trial.tscn -- --shot=look-trial.png
const Avatar = preload("res://kits/avatar/avatar.gd")
const Puppet = preload("res://tests/look_trial_puppet.gd")
const BIG := 3.0
const CX := [200.0, 600.0, 1000.0]
const ROW_Y := [360.0, 640.0]          # feet of the standing row and of the mid-step row
const NAMES := ["A  rig, painted", "B  rig, painted + textures", "C  2D cut-out puppet"]

var stage: SubViewport      # everything is drawn into a 1200 x 900 stage, whatever the window size

func _ready() -> void:
	stage = SubViewport.new()
	stage.size = Vector2i(1200, 900)
	stage.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(stage)
	var show_it := TextureRect.new()
	show_it.texture = stage.get_texture()
	show_it.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	show_it.size = Vector2(1200, 900)
	add_child(show_it)
	var bg := ColorRect.new()
	bg.color = Color("9cc86a")
	bg.size = Vector2(1200, 900)
	stage.add_child(bg)
	var D = JSON.parse_string(FileAccess.get_file_as_string("res://data/avatar.json"))
	var P = JSON.parse_string(FileAccess.get_file_as_string("res://data/farm/rules/58-people.json"))
	var farmer: Dictionary = D["default"].duplicate(true)
	var merchant: Dictionary = D["default"].duplicate(true)
	for k in P["people"]["who"]["seed_seller"]["look"]: merchant[k] = P["people"]["who"]["seed_seller"]["look"][k]
	# the buildings, for comparison (below the groups; the real-size farmers stand in front of the stall)
	_picture("res://assets/map/market_stall.png", Vector2(400, 690), 0.42)
	_picture("res://assets/map/tent.png", Vector2(680, 700), 0.42)
	var avatars: Array = []
	for g in 3:
		_letter(NAMES[g], CX[g])
		for row in 2:
			for who in 2:
				var lk: Dictionary = farmer if who == 0 else merchant
				var feet := Vector2(CX[g] + (-95.0 if who == 0 else 95.0), ROW_Y[row])
				match g:
					0, 1:
						var lk2 := lk.duplicate(true)
						lk2["style"] = "painted" if g == 0 else "painted_face"
						avatars.append([_avatar(lk2, feet, BIG), row])
					2:
						var pu := Puppet.new()
						pu.position = feet
						pu.scale = Vector2(2.7, 2.7)
						stage.add_child(pu)
						pu.setup(lk, 1.0 if who == 0 else -1.0, 0.0 if row == 0 else 0.55)
	# the real size: how the child sees them (76 px boxes), one row: today's farmer, A, B, C
	var cap := Label.new()
	cap.text = "real size (76 px boxes):  today | A | B | C"
	cap.position = Vector2(20, 745)
	cap.add_theme_color_override("font_color", Color.BLACK)
	stage.add_child(cap)
	var today := farmer.duplicate(true)
	today["style"] = "plain"                  # the figure before the trial (the game now defaults to painted_face, people/05)
	var plain = _avatar(today, Vector2(60, 860), 1.0)
	for g in 2:
		var lk3 := farmer.duplicate(true)
		lk3["style"] = "painted" if g == 0 else "painted_face"
		avatars.append([_avatar(lk3, Vector2(130 + g * 70, 860), 1.0), 0])
	var pu2 := Puppet.new()
	pu2.position = Vector2(270, 860)
	pu2.scale = Vector2(0.75, 0.75)       # about as tall as the 76 px farmer's figure
	stage.add_child(pu2)
	pu2.setup(farmer, 1.0, 0.0)
	await get_tree().process_frame
	await get_tree().process_frame
	# freeze: standing or in mid-step (a clear stride, turned a little)
	for a in avatars:
		var av = a[0]
		av.set_process(false)
		if a[1] == 1:
			av._swing = 1.0
			av._walk = PI / 2.0
			av._face = 0.9
			av.rig.rotation.y = 0.9
		av._animate(0.0)
	plain.set_process(false)
	plain._animate(0.0)
	await get_tree().create_timer(1.0).timeout
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--shot="):
			stage.get_texture().get_image().save_png(arg.substr(7))
			print("saved ", arg.substr(7))
	get_tree().quit()

func _avatar(lk: Dictionary, feet: Vector2, scl: float):
	var box := Control.new()
	var a = Avatar.new()
	a.feet = Vector2(38, 68)
	a.set_look(lk)
	box.scale = Vector2(scl, scl)
	box.position = feet - a.feet * scl
	stage.add_child(box)
	box.add_child(a)
	return a

func _letter(t: String, cx: float) -> void:
	var l := Label.new()
	l.text = t
	l.position = Vector2(cx - 190, 4)
	l.size = Vector2(380, 70)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", 30)
	l.add_theme_color_override("font_color", Color.WHITE)
	l.add_theme_color_override("font_outline_color", Color("4a3322"))
	l.add_theme_constant_override("outline_size", 8)
	stage.add_child(l)
	var big := Label.new()
	big.text = t.substr(0, 1)
	big.position = Vector2(cx - 190, 40)
	big.add_theme_font_size_override("font_size", 72)
	big.add_theme_color_override("font_color", Color("fff3d0"))
	big.add_theme_color_override("font_outline_color", Color("4a3322"))
	big.add_theme_constant_override("outline_size", 12)
	stage.add_child(big)

func _picture(path: String, pos: Vector2, scl: float) -> void:
	if not ResourceLoader.exists(path): return
	var tr := TextureRect.new()
	tr.texture = load(path)
	tr.position = pos
	tr.scale = Vector2(scl, scl)
	stage.add_child(tr)
