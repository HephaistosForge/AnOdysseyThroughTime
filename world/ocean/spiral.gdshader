shader_type spatial;
// render_mode cull_disabled,diffuse_burley,specular_schlick_ggx, blend_mix;
render_mode depth_draw_always;

uniform vec3 maelstrom_positions0;
uniform vec3 maelstrom_positions1;
uniform vec3 maelstrom_positions2;
uniform vec3 maelstrom_positions3;
uniform vec3 maelstrom_positions4;
uniform vec3 maelstrom_positions5;
uniform vec3 maelstrom_positions6;
uniform vec3 maelstrom_positions7;
uniform vec3 maelstrom_positions8;
uniform vec3 maelstrom_positions9;
uniform vec3 maelstrom_positions10;
uniform vec3 maelstrom_positions11;
uniform vec3 maelstrom_positions12;
uniform vec3 maelstrom_positions13;
uniform vec3 maelstrom_positions14;
uniform vec3 maelstrom_positions15;


uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;

uniform vec4 water_color : source_color;

uniform float screen_resolution = 1;

const vec2 SCREEN_PIXEL_SIZE = vec2(.001);

//const vec3 maelstrom_pos_size = vec3(.2, .2, .3);

mat2 rot_dist(float s, float d)
{
    float angularspeed = s * pow(d, 8.0);
    float cas = cos(angularspeed);
    float sas = sin(angularspeed);
    return mat2(vec2(cas, -sas), vec2(sas, cas));
}

vec3 get_hole(vec2 uv, vec3 maelstrom_pos_size) {
	vec3 ring_color = vec3(0.276, 0.147, 0.023);
    
    //vec2 uv = VERTEX.xy / 10.0 - 5.0;
    float ratio = 1.0;
    //uv.y *= ratio;
	vec2 center = vec2(maelstrom_pos_size.x, maelstrom_pos_size.y);
	float size = maelstrom_pos_size.z;
    //vec2 center = ((1.0 / SCREEN_PIXEL_SIZE).xy * .5f) / (1.0 / SCREEN_PIXEL_SIZE).xy;
    //center = iMouse.xy / iResolution.xy;
    center.y *= ratio;
    
    float _dist = distance(uv, center);
    float _s = .015;
    float _a = .005;
    vec2 uvp = uv + min(texture(iChannel2, _s * vec2(uv.x + TIME * .1, uv.y + TIME * -.3)).r,
                        texture(iChannel2, _s * vec2(uv.x + TIME * -.3, uv.y + TIME * .2)).r) * _a * pow(1. - _dist, 5.);
    //vec2 uvp = uv;
	//return vec3(uvp, 0.0);
    float dist = distance(uvp, center);
    float idist = 1.0 - dist;
    vec2 dir = normalize(uv - center);
    
    // Mask
    float m = 1.;
    m += smoothstep(.02, .0, dist) / 1.0;
	// return vec3(smoothstep(.08, .0, dist));
    m = (1.0 - dist * 5.6) * .5 * m;
	//m = smoothstep(0, 0.1, m * size);
	//return vec3(m);
	float mask = m;
    
    // Phases
    float speed = -0.05;
    float phase1 = fract(TIME * speed + .5);
    float phase2 = fract(TIME * speed);
    
    float pidist = pow(idist, 5.3);
    vec2 uv1 = (dir * pidist * .2) + phase1 * dir;
    vec2 uv2 = (dir * pidist * .2) + phase2 * dir;
    
    // Samplings
    float lerp = abs((.5 - phase1) / .5);
    float sampling1 = texture(iChannel0, uv1 * rot_dist(2.4, idist)).r * 0.05;
    float sampling2 = texture(iChannel0, uv2 * rot_dist(2.4, idist)).r * 0.05;
    
    float sampling3 = texture(iChannel0, uv1 * 2. * rot_dist(2.6, idist)).g * 0.1;
    float sampling4 = texture(iChannel0, uv2 * 2. * rot_dist(2.6, idist)).g * 0.1;
    
    float sampling5 = texture(iChannel1, uv1 * rot_dist(4.6, idist) * .4).r * 0.1;
    float sampling6 = texture(iChannel1, uv2 * rot_dist(4.6, idist) * .6).r * 0.1;
    
    float stars = (1. - smoothstep(0.22, 0.34, mix(sampling3, sampling4, lerp))) * .4;
    
    vec3 sp = mix(sampling1, sampling2, lerp) * vec3(1);
    sp *= 0.2;
   	sp += stars * vec3(0.13, 0.31, 0.46);
    sp += smoothstep(0.26, 0.14, mix(sampling5, sampling6, lerp)) * vec3(0.7) * pow(idist, 2.) * ring_color;
	
    
    vec3 finalSamp = sp;
    vec3 col = ring_color * pow(1.0 - dist, 3.);
    float ring = pow(smoothstep(.62, .08, dist * 1.5) * 3.5, 2.8) + 1.;

	//return vec3(1. * ring * mask * finalSamp * col);
    //return vec3(mask);
    return finalSamp * mask * .1 + 1.2 * ring * mask * finalSamp * col;
}

float add_maelstrom(vec2 uv, vec3 positions) {
	vec3 hole = get_hole(uv, positions);
	float sum = hole.x + hole.y + hole.z;
	return -clamp(sum, 0, 10) * 10.0;
}

float height(vec2 uv) {
	float h = sin(TIME * 1.0 + uv.x*100. + uv.y*120. * texture(iChannel1, vec2(uv.x, uv.y)).r *0.009)*1.3;
	h += sin(TIME * 0.5 + uv.x*80. + uv.y*20. 
		* texture(iChannel0, vec2(uv.x, uv.y)).r *0.6 
		* texture(iChannel2, vec2(uv.y, uv.x)).r)*1.2;
	h += add_maelstrom(uv, maelstrom_positions0);
	h += add_maelstrom(uv, maelstrom_positions1);
	h += add_maelstrom(uv, maelstrom_positions2);
	h += add_maelstrom(uv, maelstrom_positions3);
	h += add_maelstrom(uv, maelstrom_positions4);
	h += add_maelstrom(uv, maelstrom_positions5);
	h += add_maelstrom(uv, maelstrom_positions6);
	h += add_maelstrom(uv, maelstrom_positions7);
	h += add_maelstrom(uv, maelstrom_positions8);
	h += add_maelstrom(uv, maelstrom_positions9);
	h += add_maelstrom(uv, maelstrom_positions10);
	h += add_maelstrom(uv, maelstrom_positions11);
	h += add_maelstrom(uv, maelstrom_positions12);
	h += add_maelstrom(uv, maelstrom_positions13);
	h += add_maelstrom(uv, maelstrom_positions14);
	h += add_maelstrom(uv, maelstrom_positions15);
	
	return h;
}

void vertex() {
	
	float h = height(UV);
	VERTEX.y = h;
	//NORMAL = vec3(0, 1, 0);
	NORMAL = normalize(vec3(h - height(UV + vec2(0.001, 0.0)), 1, h - height(UV + vec2(0.0, 0.001))));
	//ALPHA = 1.0;
}


void fragment()
{
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	RIM = 0.2;
	METALLIC = 0.0;
	ROUGHNESS = 0.1 * (1.0 - fresnel);
	
	ALBEDO = vec3(water_color.x, water_color.y, water_color.z) + (0.05 * fresnel);
	
	//ALBEDO = vec3(0.0, 0.2, 0.4) + (0.05 * fresnel); // Bright water
    //vec3 hole = get_hole(UV);
    //ALBEDO.bgr = max(ALBEDO.bgr, hole * .1);
	ALPHA = 1.0;
}