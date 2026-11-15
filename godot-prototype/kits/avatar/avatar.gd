## The farmer on the map: a little 3D figure built from simple shapes (toon-shaded, with an outline), rendered into a
## picture that stands among the buildings like everything else on the 2D map. It walks to wherever the player taps,
## around buildings, pens and fields (the map finds the way). The look comes from data/avatar.json — head, hair, shirt,
## trousers, shoes and hat are separate slots, so a "make your farmer" screen can change them later (set_look).
extends TextureRect

const LOOK_PATH := "res://data/avatar.json"
const VIEW := Vector2i(200, 200)        # pixels rendered (wide enough for bending and reaching while acting)
const SHOW := Vector2(76, 76)           # size on the map (farm pixels; the figure itself stays the same size)
const PITCH := 30.0                     # the camera looks down like the farm pictures (2:1)

var map                                 # the farm map (finds paths, sorts us among the standing things)
var data := {}
var look := {}
var vp: SubViewport
var cam: Camera3D
var rig: Node3D                         # turns to face the way it walks
var upper: Node3D                       # everything above the hips (bobs while walking)
var pivots := {}                        # hip_l/r, knee_l/r, sh_l/r, hand_l/r (props go here), head
var lean: Node3D                        # bends the upper body at the waist (acting)
const WAIST := 0.62
# acting (kits/avatar/actor.gd): a pose blends in over a time; props sit in the hands
var acting := false
var _pose_from := {}
var _pose_to := {}
var _pose_t := 1.0
var _pose_dur := 0.0
var props := {}                         # "l" / "r" -> the prop's Node3D
var _carry_face := 0.0
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
signal tapped      # the farmer was tapped (a wave and a hop; the game can open something)
var _hop := 0.0
var _sort_t := 0.0
var _foot_px := Vector2(75, 180)
var _outline: StandardMaterial3D
var _pending := {}
var _style := "plain"                  # look key "style": plain (default) | painted | painted_face (see _mat / set_look)
var _ramp: GradientTexture1D
var _white: ImageTexture
var _paint_shader: Shader

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

const PAINT_SHADER := "shader_type spatial;
uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D ramp : filter_linear, repeat_disable;
uniform sampler2D pat : source_color, filter_nearest, repeat_enable;
uniform vec2 pat_scale = vec2(1.0);
uniform float pat_amount = 0.0;
uniform sampler2D face : source_color, filter_linear, repeat_disable;
uniform float face_amount = 0.0;
varying vec3 lp;
void vertex() { lp = VERTEX; }
void fragment() {
	vec3 c = albedo.rgb;
	c *= mix(vec3(1.0), texture(pat, UV * pat_scale).rgb, pat_amount);
	vec4 f = texture(face, vec2(lp.x / 0.54 + 0.5, 0.5 - lp.y / 0.54));
	c = mix(c, f.rgb, face_amount * f.a * step(0.0, lp.z));
	ALBEDO = c;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
}
void light() {
	float nl = dot(NORMAL, LIGHT) * 0.5 + 0.5;
	DIFFUSE_LIGHT += texture(ramp, vec2(nl, 0.5)).rgb * ATTENUATION * LIGHT_COLOR;
}
"

## The painted look's soft shading ramp: a cooler, darker side and a warm light side, blended smoothly (instead of two flat bands).
func _paint_setup() -> void:
	if _paint_shader != null: return
	_paint_shader = Shader.new()
	_paint_shader.code = PAINT_SHADER
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 0.35, 0.65, 1.0])
	g.colors = PackedColorArray([Color(0.04, 0.07, 0.17), Color(0.13, 0.14, 0.22), Color(0.29, 0.25, 0.18), Color(0.37, 0.30, 0.20)])
	_ramp = GradientTexture1D.new()
	_ramp.gradient = g
	_ramp.width = 64
	var im := Image.create(2, 2, false, Image.FORMAT_RGBA8)
	im.fill(Color.WHITE)
	_white = ImageTexture.create_from_image(im)

