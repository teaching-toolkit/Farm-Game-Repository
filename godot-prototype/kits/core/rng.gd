extends RandomNumberGenerator
## The one random source for a game's rules. Seedable (a seed gives the same game every time; the tests and the golden run
## rely on it), and every rule draws from it, never from the engine's global random functions.
## It is a RandomNumberGenerator, so it can be handed to anything that wants one (the learning kit does).
## (Inside this script the random functions are called through `self`: a bare randf() would be the engine's global one.)
## Knows nothing about any game.

## Shuffles an array in place (Fisher-Yates, so a seed gives the same order).
func shuffle(a: Array) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := self.randi_range(0, i)
		var t = a[i]; a[i] = a[j]; a[j] = t

## True with probability p.
func chance(p: float) -> bool:
	return self.randf() < p

## One element of a non-empty array.
func pick(a: Array):
	return a[self.randi_range(0, a.size() - 1)]
