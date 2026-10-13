extends RefCounted
class_name FarmQuality
## Quality of grown and made things (TODO Y1): three grades, 0 Lumpy · 1 Proper · 2 Fancy. A grade is decided when a thing is made, from an
## expected grade E (Proper = 1.0): floor(E) plus a coin flip on the fraction, then a small chance of one grade more or less. Selling pays
## by grade (Lumpy 60 %, Proper 100 %, Fancy 150 %). The numbers are data (data/farm/rules/47-quality.json). Raw materials have no grade.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

func data() -> Dictionary:
	return G.meta.get("quality", {})

func levels() -> Array:
	return data().get("levels", [])

func default_grade() -> int:
	return int(data().get("default", 1))

func max_grade() -> int:
	return maxi(0, levels().size() - 1)

## Does this item have a grade? (Crops, ingredients, dishes, crafts, textiles; not raw materials, animal products or seeds.)
func graded(k: String) -> bool:
	return data().get("categories", []).has(str(G.items.get(k, {}).get("category", "")))

func level_name(g: int) -> String:
	return str(levels()[clampi(g, 0, max_grade())].get("name", ""))

## ⭐ Lumpy, ⭐⭐ Proper, ⭐⭐⭐ Fancy.
func stars(g: int) -> String:
	return "⭐".repeat(int(levels()[clampi(g, 0, max_grade())].get("stars", g + 1)))

func price_factor(g: int) -> float:
	return float(levels()[clampi(g, 0, max_grade())].get("price", 1.0))

## The chances of each grade for an expected grade E: [P(Lumpy), P(Proper), P(Fancy)].
func distribution(e: float) -> Array:
	var top := max_grade()
	e = clampf(e, 0.0, float(top))
	var base := []
	base.resize(top + 1)
	base.fill(0.0)
	var f := int(floorf(e))
	var r := e - float(f)
	base[f] = 1.0 - r
	if f + 1 <= top: base[f + 1] = r
	var up := float(data().get("chance", {}).get("up", 0.07))
	var down := float(data().get("chance", {}).get("down", 0.07))
	var out := []
	out.resize(top + 1)
	out.fill(0.0)
	for g in range(top + 1):
		var p := float(base[g])
		out[g] += p * (1.0 - up - down)
		out[mini(g + 1, top)] += p * up
		out[maxi(g - 1, 0)] += p * down
	return out

## Decides a grade for an expected grade E (one random number).
func roll(e: float) -> int:
	var d := distribution(e)
	var x := G.rng.randf()
	var acc := 0.0
	for g in range(d.size()):
		acc += float(d[g])
		if x < acc: return g
	return d.size() - 1

## "⭐⭐ Proper", with "· maybe ⭐⭐⭐" when another grade is a real chance (a quarter or more).
func expect_text(e: float) -> String:
	var d := distribution(e)
	var best := 0
	for g in range(d.size()):
		if float(d[g]) > float(d[best]): best = g
	var t := "%s %s" % [stars(best), tr(level_name(best))]
	for g in range(d.size()):
		if g != best and float(d[g]) >= 0.25: t += tr(" · maybe %s") % stars(g)
	return t

# ------------------------------------------------------------------ what goes into the expected grade

## Crops: the patch's soil, weeds and stones, how far its clearing is done, and the field's upgrades.
func crop_expect(p: Dictionary) -> float:
	var c: Dictionary = data().get("crop", {})
	var e := float(default_grade())
	var soil := float(p.get("soil", 1.0))
	if soil > 1.01: e += float(c.get("restedSoil", 0.0))
	elif soil < 0.99: e += float(c.get("tiredSoil", 0.0))
	var over := maxf(0.0, float(p.get("weeds", 0.0)) - float(c.get("weedsFree", 2)))
	e += maxf(float(c.get("weedsMax", -0.4)), over * float(c.get("perWeed", -0.1)))
	e += maxf(float(c.get("stonesMax", -0.3)), float(p.get("stones", 0.0)) * float(c.get("perStone", -0.05)))
	e -= maxf(0.0, 1.0 - float(p.get("quality", 1.0))) * float(c.get("unfinishedClearing", 1.5))
	for id in c.get("bonusNodes", {}):
		if G.nodes.has(id) and G.satisfied(id) and not G.superseded(id): e += float(c["bonusNodes"][id])
	return e + G.skills.grade_bonus("field")

## Recipes: the station in use (the newest of its chain), what the inputs it will use are worth, and later the skill.
func recipe_expect(rid: String) -> float:
	var r: Dictionary = G.recipes[rid]
	var e := float(default_grade())
	var root: String = G.crafting.chain_root(r["station"])
	e += float(data().get("stationBonus", {}).get(G.crafting.active_of(root), 0.0))
	e += G.skills.grade_bonus(G.skills.family_of_station(r["station"]))
	e += input_bonus(r)
	return e

## What the grades of the inputs a recipe would use now (lowest grade first) add to E: the weight × the average distance from Proper.
func input_bonus(r: Dictionary) -> float:
	var n := 0.0
	var sum := 0.0
	for k in r.get("inputs", {}):
		var need := float(r["inputs"][k]) * G.m("in:" + r["station"] + ":" + k)
		var v: Vector2 = G.inventory.peek_grades(k, need)
		n += v.x
		sum += v.y
	if n <= 0.0: return 0.0
	return (sum / n - float(default_grade())) * float(data().get("ingredients", {}).get("weight", 0.6))

## The grade a made batch gets right now (decided once, when the batch starts).
func roll_recipe(rid: String, input_avg: float) -> int:
	var r: Dictionary = G.recipes[rid]
	var e := float(default_grade())
	var root: String = G.crafting.chain_root(r["station"])
	e += float(data().get("stationBonus", {}).get(G.crafting.active_of(root), 0.0))
	e += G.skills.grade_bonus(G.skills.family_of_station(r["station"]))
	if input_avg >= 0.0: e += (input_avg - float(default_grade())) * float(data().get("ingredients", {}).get("weight", 0.6))
	return roll(e)
