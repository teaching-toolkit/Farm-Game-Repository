## The farmer on the map: a little 3D figure built from simple shapes (toon-shaded, with an outline), rendered into a
## picture that stands among the buildings like everything else on the 2D map. It walks to wherever the player taps,
## around buildings, pens and fields (the map finds the way). The look comes from data/avatar.json — head, hair, shirt,
## trousers, shoes and hat are separate slots, so a "make your farmer" screen can change them later (set_look).
extends TextureRect

const LOOK_PATH := "res://data/avatar.json"
const VIEW := Vector2i(150, 200)        # pixels rendered
const SHOW := Vector2(57, 76)           # size on the map (farm pixels)
const PITCH := 30.0                     # the camera looks down like the farm pictures (2:1)

var map                                 # the farm map (finds paths, sorts us among the standing things)
var data := {}
var look := {}
var vp: SubViewport
var cam: Camera3D
var rig: Node3D                         # turns to face the way it walks
var upper: Node3D                       # everything above the hips (bobs while walking)
var pivots := {}                        # hip_l, hip_r, sh_l, sh_r, head
var eyes: Array = []
var feet := Vector2.ZERO                # where it stands, in farm coordinates
var path := PackedVector2Array()
var speed := 95.0
var moving := false
var _walk := 0.0
var _swing := 0.0
var _face := 0.0
var _blink := 2.5
var _wave := 0.0
var _hop := 0.0
var _sort_t := 0.0
var _foot_px := Vector2(75, 180)
var _outline: StandardMaterial3D
var _pending := {}

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_SCALE
	mouse_filter = Control.MOUSE_FILTER_PASS
	size = SHOW
	var txt := FileAccess.get_file_as_string(LOOK_PATH)
	var d = JSON.parse_string(txt) if txt != "" else null
	data = d if typeof(d) == TYPE_DICTIONARY else {}
	speed = float(data.get("walk", {}).get("speed", 95.0))
	_make_view()
	set_look(_pending)
	_place()

# ------------------------------------------------------------------ the little 3D stage
func _make_view() -> void:
	vp = SubViewport.new()
	vp.size = VIEW
	vp.transparent_bg = true
	vp.own_world_3d = true
	vp.msaa_3d = Viewport.MSAA_4X
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)
	var world := Node3D.new()
	vp.add_child(world)
	cam = Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = 1.95
	cam.rotation_degrees = Vector3(-PITCH, 0, 0)
	var target := Vector3(0, 0.74, 0)
	cam.position = target + Vector3(0, sin(deg_to_rad(PITCH)), cos(deg_to_rad(PITCH))) * 8.0
	cam.near = 0.1
	cam.far = 30.0
	world.add_child(cam)
	cam.current = true
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-55, -40, 0)
	sun.light_energy = 1.0
	world.add_child(sun)
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(1.0, 0.96, 0.9)
	env.ambient_light_energy = 0.6
	var we := WorldEnvironment.new()
	we.environment = env
	world.add_child(we)
	rig = Node3D.new()
	world.add_child(rig)
	texture = vp.get_texture()
	_outline = StandardMaterial3D.new()
	_outline.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_outline.cull_mode = BaseMaterial3D.CULL_FRONT
	_outline.grow = true
	_outline.grow_amount = 0.016
	_outline.albedo_color = Color("3b2a20")
	_foot_px = cam.unproject_position(Vector3.ZERO)

func _mat(c: Color, outline := true) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.diffuse_mode = BaseMaterial3D.DIFFUSE_TOON
	m.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	m.roughness = 1.0
	if outline: m.next_pass = _outline
	return m

