shader_type spatial;
render_mode unshaded;

uniform sampler2D depth_tex : hint_depth_texture;
uniform float z_near;
uniform float z_far;

uniform vec3 planet_position;
uniform float planet_radius;
uniform float atmosphere_radius;
uniform vec3 sun_position;
uniform vec3 camera_position;
uniform mat3 camera_basis;
uniform sampler2D direction_vector;
uniform vec4 min_max_x_y;
uniform float ray_distance = 100;
uniform int sample_points = 10;

vec2 ray_sphere(vec3 ray_dir) {
	vec3 to_earth = camera_position - planet_position;
	
	float a = 1.0;
	float b = 2.0 * dot(to_earth, ray_dir);
	float c = dot(to_earth, to_earth) - atmosphere_radius * atmosphere_radius;
	
	float discriminant = b*b - 4.0*a*c;
	
	if (discriminant > 0.0) {
		float s = sqrt(discriminant);
		float near = max(0.001, (-b-s) / (2.0*a));
		float far = (-b+s)/(2.0*a);
		if (far > 0.001) {
			return vec2(near, far - near);
		}
	}
	
	return vec2(99999.0, 0.0);
}

void fragment() {
	
	float d_nonlinear = texture(depth_tex, SCREEN_UV).r;
	float z_n = d_nonlinear;
	
	float ndc_depth = d_nonlinear * 2.0 - 1.0;
    float linear_depth = INV_PROJECTION_MATRIX[3][2] / (ndc_depth + INV_PROJECTION_MATRIX[2][2]);
	
	float d_linear = abs(linear_depth);
	
	float min_x = min_max_x_y.r;
	float max_x = min_max_x_y.g;
	float min_y = min_max_x_y.b;
	float max_y = min_max_x_y.a;
	
	vec3 dir = texture(direction_vector, SCREEN_UV).rgb;
	dir.x = (max_x - min_x) * dir.x + min_x;
	dir.y = (max_y - min_y) * dir.y + min_y;
	dir.z = -dir.z;
	dir.y = -dir.y;
	dir = normalize(camera_basis * dir);
	
	vec2 rs = ray_sphere(dir);
	float dist_to_atmosphere = rs.r;
	float dist_in_atmosphere = rs.g;
	
	float s = min(dist_in_atmosphere, d_linear - dist_to_atmosphere) / (2.0*atmosphere_radius);
	ALBEDO = vec3(d_nonlinear);
	
	vec3 query_pos = camera_position;
	for (int i = 0; i < sample_points; i++) {
		query_pos += dir*(float(i) * ray_distance / float(sample_points));
		
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
