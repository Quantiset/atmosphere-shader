shader_type spatial;

uniform sampler2D mountainmap;
uniform sampler2D normalmap;

void vertex() {
	VERTEX *= (0.1*texture(mountainmap, UV).r + 1.);
}

void fragment() {
	NORMAL_MAP = texture(normalmap, UV).rgb*0.2;
	ALBEDO = vec3(0.2, 0.4, 0.46);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