## Slightly warmer and less saturated than the pure hex colours (the game's pictures are soft and warm).
func _warm(c: Color) -> Color:
	var o := Color.from_hsv(c.h, c.s * 0.9, minf(1.0, c.v * 0.97))
	return o.lerp(Color(1.0, 0.92, 0.78), 0.07)

## pat: an optional Texture2D multiplied over the colour (painted_face cloth patterns); face: the face picture on the front of a head.
func _mat(c: Color, outline := true, pat: Texture2D = null, pat_scale := Vector2.ONE, face: Texture2D = null) -> Material:
	if _style != "plain":
		_paint_setup()
		var sm := ShaderMaterial.new()
		sm.shader = _paint_shader
		sm.set_shader_parameter("albedo", _warm(c))
		sm.set_shader_parameter("ramp", _ramp)
		sm.set_shader_parameter("pat", pat if pat else _white)
		sm.set_shader_parameter("pat_scale", pat_scale)
		sm.set_shader_parameter("pat_amount", 1.0 if pat else 0.0)
		sm.set_shader_parameter("face", face if face else _white)
		sm.set_shader_parameter("face_amount", 1.0 if face else 0.0)
		if outline: sm.next_pass = _outline
		return sm
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
	c.height = maxf(h, r * 2.0)
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
	_style = str(look.get("style", "plain"))
	var pnt := _style != "plain"
	var bw := 1.14 if pnt else 1.0          # painted: chunkier body, thicker and shorter limbs, bigger head, hands and feet
	var lw := 1.3 if pnt else 1.0
	var lg := 0.85 if pnt else 1.0
	var hsz := 1.32 if pnt else 1.0
	var ext := 1.35 if pnt else 1.0
	var drop := 0.56 * (1.0 - lg)
	_outline.grow_amount = 0.03 if pnt else 0.016
	_outline.albedo_color = Color("3a2618") if pnt else Color("3b2a20")
	for c in rig.get_children(): c.queue_free()
	pivots.clear()
	props.clear()
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
	var pface := _style == "painted_face"
	var skin_head = skin
	if pface:
		skin_head = _mat(_col(look.get("skin", ""), "#f1c7a0"), true, null, Vector2.ONE, _face_texture())
		shirt_m = _mat(_col(shirt.get("color", ""), "#e86a4a"), true, _checks_texture(), Vector2(6, 5))
	# a soft shadow on the ground
	_mesh(rig, _cyl(0.3, 0.3, 0.002), _flat(Color(0.1, 0.12, 0.05, 0.25)), Vector3(0, 0.002, 0))
	# legs (from the hips) and shoes
	var tstyle := str(trou.get("style", "trousers"))
	for side in [-1.0, 1.0]:
		var sd := "l" if side < 0 else "r"
		var hip := _pivot(rig, "hip_" + sd, Vector3(0.1 * side * bw, 0.6 - drop, 0))
		var knee := _pivot(hip, "knee_" + sd, Vector3(0, -0.29 * lg, 0))      # knees, so the farmer can kneel and crouch
		if tstyle == "shorts":
			_mesh(hip, _capsule(0.1 * lw, 0.3 * lg), trou_m, Vector3(0, -0.12 * lg, 0))
			_mesh(knee, _capsule(0.072 * lw, 0.32 * lg), skin, Vector3(0, -0.12 * lg, 0))
		else:
			_mesh(hip, _capsule(0.088 * lw, 0.34 * lg), trou_m, Vector3(0, -0.14 * lg, 0))
			_mesh(knee, _capsule(0.085 * lw, 0.32 * lg), trou_m, Vector3(0, -0.12 * lg, 0))
		_mesh(knee, _sphere(0.1 * ext), shoe_m, Vector3(0, -0.27 * lg - 0.02 * (ext - 1.0), 0.04), Vector3(1.0, 0.6, 1.35))
	lean = Node3D.new()                 # the waist: everything above bends from here
	lean.position = Vector3(0, WAIST - drop, 0)
	rig.add_child(lean)
	upper = Node3D.new()
	upper.position = Vector3(0, -WAIST, 0)
	lean.add_child(upper)
	# body
	_mesh(upper, _capsule(0.2, 0.6), shirt_m, Vector3(0, 0.86, 0), Vector3(bw, 1.0, 0.82))
	_mesh(upper, _cyl(0.2, 0.2, 0.14), trou_m, Vector3(0, 0.64, 0), Vector3(bw, 1.0, 0.82))
	if tstyle == "overalls":
		_mesh(upper, _box(0.26 * bw, 0.22, 0.06), trou_m, Vector3(0, 0.86, 0.15))
		for side in [-1.0, 1.0]:
			_mesh(upper, _box(0.05, 0.36, 0.34), trou_m, Vector3(0.1 * side * bw, 0.98, 0.0))
			_mesh(upper, _sphere(0.022), _mat(Color("f2d23c"), false), Vector3(0.1 * side * bw, 0.95, 0.185))
	# arms (from the shoulders): sleeve and hand
	var long_sleeves: bool = str(shirt.get("style", "tee")) == "long"
	for side in [-1.0, 1.0]:
		var sh := _pivot(upper, "sh_l" if side < 0 else "sh_r", Vector3(0.25 * side * bw, 1.06, 0))
		_mesh(sh, _capsule(0.072 * lw, (0.26 if not long_sleeves else 0.46) * lg), shirt_m, Vector3(0.01 * side, (-0.09 if not long_sleeves else -0.19) * lg, 0))
		if not long_sleeves: _mesh(sh, _capsule(0.058 * lw, 0.34 * lg), skin, Vector3(0.01 * side, -0.25 * lg, 0))
		_mesh(sh, _sphere(0.066 * ext), skin, Vector3(0.012 * side, -0.43 * lg, 0))
		_pivot(sh, "hand_l" if side < 0 else "hand_r", Vector3(0.012 * side, -0.45 * lg, 0.02))
	# head: face, eyes, cheeks, nose
	var head := _pivot(upper, "head", Vector3(0, 1.13, 0))
	head.scale = Vector3.ONE * hsz
	_mesh(head, _cyl(0.07, 0.08, 0.1), skin, Vector3(0, 0.0, 0))
	_mesh(head, _sphere(0.26), skin_head, Vector3(0, 0.22, 0))
	var eye_m := _flat(_col(look.get("eyes", ""), "#3a2a22"))
	if not pface:
		for side in [-1.0, 1.0]:
			var eyem := _mesh(head, _sphere(0.036 if not pnt else 0.05), eye_m, Vector3(0.09 * side, 0.23, 0.232), Vector3(1.0, 1.25, 0.6))
			eyes.append(eyem)
			if pnt: _mesh(eyem, _sphere(0.016), _flat(Color.WHITE), Vector3(0.016, 0.02, 0.03))
			_mesh(head, _sphere(0.045), _flat(_col(look.get("cheeks", ""), "#f29a9a")), Vector3(0.155 * side, 0.15, 0.2), Vector3(1.0, 0.7, 0.4))
	_mesh(head, _sphere(0.032), _mat(_col(look.get("skin", ""), "#f1c7a0").darkened(0.08), false), Vector3(0, 0.18, 0.258))
	if not pface: _mesh(head, _box(0.07, 0.014, 0.01), eye_m, Vector3(0, 0.1, 0.245))
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
			hat_n.scale = Vector3.ONE * (0.8 if pnt else 1.0)
			head.add_child(hat_n)
			_mesh(hat_n, _cyl(0.44, 0.44, 0.03), hm, Vector3.ZERO)
			_mesh(hat_n, _cyl(0.19, 0.23, 0.17), hm, Vector3(0, 0.09, 0))
			_mesh(hat_n, _cyl(0.232, 0.232, 0.045), _mat(_col(hat.get("band", ""), "#c0392b"), false), Vector3(0, 0.04, 0))
		"cap":
			var cm := _mat(_col(hat.get("color", ""), "#3f8fd8"))
			_mesh(head, _sphere(0.28, true), cm, Vector3(0, 0.3, -0.01), Vector3(1.0, 0.85, 1.0), Vector3(-10, 0, 0))
			_mesh(head, _box(0.3, 0.025, 0.2), cm, Vector3(0, 0.33, 0.27), Vector3.ONE, Vector3(-8, 0, 0))
	# optional parts for the people of the village (a look without them builds nothing more): apron, beard, long skirt
	var apron: Dictionary = look.get("apron", {})
	if not apron.is_empty():
		var am := _mat(_col(apron.get("color", ""), "#fffaf0"), true, _stripes_texture() if pface else null, Vector2(3, 1))
		_mesh(upper, _box(0.3, 0.46, 0.05), am, Vector3(0, 0.78, 0.17), Vector3.ONE, Vector3(-3, 0, 0))
		_mesh(upper, _box(0.16, 0.14, 0.05), am, Vector3(0, 1.08, 0.17))
	var beard: Dictionary = look.get("beard", {})
	if not beard.is_empty():
		var bm := _mat(_col(beard.get("color", ""), "#5a3519"))
		_mesh(head, _sphere(0.2), bm, Vector3(0, 0.07, 0.12), Vector3(1.1, 0.95, 0.6))
	var skirt: Dictionary = look.get("skirt", {})
	if not skirt.is_empty():
		_mesh(rig, _cyl(0.22, 0.36, 0.5), _mat(_col(skirt.get("color", ""), "#a35dd8")), Vector3(0, 0.4, 0), Vector3(1.0, 1.0, 0.9))

