extends Node3D

@export var boom: Node3D
@export var camera: Camera3D
@export var zoom_speed := 2.0
@export var rotate_speed := 0.01
@export var min_zoom := 5.0
@export var max_zoom := 50.0

var rotation_x := 0.0  # vertical (pitch)
var rotation_y := 0.0  # horizontal (yaw)
var distance := 20.0   # zoom distance

var rotating := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			rotating = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = max(min_zoom, distance - zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = min(max_zoom, distance + zoom_speed)

	elif event is InputEventMouseMotion and rotating:
		rotation_y -= event.relative.x * rotate_speed
		rotation_x -= event.relative.y * rotate_speed
		rotation_x = clamp(rotation_x, -PI/2 + 0.01, PI/2 - 0.01)

func _process(delta):
	# Apply rotations
	rotation.y = rotation_y
	boom.rotation.x = rotation_x

	# Zoom
	camera.position = Vector3(0, 0, distance)	
