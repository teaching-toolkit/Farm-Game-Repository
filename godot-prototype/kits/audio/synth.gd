## Little sounds, synthesised once at start (16-bit mono). play("coin" | "pop" | "chime" | "levelup" | "zap" | "ding" |
## "tick" | "bonk"). They stand in for sound files that are not there yet (sound.gd).
## (Moved out of the farm's fx.gd in R1, 12 Oct 2026, so the audio kit needs nothing from the farm.)
extends Node

const RATE := 22050
var streams := {}
var players: Array = []
var _next := 0
var bus := "Master"

func _ready() -> void:
	for i in range(4):
		var p := AudioStreamPlayer.new()
		p.volume_db = -6.0
		p.bus = bus
		add_child(p)
		players.append(p)
	streams["coin"] = _make(_coin())
	streams["pop"] = _make(_pop())
	streams["chime"] = _make(_notes([1047.0, 1319.0, 1568.0], 0.11, 0.5, 0.5))
	streams["levelup"] = _make(_notes([523.0, 659.0, 784.0, 1047.0], 0.09, 0.7, 0.55))
	streams["ding"] = _make(_notes([1568.0], 0.0, 0.35, 0.45))
	streams["zap"] = _make(_zap())
	streams["tick"] = _make(_notes([2093.0], 0.0, 0.05, 0.25))         # a soft click for taps
	streams["bonk"] = _make(_notes([196.0, 165.0], 0.08, 0.25, 0.4))   # a gentle low "not quite"

func play(name: String) -> void:
	if not streams.has(name) or players.is_empty(): return
	var p: AudioStreamPlayer = players[_next]
	_next = (_next + 1) % players.size()
	p.stream = streams[name]
	p.play()

func _make(samples: PackedFloat32Array) -> AudioStreamWAV:
	var data := PackedByteArray()
	data.resize(samples.size() * 2)
	for i in range(samples.size()):
		data.encode_s16(i * 2, int(clampf(samples[i], -1.0, 1.0) * 30000.0))
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_16_BITS
	w.mix_rate = RATE
	w.stereo = false
	w.data = data
	return w

func _env(t: float, dur: float, attack := 0.005) -> float:
	if t < attack: return t / attack
	return exp(-4.0 * (t - attack) / dur)

func _coin() -> PackedFloat32Array:
	var out := PackedFloat32Array()
	var n := int(RATE * 0.32)
	out.resize(n)
	for i in range(n):
		var t := float(i) / RATE
		var f := 988.0 if t < 0.07 else 1319.0
		var t0 := t if t < 0.07 else t - 0.07
		var v := sin(TAU * f * t) * 0.6 + sin(TAU * f * 2.0 * t) * 0.15
		out[i] = v * _env(t0, 0.07 if t < 0.07 else 0.25) * 0.7
	return out

func _pop() -> PackedFloat32Array:
	var out := PackedFloat32Array()
	var n := int(RATE * 0.12)
	out.resize(n)
	var ph := 0.0
	for i in range(n):
		var t := float(i) / RATE
		ph += TAU * lerpf(700.0, 180.0, t / 0.12) / RATE
		out[i] = sin(ph) * _env(t, 0.1, 0.002) * 0.8
	return out

func _notes(fs: Array, gap: float, dur: float, amp: float) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	var total := gap * (fs.size() - 1) + dur
	var n := int(RATE * total)
	out.resize(n)
	for i in range(n):
		var t := float(i) / RATE
		var v := 0.0
		for k in range(fs.size()):
			var tk := t - gap * k
			if tk < 0.0: continue
			var f: float = fs[k]
			v += (sin(TAU * f * tk) + 0.25 * sin(TAU * f * 2.76 * tk)) * _env(tk, dur)
		out[i] = v * amp / maxf(1.0, fs.size() * 0.6)
	return out

func _zap() -> PackedFloat32Array:
	var out := PackedFloat32Array()
	var n := int(RATE * 0.55)
	out.resize(n)
	var rnd := RandomNumberGenerator.new()
	var lp := 0.0
	for i in range(n):
		var t := float(i) / RATE
		var crackle := rnd.randf_range(-1.0, 1.0) * (1.0 if rnd.randf() < 0.35 else 0.2)
		lp = lp * 0.6 + crackle * 0.4
		var rumble := sin(TAU * 70.0 * t + sin(TAU * 9.0 * t) * 2.0)
		out[i] = (lp * _env(t, 0.12, 0.001) * 0.7 + rumble * _env(t, 0.45, 0.02) * 0.5)
	return out
