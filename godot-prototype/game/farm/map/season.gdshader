// The seasons on every picture of the map (N7, phase 3): one shader instead of new pictures.
//   winter: snow caps on every top edge (roofs, trees, fences, stones) and muted, cooler colours
//   autumn: greens turn golden
// Set by farm_map.gd (set_season) on the map's pictures; animals, the farmer and effects keep their colours.
shader_type canvas_item;

uniform float winter : hint_range(0.0, 1.0) = 0.0;
uniform float autumn : hint_range(0.0, 1.0) = 0.0;
uniform float snow_depth = 0.05;      // how deep the snow reaches down from a top edge (share of the picture's height)
uniform vec3 snow_colour : source_color = vec3(0.97, 0.98, 1.0);
uniform float ground = 0.0;            // 1 = the ground itself (grass, road, earth): in winter it is snowed over

void fragment() {
	vec4 c = texture(TEXTURE, UV) * COLOR;
	vec3 col = c.rgb;
	// autumn: green-dominant pixels drift towards gold
	float green = clamp((col.g - max(col.r, col.b)) * 4.0, 0.0, 1.0);
	vec3 gold = vec3(col.g * 1.15 + 0.1, col.g * 0.8, col.b * 0.4);
	col = mix(col, gold, green * autumn);
	// winter: muted and a little cooler
	float lum = dot(col, vec3(0.299, 0.587, 0.114));
	col = mix(col, vec3(lum * 0.95, lum * 0.98, lum * 1.06), winter * 0.45);
	// winter: the ground lies under a thin snow (darker bits still show through)
	col = mix(col, snow_colour * (0.85 + 0.15 * lum), ground * winter * 0.6);
	// winter: snow where an opaque pixel has empty space a little above it (a top edge)
	if (winter > 0.0 && c.a > 0.5) {
		float open_above = 0.0;
		for (int i = 1; i <= 4; i++) {
			float dy = snow_depth * float(i) / 4.0;
			open_above = max(open_above, 1.0 - texture(TEXTURE, UV - vec2(0.0, dy)).a);
		}
		// thicker on flat tops: compare with the pixels beside the one above
		float side = texture(TEXTURE, UV - vec2(TEXTURE_PIXEL_SIZE.x * 3.0, snow_depth)).a + texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x * 3.0, -snow_depth)).a;
		float cap = step(0.5, open_above) * (side < 1.0 ? 1.0 : 0.6);
		col = mix(col, snow_colour, cap * winter * (1.0 - ground));
	}
	COLOR = vec4(col, c.a);
}
