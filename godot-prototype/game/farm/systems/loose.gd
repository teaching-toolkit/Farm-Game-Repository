extends RefCounted
class_name FarmLoose
## Sticks and small stones lying about on the farm (visible-work/03): many at the start, a new one every so many steps (never more than
## `max` at once), each picked up with a tap (the chore pick_loose). The rules only know WHERE a thing lies as a share u, v of the farm's
## area, rolled with the Game's random source and saved; the map turns that into the nearest free spot. Data: data/farm/rules/68-loose.json.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game.
func save_defaults() -> Dictionary:
	return {"loose": {"things": [], "next": 1}}

func data() -> Dictionary:
	return G.meta.get("loose", {})

## What lies about now: [{"id", "k" (the item), "u", "v"}].
func things() -> Array:
	return G.S["loose"]["things"]

func count() -> int:
	return things().size()

## A new game: the start things are rolled once.
func roll_start() -> void:
	var st: Dictionary = data().get("start", {})
	for k in st:
		for _i in range(int(st[k])): _add(str(k))

func _add(kind: String) -> void:
	var L: Dictionary = G.S["loose"]
	var u: float = G.rng.randf()
	var v: float = G.rng.randf()
	L["things"].append({"id": int(L["next"]), "k": kind, "u": u, "v": v})
	L["next"] = int(L["next"]) + 1

## One step of time: every `every` steps one new thing, of the kinds in turn, while fewer than `max` lie about.
func step(_info: Dictionary) -> void:
	var every := maxi(1, int(data().get("every", 6)))
	var kinds: Array = data().get("kinds", ["stick", "stone"])
	if kinds.is_empty() or int(G.S["step"]) % every != 0 or count() >= int(data().get("max", 10)): return
	_add(str(kinds[(int(G.S["step"]) / every) % kinds.size()]))

func kind_of(id: int) -> String:
	for t in things():
		if int(t["id"]) == id: return str(t["k"])
	return ""

## Picks one up (the chore, so the cost and the "too tired" answer are the usual ones). Returns whether it was picked.
func pick(id: int) -> bool:
	return G.actions.perform("pick_loose", G.actions.farmer, {"id": id})["done"]

# ------------------------------------------------------------------ the chore

func register_chores() -> void:
	G.actions.register("pick_loose", _effect, _requires, Callable(), Callable(), _profile)
	G.actions.register_auto("pick_loose", _auto_pick)

## How a pet picks its target (G.actions.register_auto): the oldest thing the store has room for (a thing that does not fit stays lying, so
## a pet would pay for nothing), as the chore's args {"id"}; {} when nothing lies about or nothing fits.
func _auto_pick() -> Dictionary:
	for t in things():
		var k := str(t["k"])
		if G.needs.storage_cap(k) - G.inventory.count(k) >= 0.5: return {"id": int(t["id"])}
	return {}

func _requires(_who, args: Dictionary) -> Array:
	if kind_of(int(args.get("id", -1))) == "": return [{"key": "nothing_to_do", "text": ""}]
	return []

## A stone costs what picking stones at the forest edge costs per stone, a stick what gathering sticks costs per stick (data: stone_base).
func _profile(_who, args: Dictionary) -> Dictionary:
	if kind_of(int(args.get("id", -1))) == "stone": return {"base": G.meta.get("chores", {}).get("pick_loose", {}).get("stone_base", {})}
	return {}

func _effect(_who, args: Dictionary, _cost: Dictionary) -> Dictionary:
	var id := int(args["id"])
	var kind := kind_of(id)
	var got := G.inventory.add_item(kind, 1.0)
	if got >= 0.5:
		var arr: Array = things()
		for i in range(arr.size()):
			if int(arr[i]["id"]) == id:
				arr.remove_at(i)
				break
	G.inventory.emit_gained("loose:%d" % id, {kind: got} if got >= 0.5 else {})
	return {"gained": {kind: got} if got >= 0.5 else {}}
