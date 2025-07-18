extends CharacterBody3D

class_name Piece

@onready var capture_scene := preload("res://capture_character.tscn")
@export var cell_size := 1
var grid_pos: Vector3i
@export var owner_id := 1  # 1 or 2
@export var mesh := MeshInstance3D
var original_color: Color
@export var areaPiece : Area3D
var isHelperPiece := false
var resource_link: Resource
var capture_character : Array[Node]

signal piece_selected(piece: Node)

func _ready():
	scale_piece_to_cell()
	areaPiece.input_event.connect(_on_area_input)

func scale_piece_to_cell():
	# Assuming original piece is 1x1x1 units; adjust as needed
	var target_scale = Vector3.ONE * cell_size * 0.3
	scale = target_scale

func move_to_grid(pos: Vector3i):
	grid_pos = pos
	global_position = grid_to_world(grid_pos)

func grid_to_world(grid: Vector3i) -> Vector3:
	return Vector3(grid) * cell_size + Vector3.ONE * (cell_size * 0.5)

func set_color(color: Color):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.material_override = mat
	original_color = color

func _on_area_input(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("piece_selected", self)
		print("Piece clicked")
		
func highlight():
	mesh.material_override.albedo_color = Color.YELLOW
	
func clear_highlight():
	mesh.material_override.albedo_color = original_color

func get_valid_moves(grid_state: Dictionary) -> Array[Vector3i]:
	# To be overridden by specific piece types
	return []
	
func create_capture_indicator(pos):
	var capture = capture_scene.instantiate()
	var green = Color.GREEN
	green.a = 0.7
	capture.cell_size = 1
	capture.set_color(green)
	capture.grid_pos = pos
	capture.move_to_grid(pos)
	capture.handle_capture.connect(_on_capture)
	capture_character.append(capture)
	get_node("/root/GridRoot").add_child(capture)


func _on_capture(capture_block):
	var game_manager = get_node("/root/GridRoot/GameManager")
	
	var captured_piece = game_manager.grid_state[capture_block.grid_pos]

	for temp_piece in game_manager.player1_root.get_children():
			if temp_piece.original_color == Color.BLUE:
				game_manager.player1_root.remove_child(temp_piece)
				game_manager.grid_state[temp_piece.grid_pos] = null
	
	for temp_piece in game_manager.player2_root.get_children():
			if temp_piece.original_color == Color.BLUE:
				game_manager.player2_root.remove_child(temp_piece)
				game_manager.grid_state[temp_piece.grid_pos] = null

	# Remove the captured enemy piece from the scene
	if game_manager.active_player == 1:
		game_manager.player2_root.remove_child(captured_piece)
	elif game_manager.active_player == 2:
		game_manager.player1_root.remove_child(captured_piece)
	game_manager.grid_state[capture_block.grid_pos] = game_manager.selected_piece
	
	
	# Remove the green capture indicator
	get_node("/root/GridRoot").remove_child(capture_block)
	capture_block.queue_free()
	
	var selected_piece = game_manager.selected_piece
	# Delete rest of the capture boxes
	if selected_piece.capture_character.size() != 0:
		for capturee in selected_piece.capture_character:
			get_node("/root/GridRoot").remove_child(capturee)
			capturee.queue_free()
		selected_piece.capture_character.clear()

	# Move the selected piece to the captured piece's position
	
	game_manager.grid_state[game_manager.selected_piece.grid_pos] = null
	selected_piece.move_to_grid(capture_block.grid_pos)
		
	selected_piece.clear_highlight()
	game_manager.end_turn()
