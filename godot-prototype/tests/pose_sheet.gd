extends Control
## Shows every pose of data/acts.json on its own farmer (big), with a prop where it fits, and saves a picture.
## Run: DISPLAY=:99 godot --path . res://tests/pose_sheet.tscn -- --shot=poses.png   (needs a screen, e.g. xvfb-run)
const Avatar = preload("res://scripts/avatar.gd")
const PROP_FOR := {"pull_a": "", "sow_a": "seed_bag", "pour": "bucket", "dip": "bucket", "pick": "basket", "dig_a": "shovel",
	"dig_b": "shovel", "chop_up": "axe", "chop_down": "axe", "hammer_up": "hammer", "hammer_down": "hammer", "stir_a": "spoon",
	"stir_b": "spoon", "show": "coin", "read": "book"}

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color("9cc86a")
	bg.size = Vector2(1200, 900)
	add_child(bg)
	var D = JSON.parse_string(FileAccess.get_file_as_string("res://data/acts.json"))
	var names: Array = D["poses"].keys()
	var i := 0
	for n in names:
		var box := Control.new()                 # the farmer places itself by its feet: give each its own box, scaled up
		box.position = Vector2(0 + (i % 7) * 160, 10 + (i / 7) * 168)
		box.scale = Vector2(2.0, 2.0)
		add_child(box)
		var a = Avatar.new()
		a.feet = Vector2(40, 70)
		box.add_child(a)
		var l := Label.new()
		l.text = n
		l.position = box.position + Vector2(10, 146)
		l.add_theme_color_override("font_color", Color.BLACK)
		add_child(l)
		await get_tree().process_frame
		a.acting = true
		a.face_point(a.feet + Vector2(60, 12))         # turned towards the work, like on the farm
		a.set_pose(D["poses"][n], 0.0)
		var pr: String = PROP_FOR.get(n, "")
		if pr != "": a.hold(D["props"][pr], "l" if pr in ["bucket", "basket"] else "r")
		i += 1
	await get_tree().create_timer(1.0).timeout
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--shot="):
			get_viewport().get_texture().get_image().save_png(arg.substr(7))
			print("saved ", arg.substr(7))
	get_tree().quit()
