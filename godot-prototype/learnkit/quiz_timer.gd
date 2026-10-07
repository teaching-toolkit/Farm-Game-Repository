## LearnKit · the timer for a quick answer (2.5 s for a sum learned by heart, more for longer answers and harder levels).
##
##   var T = preload("res://learnkit/quiz_timer.gd").new()
##   T.start(q["limit"])          # seconds
##   T.left_share()               # 1.0 → 0.0 for a bar
##   T.quick()                    # answered in time?
extends RefCounted

var limit := 2.5
var _t0 := 0

func start(seconds: float) -> void:
	limit = maxf(0.1, seconds)
	_t0 = Time.get_ticks_msec()

## Seconds since start.
func elapsed() -> float:
	return float(Time.get_ticks_msec() - _t0) / 1000.0

func left_share() -> float:
	return clampf(1.0 - elapsed() / limit, 0.0, 1.0)

func quick() -> bool:
	return elapsed() <= limit

## Pretend the timer started earlier (tests).
func shift(seconds: float) -> void:
	_t0 -= int(seconds * 1000.0)