# ------------------------------------------------------------------ small textures made in code (painted_face)
func _face_texture() -> ImageTexture:
	var n := 192
	var im := Image.create(n, n, false, Image.FORMAT_RGBA8)
	im.fill(Color(0, 0, 0, 0))
	var eye_c := _col(look.get("eyes", ""), "#3a2a22")
	var brow_c := _col((look.get("hair", {}) as Dictionary).get("color", ""), "#5a3519").darkened(0.25)
	var cheek_c := _col(look.get("cheeks", ""), "#f29a9a")
	for sd in [-1.0, 1.0]:
		var ex: float = 0.5 + 0.17 * sd
		_blob(im, Vector2(ex, 0.52), 0.09, 0.115, eye_c, 1.0)                 # big friendly eyes
		_blob(im, Vector2(ex - 0.03 * sd, 0.48), 0.03, 0.036, Color.WHITE, 1.0)     # highlight
		_blob(im, Vector2(ex + 0.025 * sd, 0.56), 0.014, 0.016, Color(1, 1, 1, 0.8), 1.0)
		_blob(im, Vector2(0.5 + 0.29 * sd, 0.66), 0.075, 0.05, cheek_c, 0.75)   # rosy cheeks
		for t in range(0, 11):                                                    # eyebrow: a short curved stroke
			var u := t / 10.0
			var bx: float = ex + (u - 0.5) * 0.15
			var by: float = 0.37 - sin(u * PI) * 0.025 + (u - 0.5) * 0.012 * sd
			_blob(im, Vector2(bx, by), 0.014, 0.012, brow_c, 1.0)
	for t in range(0, 15):                                                        # small smile
		var u := t / 14.0
		_blob(im, Vector2(0.5 + (u - 0.5) * 0.2, 0.75 + sin(u * PI) * 0.04), 0.012, 0.012, Color("7a3b30"), 1.0)
	return ImageTexture.create_from_image(im)

