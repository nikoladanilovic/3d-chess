extends Camera3D

# Sensitivity for movement
@export var pan_speed: float = 0.1

var is_panning := false
var last_mouse_pos := Vector2.ZERO

func _unhandled_input(event):
	# Start panning
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_panning = event.pressed
			if is_panning:
				last_mouse_pos = event.position
	# Pan the camera
	if is_panning and event is InputEventMouseMotion:
		var motion_event := event as InputEventMouseMotion
		var delta := motion_event.relative
		# Move in camera's local X and Y (right and up)
		var right := -transform.basis.x * delta.x * pan_speed
		var up := transform.basis.y * delta.y * pan_speed
		translate(right + up)
