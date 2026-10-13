extends RefCounted
class_name FarmTrust
## Trust and reputation (TODO M8): the village distrusts the farm at first and warms as it visibly recovers; each trader warms to the farmer
## who does them a good turn. Both lower what seeds and wares cost (never raise it). Everything is derived from what has been done
## (goals, deliveries), so nothing is saved. Data: data/farm/rules/51-trust.json.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

func data() -> Dictionary:
	return G.meta.get("trust", {})

## The village's reputation level, 0 … max: the farm's main goals done, so many to a level.
func reputation() -> int:
	var r: Dictionary = data().get("reputation", {})
	return clampi(int(floorf(G.counter(str(r.get("counter", "goals"))) / maxf(1.0, float(r.get("perLevel", 14))))), 0, int(r.get("max", 4)))

func reputation_max() -> int:
	return int(data().get("reputation", {}).get("max", 4))

## One trader's trust level, 0 … max: the good turns done for them.
func level(person: String) -> int:
	var p: Dictionary = data().get("people", {}).get(person, {})
	var n := 0
	for d in p.get("deeds", []):
		if G.done(d): n += 1
	return mini(n, int(p.get("max", 3)))

func level_max(person: String) -> int:
	return int(data().get("people", {}).get(person, {}).get("max", 0))

## The price of a trader's seeds and wares as a share of the list price (1 = the list price).
func price_factor(person: String) -> float:
	var r: Dictionary = data().get("reputation", {})
	var disc: Array = r.get("discount", [0.0])
	var f := 1.0 - float(disc[mini(reputation(), disc.size() - 1)]) - float(data().get("perTrustLevel", 0.04)) * float(level(person))
	return maxf(float(data().get("floor", 0.75)), f)

## Hearts for a trader: ♥♥♡
func hearts(person: String) -> String:
	var m := level_max(person)
	if m <= 0: return ""
	return "♥".repeat(level(person)) + "♡".repeat(m - level(person))
