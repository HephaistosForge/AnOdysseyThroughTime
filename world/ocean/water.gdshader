shader_type spatial;

uniform sampler2D noise;

const vec2 maelstrom_pos = vec2(-20, -20);

float wave(vec2 position) {
	position += texture(noise, position / 10.0).x * 2.0 - 1.0;
	vec2 wv = 1.0 - abs(sin(position));
	return pow(1.0 - pow(wv.x * wv.y, 0.65), 4.0);
}

float height(vec2 position, float time) {
	float d = wave((position + time) * 0.4) * 0.3;
	d += wave((position - time) * 0.3) * 0.3;
	d += wave((position + time) * 0.5) * 0.2;
	d += wave((position - time) * 0.6) * 0.2;
	return d;
}

void vertex() {
	vec2 pos = VERTEX.xz;
	// float k = height(pos, TIME);
	// float k = sin(TIME + pos.x * 1.2 + pos.y) * .1 + cos(TIME + pos.x * 2.2 + pos.y * 3.1) * .04;
	float k = 0.0;
	
	float maelstrom_dist = length(pos - maelstrom_pos)+0.1;
	float maelstrom_penalty = 1.0/-abs(maelstrom_dist);
	k += maelstrom_penalty * 100.0;
	
	vec2 vec_to_maelstrom = maelstrom_pos - pos;
	// vec2 wave_direction = cross(vec_to_maelstrom, );
	float angle = atan(vec_to_maelstrom.y, vec_to_maelstrom.x);
	// k += pow(sin(angle + TIME*8.0), 2) * 1000.0 / max(50, pow(maelstrom_dist, 3));
	// k += cos(angle + TIME*4.0) * 200.0 / max(10, pow(maelstrom_dist, 2));
	
	float golden_ratio = 1.61803398;
	float w = 2.0/PI * log(golden_ratio);
	float r = -pow(E, w * angle);
	k += r * 10.0;
	
	VERTEX.y = k;
	k = height(pos, 1.0);
	//NORMAL = vec3(0, 1, 0);
	NORMAL = normalize(vec3(k - height(pos + vec2(0.1, 0.0), 1.0), 0.1, k - height(pos + vec2(0.0, 0.1), 1.0)));
}

void fragment() {
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	RIM = 0.2;
	METALLIC = 0.0;
	ROUGHNESS = 0.1 * (1.0 - fresnel);
	
	ALBEDO = vec3(0.1, 0.3, 0.5) + (0.1 * fresnel); // Bright water
	// ALBEDO = vec3(0.01, 0.03, 0.05) + (0.1 * fresnel); // Dark water
}
