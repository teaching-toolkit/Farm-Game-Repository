shader_type canvas_item;
// One look for a season over a picture (used for every picture on the farm map).
// Winter: snow caps on every top edge (where the picture's see-through area lies above it: roofs, tree tops, fence rails) and muted,
// cooler colours. Autumn: green turns golden. No new picture per building: the same cap fits any picture with a see-through background.
// Set `winter` (0..1) and `autumn` (0..1) from the game's season; `snow` (0..1) switches the caps on or off for pictures that should
// only be muted (a patch of soil has no roof).

uniform float winter : hint_range(0.0, 1.0) = 0.0;
uniform float snow : hint_range(0.0, 1.0) = 1.0;
uniform float autumn : hint_range(0.0, 1.0) = 0.0;
uniform float snow_depth = 0.05;                  // how deep the cap reaches down, as a part of the picture's height
uniform vec3 snow_color : source_color = vec3(0.94, 0.97, 1.0);

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x), mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x), f.y);
}

vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	vec4 c = COLOR;                                   // the picture's colour (already times the node's modulate)
	vec3 rgb = c.rgb;
	if (c.a < 0.01) { COLOR = c; }
	else {
		if (autumn > 0.001) {
			// greens turn golden: hue from green (about 0.25 .. 0.42) towards orange-yellow (0.11); reds and browns stay
			vec3 hsv = rgb2hsv(rgb);
			float is_green = smoothstep(0.17, 0.24, hsv.x) * (1.0 - smoothstep(0.42, 0.50, hsv.x)) * smoothstep(0.12, 0.30, hsv.y);
			hsv.x = mix(hsv.x, 0.105 + (hsv.x - 0.25) * 0.12, is_green * autumn * 0.85);
			hsv.y = mix(hsv.y, min(1.0, hsv.y * 1.2), is_green * autumn);
			hsv.z = mix(hsv.z, min(1.0, hsv.z * 1.14), is_green * autumn);
			rgb = hsv2rgb(hsv);
		}
		if (winter > 0.001) {
			float grey = dot(rgb, vec3(0.299, 0.587, 0.114));
			rgb = mix(rgb, vec3(grey), 0.38 * winter);               // muted
			rgb *= mix(vec3(1.0), vec3(0.93, 0.97, 1.05), winter);   // a little cooler
			if (snow > 0.001) {
				// snow where the picture is see-through just above: five looks upwards, each a fifth of the depth further
				float open_above = 0.0;
				for (int i = 1; i <= 5; i++) {
					vec2 uv2 = UV - vec2(0.0, float(i) * snow_depth / 5.0);
					float a2 = uv2.y < 0.0 ? 0.0 : texture(TEXTURE, uv2).a;
					open_above += 1.0 - smoothstep(0.1, 0.5, a2);
				}
				open_above /= 5.0;
				float n = vnoise(UV * vec2(38.0, 22.0));
				float cap = smoothstep(0.2, 0.55, open_above + (n - 0.5) * 0.45);
				rgb = mix(rgb, snow_color * (0.9 + 0.1 * n), cap * winter * snow);
			}
		}
		COLOR = vec4(rgb, c.a);
	}
}
