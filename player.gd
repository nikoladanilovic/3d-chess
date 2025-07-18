extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var camera_pivot: Node3D  # Drag the CameraPivot here

func _physics_process(delta):
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_forward"):
		input_dir.y += 1
	if Input.is_action_pressed("move_backward"):
		input_dir.y -= 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	input_dir = input_dir.normalized()

	# Use the camera's basis to move relative to where it's facing
	var cam_basis = camera_pivot.global_transform.basis
	var forward = -cam_basis.z
	var right = cam_basis.x

	var direction = (forward * input_dir.y) + (right * input_dir.x)
	direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity

	move_and_slide()
