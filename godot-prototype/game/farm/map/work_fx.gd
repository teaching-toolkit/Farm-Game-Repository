extends Control
class_name FarmWorkFx
## A place that is working shows it: a few soft puffs of smoke rise from its chimney, and a warm glow pulses at its fire.
## It lies on top of the place's picture (the slot sets it up) and draws only while the place is working; a place whose picture
## has no entry in data/farm/places.json "fires" shows nothing. When the work is done no new puff is made and the ones in the air
## finish their rise, so the smoke thins out and stops.
## It is driven by the clock alone (like the ripe plants' sway): nothing in the rules or the saves ever reads it.

const Spots = preload("res://game/farm/spots.gd")
const IsoField = preload("res://game/farm/map/iso_field.gd")
const PUFFS := 4              # puffs in the air at a time
const PERIOD := 5.0           # seconds a puff takes to rise and fade: slow, not busy
const RISE := 0.26            # how far a puff rises, as a share of the picture's height
const FADE_OUT := 1.2         # seconds the glow takes to die away

var _fire := {}               # the picture's entry: {"smoke": [x, y], "glow": [x, y]}
var _on := false
var _off_t := -1000.0         # when the work stopped (seconds on the clock)
var _since := 0.0

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_meta("plain", true)    # the season's shader (snow caps, autumn gold) is for pictures, not for smoke
	set_process(false)

## `tex` is the picture of the place, `working` whether something is going on there now. Called at every refresh: it keeps the
## animation going (it has no state but the clock), so calling it again changes nothing.
func show_for(tex: Texture2D, working: bool) -> void:
	_fire = Spots.fire(_key_of(tex)) if tex != null else {}
	var on := working and not _fire.is_empty()
	if _on and not on: _off_t = _now()
	_on = on
	set_process(on or _now() - _off_t < maxf(PERIOD, FADE_OUT))
	queue_redraw()

## "folder/name" of a loaded picture (res://assets/map/cottage.png -> "map/cottage").
func _key_of(tex: Texture2D) -> String:
	return tex.resource_path.trim_prefix("res://assets/").get_basename()

func _now() -> float:
	return Time.get_ticks_msec() / 1000.0

func _process(d: float) -> void:
	_since += d
	if _since < 0.05: return        # about 20 times a second is smooth enough for slow smoke
	_since = 0.0
	queue_redraw()
	if not _on and _now() - _off_t > maxf(PERIOD, FADE_OUT): set_process(false)

func _draw() -> void:
	var t := _now()
	if _fire.is_empty() or (not _on and t - _off_t > maxf(PERIOD, FADE_OUT)): return
	if _fire.has("glow"): _glow(t)
	if _fire.has("smoke"): _smoke(t)

## The fire's mouth: a warm round glow that breathes a little.
func _glow(t: float) -> void:
	var g: Array = _fire["glow"]
	var at := Vector2(float(g[0]) * size.x, float(g[1]) * size.y)
	var k := 1.0 if _on else clampf(1.0 - (t - _off_t) / FADE_OUT, 0.0, 1.0)
	var pulse := (0.8 + 0.2 * sin(t * 3.2)) * k
	var tex := IsoField.IsoPatch.glow_tex()
	for layer in [[0.42, 0.8], [0.2, 1.0]]:          # a wide soft one and a small bright one
		var gw: float = size.x * layer[0]
		draw_texture_rect(tex, Rect2(at - Vector2(gw, gw) / 2.0, Vector2(gw, gw)), false, Color(1.0, 0.62, 0.22, pulse * layer[1]))

## The chimney: puffs of soft grey that rise straight up, grow a little and fade. Each puff has its own place in the cycle; after the
## work is done only the puffs that were already made go on.
func _smoke(t: float) -> void:
	var s: Array = _fire["smoke"]
	var from := Vector2(float(s[0]) * size.x, float(s[1]) * size.y)
	for i in range(PUFFS):
		var cycle := t / PERIOD + float(i) / PUFFS
		var born := (floorf(cycle) - float(i) / PUFFS) * PERIOD       # when this puff left the chimney
		if not _on and born > _off_t: continue
		var ph := cycle - floorf(cycle)                                # 0 at the chimney, 1 when it is gone
		var a := minf(ph / 0.12, 1.0) * (1.0 - ph) * 1.0
		var r := size.x * (0.034 + 0.045 * ph)
		var p := from + Vector2(0.0, -ph * RISE * size.y)
		for ring in [[1.0, 0.35], [0.7, 0.4], [0.42, 0.5]]:            # three circles on top of each other make a soft edge
			draw_circle(p, r * ring[0], Color(0.58, 0.58, 0.63, a * ring[1]))
