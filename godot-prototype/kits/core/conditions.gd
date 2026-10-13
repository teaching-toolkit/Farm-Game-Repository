extends RefCounted
## One small language for "when" in data (unlocks of perks and golden acorns, later story pieces and the unlock schedule):
##   unlocked:<id>      (or done:<id>)   the provider says that node is done
##   <counter>>=<n>                      the provider's counter reaches n   (weeds>=20, seasons>=2, chapter>=2, step>=40 …)
##   seen:<id>                           the provider says that thing has been shown (an interface element, a story piece)
##   <name>:<argument>, <name>           anything else is a term of the game: the provider's term(name, argument) -> bool
##                                       (story: start, has:<item>:<n>, season:<name>, chapter:<n>, tap:<place>, page:<card>, chance:<p> …)
## The provider is any object with  done(id) -> bool  and  counter(name) -> float  (NAN for a counter it does not know,
## which makes the condition false); `seen(id) -> bool` is needed only for seen: terms, `term(name, arg) -> bool` only for the game's own terms. To teach the language a new kind of term,
## add it here; new counters need no change here.
## Knows nothing about any game.

## A list of conditions: all of them must hold (an empty list holds: "no condition").
static func check_all(list: Array, provider) -> bool:
	for expr in list:
		if not check(str(expr), provider): return false
	return true

static func check(expr: String, provider) -> bool:
	if expr.begins_with("seen:"): return provider.has_method("seen") and provider.seen(expr.substr(5))
	for pre in ["unlocked:", "done:"]:
		if expr.begins_with(pre): return provider.done(expr.substr(pre.length()))
	var p := expr.split(">=")
	if p.size() == 2: return provider.counter(p[0]) >= float(p[1])
	# any other term is the game's own: "start", "has:carrot:3", "season:winter", "tap:market" … asked as term(name, argument)
	var i := expr.find(":")
	var name := expr if i < 0 else expr.substr(0, i)
	var arg := "" if i < 0 else expr.substr(i + 1)
	return provider.has_method("term") and bool(provider.term(name, arg))
