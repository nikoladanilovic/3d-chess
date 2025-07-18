extends CharacterBody3D

@export var cell_size := 1

signal handle_capture(capture_block: Node)
@export var areaPiece : Area3D
var grid_pos: Vector3i
@export var mesh := MeshInstance3D
var original_color: Color

func _ready():
	scale_piece_to_cell()
	areaPiece.input_event.connect(_input_event)

func scale_piece_to_cell():
	# Assuming original piece is 1x1x1 units; adjust as needed
	var target_scale = Vector3.ONE * cell_size * 0.9
	scale = target_scale

func move_to_grid(pos: Vector3i):
	grid_pos = pos
	global_position = grid_to_world(grid_pos)

func grid_to_world(grid: Vector3i) -> Vector3:
	return Vector3(grid) * cell_size + Vector3.ONE * (cell_size * 0.5)

func set_color(color: Color):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA  # Enable alpha
	mat.flags_transparent = true  # Actually make it render with transparency
	mesh.material_override = mat
	original_color = color

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("handle_capture", self)