func _blob(im: Image, c: Vector2, rx: float, ry: float, col: Color, alpha: float) -> void:
	var n := im.get_width()
	var x0 := maxi(0, int((c.x - rx - 0.01) * n))
	var x1 := mini(n - 1, int((c.x + rx + 0.01) * n))
	var y0 := maxi(0, int((c.y - ry - 0.01) * n))
	var y1 := mini(n - 1, int((c.y + ry + 0.01) * n))
	for y in range(y0, y1 + 1):
		for x in range(x0, x1 + 1):
			var dx := ((x + 0.5) / n - c.x) / rx
			var dy := ((y + 0.5) / n - c.y) / ry
			var d := sqrt(dx * dx + dy * dy)
			var a := clampf((1.0 - d) * 6.0, 0.0, 1.0) * alpha
			if a <= 0.0: continue
			var old := im.get_pixel(x, y)
			var oa: float = a + old.a * (1.0 - a)
			var rgb := (Color(col.r, col.g, col.b) * a + Color(old.r, old.g, old.b) * old.a * (1.0 - a)) / maxf(oa, 0.001)
			im.set_pixel(x, y, Color(rgb.r, rgb.g, rgb.b, oa))

func _checks_texture() -> ImageTexture:
	var im := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	for y in 16:
		for x in 16:
			var dark: bool = ((x / 8) + (y / 8)) % 2 == 0
			im.set_pixel(x, y, Color(0.80, 0.80, 0.84) if dark else Color.WHITE)
	return ImageTexture.create_from_image(im)

