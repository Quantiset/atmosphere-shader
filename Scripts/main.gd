extends Node3D

var screen_size := Vector2i(1280, 720)
var v_fov: float
var h_fov: float

@onready var cam := get_node("%Camera3D")

func _ready():
	#$Display.texture = $Renderer.get_texture()
	
	v_fov = deg_to_rad(cam.fov)
	h_fov = 2 * atan(tan(v_fov/2.0) / (9.0/16.0))
	
	var im := Image.create(screen_size.x, screen_size.y, false, Image.FORMAT_RGBAF)
	
	var max_x = (screen_size.x - screen_size.x/2.0) / (screen_size.x / 2.0) * tan(h_fov / 2)
	var min_x = (-screen_size.x/2.0) / (screen_size.x / 2.0) * tan(h_fov / 2)
	var max_y = (screen_size.y - screen_size.y/2.0) / (screen_size.y / 2.0) * tan(v_fov / 2)
	var min_y = (-screen_size.y/2.0) / (screen_size.y / 2.0) * tan(v_fov / 2)
	for y in range(screen_size.y):
		for x in range(screen_size.x):
			var x_var = (x - screen_size.x/2.0) / (screen_size.x / 2.0) * tan(h_fov / 2)
			var y_var = (y - screen_size.y/2.0) / (screen_size.y / 2.0) * tan(v_fov / 2)
			x_var = (x_var - min_x) / (max_x - min_x)
			y_var = (y_var - min_y) / (max_y - min_y)
			im.set_pixelv(Vector2i(x,y), Color(
				x_var, y_var, 1.0, 1.0
			))
	
	im.save_png("res://Assets/direction.png")
	var im_tex := ImageTexture.create_from_image(im)
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("direction_vector", im_tex)
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("sun_position", $Sun.global_position)
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("planet_position", $Earth.global_position)
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("planet_radius", 1.02)
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("atmosphere_radius", 3.0)
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("min_max_x_y", Vector4(min_x, max_x, min_y, max_y))
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("z_near", cam.near)
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("z_far", cam.far)
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("scattering_coeffs", Vector3(
		pow(400.0 / 700, 4),
		pow(400.0 / 530, 4),
		pow(400.0 / 440, 4)
	))

func _process(_delta):
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("camera_position", cam.global_position)
	$Yaw/Camera3D/MeshInstance3D.mesh.material.set_shader_parameter("camera_basis", cam.global_transform.basis)
	#print($Yaw/Camera3D.position)
