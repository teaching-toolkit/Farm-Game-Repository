"""Writes farm_map.tscn from the table below. You can also just open farm_map.tscn in Godot and drag the places."""
import sys
C = [124, 322, 520]          # three columns in the middle (design width 834)
W, H = 190, 140              # size of one place
ROWS = {"H1": 8, "H2": 154, "A1": 846, "A2": 996, "A3": 1146, "A4": 1296}
PLACES = [
    # spot_id, x, y, w, h, art chain (first to last upgrade)
    ("living", C[0], ROWS["H1"], W, H, ["tent", "cottage", "cottage_loft", "farmhouse", "farmhouse_sunroom"]),
    ("library", C[1], ROWS["H1"], W, H, ["library_box", "library_shelf", "library_bookcase", "library_room"]),
    ("kitchen", C[2], ROWS["H1"], W, H, ["campfire", "stove_1", "stove_2", "stove_3"]),
    ("well", C[0], ROWS["H2"], W, H, ["well_1", "well_2", "well_3", "well_4", "well_5"]),
    ("storage", C[1], ROWS["H2"], W, H, ["basket", "shed", "warehouse"]),
    ("workshop", C[2], ROWS["H2"], W, H, ["workbench", "workshop_1", "workshop_2", "workshop_3"]),
    ("coop", C[0], ROWS["A1"], W, H, ["coop_1", "coop_2"]),
    ("pets", C[1], ROWS["A1"], W, H, []),
    ("cows", C[2], ROWS["A1"], W, H, []),
    ("sheep", C[0], ROWS["A2"], W, H, ["sheep_pen"]),
    ("bees", C[1], ROWS["A2"], W, H, ["cap_bees_1", "cap_bees_2", "cap_bees_3"]),
    ("barn", C[2], ROWS["A2"], W, H, ["barn_1", "barn_2", "barn_3"]),
    ("windmill", C[0], ROWS["A3"], W, H, ["windmill_1", "windmill_2"]),
    ("compost", C[1], ROWS["A3"], W, H, ["compost_bin", "compost_bin_2"]),
    ("pond", C[2], ROWS["A3"], W, H, []),
    ("orchard", C[0], ROWS["A4"], W, H, ["orchard", "orchard_2"]),
    ("greenhouse", C[1], ROWS["A4"], W, H, ["greenhouse", "greenhouse_2"]),
    # forest edge (left strip) and village road (right strip)
    ("forest", 2, 330, 114, 330, []),
    ("lumber", 2, 990, 114, 200, ["woodlot", "lumbermill", "lumbermill_2"]),
    ("market", 718, 8, 114, 190, ["market_stall"]),
    ("bookcart", 718, 214, 114, 160, []),
    ("board", 718, 390, 114, 160, []),
    ("broker", 718, 990, 114, 170, []),
]
FIELD = (130, 352, 574, 484)
FIELDBAR = (124, 300, 586, 46)

out = ['[gd_scene load_steps=4 format=3]', '',
       '[ext_resource type="Script" path="res://scripts/farm_map.gd" id="1_map"]',
       '[ext_resource type="Script" path="res://scripts/slot.gd" id="2_slot"]',
       '[ext_resource type="Script" path="res://scripts/field_view.gd" id="3_field"]', '',
       '[node name="FarmMap" type="Control"]', 'layout_mode = 3', 'anchors_preset = 0',
       'offset_right = 834.0', 'offset_bottom = 1450.0', 'mouse_filter = 1', 'script = ExtResource("1_map")', '',
       '[node name="Board" type="Control" parent="."]', 'layout_mode = 0', 'anchors_preset = 0',
       'offset_right = 834.0', 'offset_bottom = 1450.0', 'mouse_filter = 1', '']
def rect(x, y, w, h):
    return ['layout_mode = 0', f'offset_left = {x:.1f}', f'offset_top = {y:.1f}', f'offset_right = {x + w:.1f}', f'offset_bottom = {y + h:.1f}']
for sid, x, y, w, h, chain in PLACES:
    out += [f'[node name="{sid}" type="Control" parent="Board"]'] + rect(x, y, w, h) + ['mouse_filter = 1', 'script = ExtResource("2_slot")', f'spot_id = "{sid}"']
    if chain:
        out.append('art_chain = PackedStringArray(' + ', '.join(f'"{c}"' for c in chain) + ')')
    out.append('')
out += ['[node name="Field" type="Control" parent="Board"]'] + rect(*FIELD) + ['mouse_filter = 1', 'script = ExtResource("3_field")', '']
out += ['[node name="FieldBar" type="HBoxContainer" parent="Board"]'] + rect(*FIELDBAR) + ['theme_override_constants/separation = 8', '']
open(sys.argv[1] if len(sys.argv) > 1 else 'farm_map.tscn', 'w').write('\n'.join(out))
print('ok', len(PLACES), 'places')