func _stripes_texture() -> ImageTexture:
	var im := Image.create(16, 4, false, Image.FORMAT_RGBA8)
	for y in 4:
		for x in 16:
			im.set_pixel(x, y, Color(0.9, 0.55, 0.5) if x >= 6 and x < 10 else Color.WHITE)
	return ImageTexture.create_from_image(im)

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
		map.sort_in(self, feet.y)

func _animate(d: float) -> void:
	rig.rotation.y = lerp_angle(rig.rotation.y, _face, minf(1.0, d * 10.0))
	var target := 0.0
	if moving:
		_walk += d * 10.0
		target = 1.0
	_swing = lerpf(_swing, target, minf(1.0, d * 8.0))
	var s := sin(_walk) * 0.62 * _swing
	var P := _pose_now(d)              # the acting pose (all zero = standing)
	var still := 1.0 - _swing         # walking takes over legs and arms; the pose shows when standing
	if pivots.has("hip_l"):
		pivots["hip_l"].rotation.x = lerpf(P["hip_l"], s, _swing)
		pivots["hip_r"].rotation.x = lerpf(P["hip_r"], -s, _swing)
		pivots["knee_l"].rotation.x = lerpf(P["knee_l"], maxf(0.0, s) * 0.5, _swing)
		pivots["knee_r"].rotation.x = lerpf(P["knee_r"], maxf(0.0, -s) * 0.5, _swing)
		for sd in ["l", "r"]:
			var sh: Node3D = pivots["sh_" + sd]
			var walk_x := (-s if sd == "l" else s) * 0.85
			if props.has(sd): walk_x = -0.35          # carrying something: the arm stays forward
			sh.rotation.x = lerpf(P["sh_%s_x" % sd], walk_x, _swing)
			sh.rotation.z = lerpf(P["sh_%s_z" % sd], -0.08 if sd == "l" else 0.08, _swing)
	if lean: lean.rotation.x = P["lean"] * still
	var bob := absf(sin(_walk)) * 0.04 * _swing
	var breathe := sin(Time.get_ticks_msec() / 600.0) * 0.006 * (1.0 - _swing)
	if upper: upper.position.y = -WAIST + bob + breathe
	# crouching and kneeling bring the whole figure down; a hop (when tapped) lifts it
	var y: float = -float(P["drop"]) * still
	if _hop > 0.0:
		_hop = maxf(0.0, _hop - d)
		if _hop < 0.5: y += sin((0.5 - _hop) / 0.5 * PI) * 0.25
	rig.position.y = y
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
	# look around a little when standing idle; while acting the head follows the pose
	if pivots.has("head"):
		var look_y := sin(Time.get_ticks_msec() / 2300.0) * 0.25 * (1.0 - _swing) * (0.0 if acting else 1.0)
		pivots["head"].rotation.y = look_y
		pivots["head"].rotation.x = P["head"] * still

# ------------------------------------------------------------------ acting: poses and props (driven by kits/avatar/actor.gd)
const POSE_KEYS := ["drop", "lean", "head", "hip_l", "hip_r", "knee_l", "knee_r", "sh_l_x", "sh_l_z", "sh_r_x", "sh_r_z"]

