shader_type spatial;

uniform sampler2D mountainmap;
uniform sampler2D normalmap;

void vertex() {
	float tmp;
	VERTEX *= (0.25*texture(mountainmap, UV).r + 1.);
}

void fragment() {
	float h = texture(mountainmap, UV).r;
	if (h > 0.65) {
		ALBEDO = vec3(0.207, 0.271, 0.612);
	} else {
		ALBEDO = vec3(0.207, 0.271, 0.512);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