func _flat(c: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = c
	if c.a < 1.0: m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return m

func _mesh(parent: Node3D, mesh: Mesh, mat: Material, pos: Vector3, scl := Vector3.ONE, rot := Vector3.ZERO) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	mi.scale = scl
	mi.rotation_degrees = rot
	parent.add_child(mi)
	return mi

func _sphere(r: float, hemi := false) -> SphereMesh:
	var s := SphereMesh.new()
	s.radius = r
	s.height = r if hemi else r * 2.0
	s.is_hemisphere = hemi
	s.radial_segments = 20
	s.rings = 10
	return s

func _capsule(r: float, h: float) -> CapsuleMesh:
	var c := CapsuleMesh.new()
	c.radius = r
	c.height = h
	c.radial_segments = 14
	c.rings = 4
	return c

func _cyl(top: float, bottom: float, h: float) -> CylinderMesh:
	var c := CylinderMesh.new()
	c.top_radius = top
	c.bottom_radius = bottom
	c.height = h
	c.radial_segments = 22
	return c

func _box(x: float, y: float, z: float) -> BoxMesh:
	var b := BoxMesh.new()
	b.size = Vector3(x, y, z)
	return b

func _pivot(parent: Node3D, name: String, pos: Vector3) -> Node3D:
	var n := Node3D.new()
	n.position = pos
	parent.add_child(n)
	pivots[name] = n
	return n

func _col(v, def: String) -> Color:
	return Color(str(v)) if str(v) != "" else Color(def)

## Builds the figure from a look (see data/avatar.json "default"). Missing parts fall back to the default look.
func set_look(lk: Dictionary) -> void:
	if rig == null:
		_pending = lk
		return
	var def: Dictionary = data.get("default", {})
	look = def.duplicate(true)
	for k in lk: look[k] = lk[k]
	for c in rig.get_children(): c.queue_free()
	pivots.clear()
	eyes.clear()
	var skin := _mat(_col(look.get("skin", ""), "#f1c7a0"))
	var hair: Dictionary = look.get("hair", {})
	var shirt: Dictionary = look.get("shirt", {})
	var trou: Dictionary = look.get("trousers", {})
	var hat: Dictionary = look.get("hat", {})
	var shirt_m := _mat(_col(shirt.get("color", ""), "#e86a4a"))
	var trou_m := _mat(_col(trou.get("color", ""), "#4a6fa5"))
	var shoe_m := _mat(_col(look.get("shoes", {}).get("color", ""), "#6b4a2b"))
	var hair_m := _mat(_col(hair.get("color", ""), "#7a4a26"))
	# a soft shadow on the ground
	_mesh(rig, _cyl(0.3, 0.3, 0.002), _flat(Color(0.1, 0.12, 0.05, 0.25)), Vector3(0, 0.002, 0))
	# legs (from the hips) and shoes
	var tstyle := str(trou.get("style", "trousers"))
	for side in [-1.0, 1.0]:
		var hip := _pivot(rig, "hip_l" if side < 0 else "hip_r", Vector3(0.1 * side, 0.6, 0))
		if tstyle == "shorts":
			_mesh(hip, _capsule(0.1, 0.3), trou_m, Vector3(0, -0.12, 0))
			_mesh(hip, _capsule(0.072, 0.42), skin, Vector3(0, -0.33, 0))
		else:
			_mesh(hip, _capsule(0.088, 0.58), trou_m, Vector3(0, -0.27, 0))
		_mesh(hip, _sphere(0.1), shoe_m, Vector3(0, -0.56, 0.04), Vector3(1.0, 0.6, 1.35))
	upper = Node3D.new()
	rig.add_child(upper)
	# body
	_mesh(upper, _capsule(0.2, 0.6), shirt_m, Vector3(0, 0.86, 0), Vector3(1.0, 1.0, 0.82))
	_mesh(upper, _cyl(0.2, 0.2, 0.14), trou_m, Vector3(0, 0.64, 0), Vector3(1.0, 1.0, 0.82))
	if tstyle == "overalls":
		_mesh(upper, _box(0.26, 0.22, 0.06), trou_m, Vector3(0, 0.86, 0.15))
		for side in [-1.0, 1.0]:
			_mesh(upper, _box(0.05, 0.36, 0.34), trou_m, Vector3(0.1 * side, 0.98, 0.0))
			_mesh(upper, _sphere(0.022), _mat(Color("f2d23c"), false), Vector3(0.1 * side, 0.95, 0.185))
	# arms (from the shoulders): sleeve and hand
	var long_sleeves: bool = str(shirt.get("style", "tee")) == "long"
	for side in [-1.0, 1.0]:
		var sh := _pivot(upper, "sh_l" if side < 0 else "sh_r", Vector3(0.25 * side, 1.06, 0))
		_mesh(sh, _capsule(0.072, 0.26 if not long_sleeves else 0.46), shirt_m, Vector3(0.01 * side, -0.09 if not long_sleeves else -0.19, 0))
		if not long_sleeves: _mesh(sh, _capsule(0.058, 0.34), skin, Vector3(0.01 * side, -0.25, 0))
		_mesh(sh, _sphere(0.066), skin, Vector3(0.012 * side, -0.43, 0))
	# head: face, eyes, cheeks, nose
	var head := _pivot(upper, "head", Vector3(0, 1.13, 0))
	_mesh(head, _cyl(0.07, 0.08, 0.1), skin, Vector3(0, 0.0, 0))
	_mesh(head, _sphere(0.26), skin, Vector3(0, 0.22, 0))
	var eye_m := _flat(_col(look.get("eyes", ""), "#3a2a22"))
	for side in [-1.0, 1.0]:
		eyes.append(_mesh(head, _sphere(0.036), eye_m, Vector3(0.09 * side, 0.23, 0.232), Vector3(1.0, 1.25, 0.6)))
		_mesh(head, _sphere(0.045), _flat(_col(look.get("cheeks", ""), "#f29a9a")), Vector3(0.155 * side, 0.15, 0.2), Vector3(1.0, 0.7, 0.4))
	_mesh(head, _sphere(0.032), _mat(_col(look.get("skin", ""), "#f1c7a0").darkened(0.08), false), Vector3(0, 0.18, 0.258))
	_mesh(head, _box(0.07, 0.014, 0.01), eye_m, Vector3(0, 0.1, 0.245))
	# hair
	var hs := str(hair.get("style", "short"))
	if hs != "none":
		_mesh(head, _sphere(0.275, true), hair_m, Vector3(0, 0.29, -0.01), Vector3(1.0, 0.9, 1.0), Vector3(-14, 0, 0))
		_mesh(head, _sphere(0.25), hair_m, Vector3(0, 0.21, -0.08), Vector3(1.04, 1.0, 0.9))
		match hs:
			"long":
				_mesh(head, _box(0.44, 0.42, 0.14), hair_m, Vector3(0, 0.0, -0.15))
			"pigtails":
				for side in [-1.0, 1.0]:
					_mesh(head, _sphere(0.095), hair_m, Vector3(0.29 * side, 0.12, -0.06))
			"bun":
				_mesh(head, _sphere(0.11), hair_m, Vector3(0, 0.52, -0.1))
	# hat
	match str(hat.get("style", "none")):
		"straw":
			var hm := _mat(_col(hat.get("color", ""), "#e9c46a"))
			var hat_n := Node3D.new()
			hat_n.position = Vector3(0, 0.42, -0.01)
			hat_n.rotation_degrees = Vector3(-10, 0, 0)
			head.add_child(hat_n)
			_mesh(hat_n, _cyl(0.44, 0.44, 0.03), hm, Vector3.ZERO)
			_mesh(hat_n, _cyl(0.19, 0.23, 0.17), hm, Vector3(0, 0.09, 0))
			_mesh(hat_n, _cyl(0.232, 0.232, 0.045), _mat(_col(hat.get("band", ""), "#c0392b"), false), Vector3(0, 0.04, 0))
		"cap":
			var cm := _mat(_col(hat.get("color", ""), "#3f8fd8"))
			_mesh(head, _sphere(0.28, true), cm, Vector3(0, 0.3, -0.01), Vector3(1.0, 0.85, 1.0), Vector3(-10, 0, 0))
			_mesh(head, _box(0.3, 0.025, 0.2), cm, Vector3(0, 0.33, 0.27), Vector3.ONE, Vector3(-8, 0, 0))

# ------------------------------------------------------------------ walking
## Where it stands now (farm coordinates).
func set_feet(p: Vector2) -> void:
	feet = p
	_place()

func _place() -> void:
	position = feet - _foot_px * (SHOW / Vector2(VIEW))
	_sort_t = 1.0     # sort among the standing things on the next frame

## Walk there (map coordinates); the map finds a way around what stands in between.
func walk_to(p: Vector2) -> void:
	if map == null: return
	var pts: PackedVector2Array = map.find_path(feet, p)
	if pts.size() < 2: return
	path = pts
	path.remove_at(0)
	moving = true

func _process(d: float) -> void:
	if rig == null: return
	if moving and path.size() > 0:
		var to: Vector2 = path[0] - feet
		var step := speed * d
		if to.length() <= step:
			feet = path[0]
			path.remove_at(0)
			if path.is_empty(): moving = false
		else:
			feet += to.normalized() * step
			var g := Vector2(to.x, to.y * 2.0)    # unsquash the 2:1 view to get the direction on the ground
			_face = atan2(g.x, g.y)
		position = feet - _foot_px * (SHOW / Vector2(VIEW))
	_animate(d)
	_sort_t += d
	if _sort_t > 0.15 and map:
		_sort_t = 0.0
		map._sort_in(self, feet.y)

func _animate(d: float) -> void:
	rig.rotation.y = lerp_angle(rig.rotation.y, _face, minf(1.0, d * 10.0))
	var target := 0.0
	if moving:
		_walk += d * 10.0
		target = 1.0
	_swing = lerpf(_swing, target, minf(1.0, d * 8.0))
	var s := sin(_walk) * 0.62 * _swing
	if pivots.has("hip_l"):
		pivots["hip_l"].rotation.x = s
		pivots["hip_r"].rotation.x = -s
		pivots["sh_l"].rotation.x = -s * 0.85
		pivots["sh_r"].rotation.x = s * 0.85
		pivots["sh_l"].rotation.z = -0.08
		pivots["sh_r"].rotation.z = 0.08
	var bob := absf(sin(_walk)) * 0.04 * _swing
	var breathe := sin(Time.get_ticks_msec() / 600.0) * 0.006 * (1.0 - _swing)
	if upper: upper.position.y = bob + breathe
	# hop (when tapped)
	if _hop > 0.0:
		_hop = maxf(0.0, _hop - d)
		rig.position.y = sin((0.5 - _hop) / 0.5 * PI) * 0.25 if _hop < 0.5 else 0.0
	else:
		rig.position.y = 0.0
	# wave
	if _wave > 0.0 and pivots.has("sh_r"):
		_wave = maxf(0.0, _wave - d)
		pivots["sh_r"].rotation.z = 2.6 + sin(_wave * 18.0) * 0.35
		pivots["sh_r"].rotation.x = 0.0
	# blink now and then
	_blink -= d
	var shut := _blink < 0.0
	if _blink < -0.13: _blink = randf_range(2.0, 5.0)
	for e in eyes:
		if is_instance_valid(e): e.scale.y = 0.15 if shut else 1.25
	# look around a little when standing
	if pivots.has("head"):
		var look_y := sin(Time.get_ticks_msec() / 2300.0) * 0.25 * (1.0 - _swing)
		pivots["head"].rotation.y = look_y

## Tapped: a wave and a little hop.
func greet() -> void:
	_wave = 1.4
	_hop = 0.5
	_face = 0.0

func _has_point(p: Vector2) -> bool:
	return Rect2(Vector2(size.x * 0.22, size.y * 0.05), Vector2(size.x * 0.56, size.y * 0.9)).has_point(p)

func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and not e.pressed:
		greet()
		accept_event()
