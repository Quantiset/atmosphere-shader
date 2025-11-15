extends Camera3D

@export var move_speed := 5.0
@export var fast_speed := 20.0
@export var mouse_sensitivity := 0.004

var rotating := false

func _unhandled_input(event):
	# Toggle looking around when RMB is held
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		rotating = event.pressed
		if rotating:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Look around while holding RMB
	if rotating and event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clamp(rotation.x, deg_to_rad(-89), deg_to_rad(89))


func _process(delta):
	var speed = move_speed
	if Input.is_key_pressed(KEY_SHIFT):
		speed = fast_speed

	var direction = Vector3.ZERO

	# WASD movement
	if Input.is_key_pressed(KEY_W):
		direction -= transform.basis.z
	if Input.is_key_pressed(KEY_S):
		direction += transform.basis.z
	if Input.is_key_pressed(KEY_A):
		direction -= transform.basis.x
	if Input.is_key_pressed(KEY_D):
		direction += transform.basis.x

	# Move
	if direction != Vector3.ZERO:
		translate(direction.normalized() * speed * delta)
