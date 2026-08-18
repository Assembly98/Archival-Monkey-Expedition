shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_toon, ambient_light_disabled;

uniform float eyeUVX;
uniform float mouthUVX;
uniform float mouthUVY;
uniform vec2 pupilUV1;
uniform vec2 pupilUV2;
uniform vec2 eyebrowsUV;
uniform float eyeSize = 1;
uniform sampler2D albedo_texture : source_color, filter_linear;
uniform sampler2D eyeTexture : source_color, filter_linear, repeat_disable;
uniform sampler2D mouthTexture : source_color, filter_linear, repeat_disable;
uniform sampler2D pupilTexture : source_color, filter_linear, repeat_disable;
uniform sampler2D eyebrows : source_color, filter_linear, repeat_disable;
varying vec2 UV3;
varying vec2 UV4;
varying vec2 UV5;
varying vec2 UV6;
varying vec2 UV7;
uniform sampler2D color_gradient;

void vertex() {
	// Called for every vertex the material is visible on.
	UV3 = CUSTOM0.xy;
	UV4 = CUSTOM0.zw;
	UV5 = CUSTOM1.xy;
	UV7 = CUSTOM1.zw;
	
	UV3 = UV3 * vec2(eyeSize);
	UV5 = UV5 * vec2(eyeSize);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 head = texture(albedo_texture, UV);
	vec4 eyes = texture(eyeTexture, vec2(UV4.x + eyeUVX, UV4.y));
	vec4 mouths = texture(mouthTexture, vec2(UV2.x + mouthUVX, UV2.y + mouthUVY));
	vec4 pupil1;
	vec4 eyeBrows = texture(eyebrows, vec2(UV7.x + eyebrowsUV.x, UV7.y + eyebrowsUV.y));
	vec4 pupil2;
	
	if (eyeUVX <= -0.480) {
		pupil1 = texture(pupilTexture, vec2(UV3.x + -3.0, UV3.y + pupilUV1.y));
		pupil2 = texture(pupilTexture, vec2(UV5.x + -1.0, UV5.y + pupilUV2.y));
	}
	else{
		pupil1 = texture(pupilTexture, vec2(UV3.x + pupilUV1.x, UV3.y + pupilUV1.y));
		pupil2 = texture(pupilTexture, vec2(UV5.x + pupilUV2.x, UV5.y + pupilUV2.y));
	}
		
	
	ALBEDO = mix(mix(mix(mix(mix(head.rgb, eyes.rgb, eyes.a), mouths.rgb, mouths.a), pupil1.rgb, pupil1.a), pupil2.rgb, pupil2.a),eyeBrows.rgb, eyeBrows.a);
	
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
	float dotProduct = clamp(dot(NORMAL, LIGHT), -0.9, 0.9);
	float sample = clamp((dotProduct + 1.0) * ATTENUATION / 2.1, 0.05, 0.95);
	vec4 shaded = texture(color_gradient, vec2(sample, 0.0));
	
	DIFFUSE_LIGHT += clamp((shaded.rgb * LIGHT_COLOR), 0.0, 1.0);
}
