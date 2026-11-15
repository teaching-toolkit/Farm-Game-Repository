extends RefCounted
class_name FarmMapVisitor
## A story visitor at the farmhouse door: Granny Maud, Greenstem, the miller, Wren, Master Quill, Lark, Captain Mei. The rest of the game says
## only `sync(id)`: who is visiting now (a person id of rules/58-people.json) or "" for nobody; everything else lives here. The figure (ui/figures.gd)
## walks in from the left edge of the map to the farmhouse door in about two seconds, stands there, and walks off to the left when `sync("")`
## comes (the visit is over, see systems/people.gd); a different id replaces the one who is here: the first is gone at once. A tap on the
## figure makes the person say one of their lines (`G.people.line`, done by the figures module). Nothing is written on the map and nothing
## is saved: a game that loads has nobody visiting.
## Where and how big: the person's `scenes.door` in rules/58-people.json: figureH (their height), dx and dy (where they stand, from the house's
## feet), all shares of the map's width; without them the defaults below (the same height as the merchant, left of the door, a little in front).
const WALK_SECS := 2.0          # how long a visitor walks in or out
const FIGURE_H := 0.07          # default height, as a share of the map's width
const DX := -0.08               # default place: this far from the house's middle (shares of the map's width) … to the left, clear of the door
const DY := 0.01                # … and this far in front of its feet

var map: FarmMap                 # the map: its layers and the other parts
var G: FarmGame                  # the rules (G.people: a visitor's look and place)
var figures: FarmUiFigures       # the people (main hands it over; without it nobody is shown)
var _layer: Control              # their own layer on the board, over the standing things (a figure is always sorted among its own scene's)
var _id := ""                    # who is here (walking in or standing); "" when nobody, also while one walks off

func _init(owner_map: FarmMap) -> void:
	map = owner_map
	G = Engine.get_main_loop().root.get_node("/root/Game")

## This person is visiting now ("" = nobody): shows, moves or takes away what must change; does nothing when nothing changed.
func sync(id: String) -> void:
	if id == _id: return
	var old := _id
	_id = id
	if id == "":
		if old != "": _leave(old)                                # the visit is over: off to the left
		return
	if old != "" and figures != null: figures.take(old)      # a second visit replaces the first: the first is gone at once
	_arrive(id)

## Who is here now (id), "" when nobody (a visitor who is walking off no longer counts).
func here() -> String:
	return _id

## Where a visitor stands, in the map's farm pixels: left of the farmhouse's door, a little in front of its feet.
func stand(id: String) -> Vector2:
	var s := _spot(id)
	return _house() + Vector2(float(s.get("dx", DX)), float(s.get("dy", DY))) * map.design.x

# ------------------------------------------------------------------ coming and going

func _arrive(id: String) -> void:
	if figures == null: return
	figures.take(id)                                         # (the same person who was still walking off)
	var h := _figure_h(id)
	var to := stand(id)
	figures.put(id, _own_layer(), Vector2(-h * 0.5, to.y), h)     # just beyond the left edge, on the line they walk along
	figures.walk_to(id, to, WALK_SECS)

func _leave(id: String) -> void:
	if figures != null and id in figures.ids(_own_layer()):
		figures.walk_to(id, Vector2(-_figure_h(id), figures.feet(id).y), WALK_SECS, true)

# ------------------------------------------------------------------ the place

func _own_layer() -> Control:
	if _layer == null or not is_instance_valid(_layer):
		_layer = Control.new()
		_layer.name = "visitor_layer"
		_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_layer.size = map.design
		map.board.add_child(_layer)
		map.board.move_child(_layer, map.objects.get_index() + 1)
	return _layer

func _spot(id: String) -> Dictionary:
	return G.people.spot(id, "door")

func _figure_h(id: String) -> float:
	return map.design.x * float(_spot(id).get("figureH", FIGURE_H))

## The middle of the farmhouse's feet (the place "home": a tent first, then the cottage and the farmhouse), in farm pixels.
func _house() -> Vector2:
	return map.slots["home"].anchor if map.slots.has("home") else map.design * Vector2(0.5, 0.22)