## A pose from data/acts.json ("hip", "knee", "sh": [forward, out] for both sides; "_l"/"_r" for one side;
## "drop" lowers the figure, "lean" bends forward at the waist, "head" looks down) as joint angles.
static func expand_pose(p: Dictionary) -> Dictionary:
	var out := {}
	for k in POSE_KEYS: out[k] = 0.0
	out["sh_l_z"] = -0.08
	out["sh_r_z"] = 0.08
	for k in ["drop", "lean", "head"]: out[k] = float(p.get(k, 0.0))
	for sd in ["l", "r"]:
		out["hip_" + sd] = float(p.get("hip_" + sd, p.get("hip", 0.0)))
		out["knee_" + sd] = float(p.get("knee_" + sd, p.get("knee", 0.0)))
		var sh: Array = p.get("sh_" + sd, p.get("sh", [0.0, 0.08]))
		out["sh_%s_x" % sd] = float(sh[0])
		out["sh_%s_z" % sd] = (-1.0 if sd == "l" else 1.0) * float(sh[1] if sh.size() > 1 else 0.08)
	return out

## Blend into a pose over secs (0 = at once).
func set_pose(p: Dictionary, secs: float) -> void:
	_pose_from = _pose_now(0.0)
	_pose_to = expand_pose(p)
	_pose_dur = maxf(0.0, secs)
	_pose_t = 0.0 if secs > 0.0 else 1.0

func _pose_now(d: float) -> Dictionary:
	if _pose_to.is_empty(): _pose_to = expand_pose({})
	if _pose_from.is_empty(): _pose_from = _pose_to.duplicate()
	if _pose_t < 1.0: _pose_t = minf(1.0, _pose_t + (d / _pose_dur if _pose_dur > 0.0 else 1.0))
	var f := _pose_t * _pose_t * (3.0 - 2.0 * _pose_t)      # smooth in and out
	var out := {}
	for k in POSE_KEYS: out[k] = lerpf(float(_pose_from.get(k, 0.0)), float(_pose_to.get(k, 0.0)), f)
	return out

## Puts a prop (data/acts.json "props": simple shapes) into a hand ("l" or "r"); it stays there while walking.
func hold(prop: Dictionary, hand: String) -> void:
	drop(hand)
	var h: Node3D = pivots.get("hand_" + hand)
	if h == null: return
	var n := Node3D.new()
	for part in prop.get("parts", []):
		var sz: Array = part.get("size", [0.1, 0.1, 0.1])
		var mesh: Mesh
		match str(part.get("shape", "box")):
			"cyl": mesh = _cyl(float(sz[0]), float(sz[1]), float(sz[2]))
			"sphere": mesh = _sphere(float(sz[0]))
			"capsule": mesh = _capsule(float(sz[0]), float(sz[1]))
			_: mesh = _box(float(sz[0]), float(sz[1]), float(sz[2]))
		var pos: Array = part.get("pos", [0, 0, 0])
		var rot: Array = part.get("rot", [0, 0, 0])
		_mesh(n, mesh, _mat(Color(str(part.get("color", "#8a6239")))), Vector3(pos[0], pos[1], pos[2]), Vector3.ONE, Vector3(rot[0], rot[1], rot[2]))
	h.add_child(n)
	props[hand] = n

func drop(hand: String) -> void:
	if props.has(hand):
		if is_instance_valid(props[hand]): props[hand].queue_free()
		props.erase(hand)

func drop_all() -> void:
	for hd in props.keys(): drop(hd)

## Turn towards a point on the farm.
func face_point(p: Vector2) -> void:
	var g := Vector2(p.x - feet.x, (p.y - feet.y) * 2.0)
	if g.length() > 1.0: _face = atan2(g.x, g.y)

## Stop walking where it is (an act was interrupted).
func stop_walking() -> void:
	path = PackedVector2Array()
	moving = false

## Tapped: a wave and a little hop.
func greet() -> void:
	_wave = 1.4
	_hop = 0.5
	_face = 0.0

func _has_point(p: Vector2) -> bool:
	return Rect2(Vector2(size.x * 0.33, size.y * 0.05), Vector2(size.x * 0.34, size.y * 0.9)).has_point(p)

func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and not e.pressed:
		greet()
		tapped.emit()
		accept_event()
