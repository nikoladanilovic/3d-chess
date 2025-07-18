extends Node3D

@onready var piece_scene := preload("res://Piece.tscn")
@onready var rook_scene := preload("res://Rook3D.tscn")
@onready var bishop_scene := preload("res://bishop_3d.tscn")
@onready var capture_scene := preload("res://capture_character.tscn")
@onready var knight_scene := preload("res://knight_3d.tscn")
@onready var queen_scene := preload("res://queen_3d.tscn")
@onready var king_scene := preload("res://king_3d.tscn")
@onready var pawn_scene := preload("res://black_pawn_3d.tscn")
@export var player1_root : Node3D
@export var player2_root : Node3D
@export var cell_size := 1.0
var selected_piece: Node = null

var player1_pieces = []
var player2_pieces = []
var active_player := 1  # 1 or 2



#var grid = []
var grid_state := {}  # Dictionary<Vector3i, ChessPiece>

"""func init_grid():
	grid.clear()
	for x in range(8):
		var layer_y = []
		for y in range(8):
			var layer_z = []
			for z in range(8):
				layer_z.append(null)
			layer_y.append(layer_z)
		grid.append(layer_y)"""

func _ready():
	#Black player pieces
	spawn_player_pieces(rook_scene, 1, player1_root, Vector3i(0, 0, 0), Color.BLACK)
	spawn_player_pieces(rook_scene, 1, player1_root, Vector3i(7, 0, 0), Color.BLACK)
	spawn_player_pieces(bishop_scene, 1, player1_root, Vector3i(2, 0, 0), Color.BLACK)
	spawn_player_pieces(bishop_scene, 1, player1_root, Vector3i(5, 0, 0), Color.BLACK)
	spawn_player_pieces(knight_scene, 1, player1_root, Vector3i(1, 0, 0), Color.BLACK)
	spawn_player_pieces(knight_scene, 1, player1_root, Vector3i(6, 0, 0), Color.BLACK)
	spawn_player_pieces(queen_scene, 1, player1_root, Vector3i(4, 0, 0), Color.BLACK)
	spawn_player_pieces(king_scene, 1, player1_root, Vector3i(3, 0, 0), Color.BLACK)
	
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(1, 1, 0), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(2, 1, 0), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(3, 1, 0), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(4, 1, 0), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(5, 1, 0), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(6, 1, 0), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(7, 1, 0), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(0, 1, 0), Color.BLACK)
	
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(1, 1, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(2, 1, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(3, 1, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(4, 1, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(5, 1, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(6, 1, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(7, 1, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(0, 1, 1), Color.BLACK)
	
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(1, 0, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(2, 0, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(3, 0, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(4, 0, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(5, 0, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(6, 0, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(7, 0, 1), Color.BLACK)
	spawn_player_pieces(pawn_scene, 1, player1_root, Vector3i(0, 0, 1), Color.BLACK)
	
	#Red player pieces
	spawn_player_pieces(rook_scene, 2, player2_root, Vector3i(0, 7, 7), Color.RED)
	spawn_player_pieces(rook_scene, 2, player2_root, Vector3i(7, 7, 7), Color.RED)
	spawn_player_pieces(bishop_scene, 2, player2_root, Vector3i(2, 7, 7), Color.RED)
	spawn_player_pieces(bishop_scene, 2, player2_root, Vector3i(5, 7, 7), Color.RED)
	spawn_player_pieces(knight_scene, 2, player2_root, Vector3i(1, 7, 7), Color.RED)
	spawn_player_pieces(knight_scene, 2, player2_root, Vector3i(6, 7, 7), Color.RED)
	spawn_player_pieces(queen_scene, 2, player2_root, Vector3i(4, 7, 7), Color.RED)
	spawn_player_pieces(king_scene, 2, player2_root, Vector3i(3, 7, 7), Color.RED)
	
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(1, 6, 7), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(2, 6, 7), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(3, 6, 7), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(4, 6, 7), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(5, 6, 7), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(6, 6, 7), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(7, 6, 7), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(0, 6, 7), Color.RED)
	
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(1, 6, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(2, 6, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(3, 6, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(4, 6, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(5, 6, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(6, 6, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(7, 6, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(0, 6, 6), Color.RED)
	
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(1, 7, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(2, 7, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(3, 7, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(4, 7, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(5, 7, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(6, 7, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(7, 7, 6), Color.RED)
	spawn_player_pieces(pawn_scene, 2, player2_root, Vector3i(0, 7, 6), Color.RED)
	
func register_piece(piece: Piece):
	grid_state[piece.grid_pos] = piece

func spawn_player_pieces(piece_type_scene: Resource, player_id: int, parent: Node3D, start_pos: Vector3i, color: Color):
	var piece = piece_type_scene.instantiate()
	piece.resource_link = piece_type_scene
	piece.cell_size = cell_size
	piece.set_color(color)
	piece.owner_id = player_id
	piece.move_to_grid(start_pos)
	piece.piece_selected.connect(_on_piece_selected)
	#grid[start_pos.x][start_pos.y][start_pos.z] = piece
	register_piece(piece)
	parent.add_child(piece)
	if player_id == 1:
		player1_pieces.append(piece)
	else:
		player2_pieces.append(piece)

func end_turn():
	active_player = 2 if (active_player == 1) else 1
	
func can_control(piece):
	return piece.owner_id == active_player
	
func _on_piece_selected(piece):
	print("Selected piece at:", piece.owner_id)
	print("Active player:", active_player)
	
	if piece.owner_id != active_player:
		return  # Only allow current player to select
	
		# Deselect the previously selected piece
	if selected_piece == piece:
		piece.clear_highlight()
		
		despawn_new_player_piece_positions(piece)
		selected_piece = null
		return
	
	if selected_piece != piece and selected_piece != null:
		
		selected_piece.clear_highlight()
		
		despawn_new_player_piece_positions(piece)
		if active_player == 1:
			spawn_possible_new_positions(piece, player1_root, 1)
		if active_player == 2:
			spawn_possible_new_positions(piece, player2_root, 2)
		
		piece.highlight()
		
		selected_piece = piece
		return
	
	if selected_piece == null:
		selected_piece = piece
		selected_piece.highlight()
		if active_player == 1:
			spawn_possible_new_positions(piece, player1_root, 1)
		if active_player == 2:
			spawn_possible_new_positions(piece, player2_root, 2)
	

func change_position(piece):
	if piece.owner_id != active_player:
		return  # Only allow current player to select
	selected_piece.clear_highlight()
	if(piece.original_color == Color.BLUE):
		if active_player == 1:
			piece.set_color(Color.BLACK)
			piece.cell_size = cell_size
			piece.owner_id = 1
			piece.move_to_grid(piece.grid_pos)
			piece.piece_selected.disconnect(change_position)
			player1_root.add_child(piece)
			player1_pieces.append(piece)
		elif active_player == 2:
			piece.set_color(Color.RED)
			piece.cell_size = cell_size
			piece.owner_id = 2
			piece.move_to_grid(piece.grid_pos)
			piece.piece_selected.disconnect(change_position)
			player2_root.add_child(piece)
			player2_pieces.append(piece)
	
	#rest of the logic
	despawn_new_player_piece_positions(piece)
	player1_root.remove_child(selected_piece)
	grid_state[selected_piece.grid_pos] = null
	
	selected_piece = null
		
	end_turn()  # Only allow current player to select
	

func spawn_possible_new_positions(original_piece, parent, player_id):
	var valid_moves = original_piece.get_valid_moves(grid_state)
	for i in valid_moves:
		var piece = original_piece.resource_link.instantiate()
		piece.resource_link = original_piece.resource_link
		
		piece.cell_size = cell_size
		piece.isHelperPiece = true
		piece.set_color(Color.BLUE)
		if(player_id == 1):
			piece.owner_id = 1
			piece.move_to_grid(i)
		if(player_id == 2):
			piece.owner_id = 2
			piece.move_to_grid(i)
		piece.piece_selected.connect(change_position)
		parent.add_child(piece)
		#parent.remove_child(piece)
	
		
func despawn_new_player_piece_positions(orig_piece):
	if active_player == 1:
		for temp_piece in player1_root.get_children():
			if temp_piece.original_color == Color.BLUE:
				player1_root.remove_child(temp_piece)
				grid_state[temp_piece.grid_pos] = null
		
		if selected_piece != orig_piece and orig_piece.isHelperPiece == true:
			player1_root.remove_child(selected_piece)
			spawn_new_player_piece_positions(1, player1_root, Color.BLACK)
			grid_state[selected_piece.grid_pos] = null
			orig_piece.isHelperPiece = false
		
		
	else:
		for temp_piece in player2_root.get_children():
			if temp_piece.original_color == Color.BLUE:
				player2_root.remove_child(temp_piece)
				grid_state[temp_piece.grid_pos] = null
		
		if selected_piece != orig_piece and orig_piece.isHelperPiece == true:
			player2_root.remove_child(selected_piece)
			spawn_new_player_piece_positions(2, player2_root, Color.RED)
			grid_state[selected_piece.grid_pos] = null
			orig_piece.isHelperPiece = false
	
	# Remove the green capture indicator
	if selected_piece.capture_character.size() != 0:
		for capturee in selected_piece.capture_character:
			get_node("/root/GridRoot").remove_child(capturee)
			capturee.queue_free()
			

func spawn_new_player_piece_positions(player_id, parent, color):
	for temp_piece in parent.get_children():
		temp_piece.cell_size = cell_size
		temp_piece.set_color(color)
		temp_piece.move_to_grid(temp_piece.grid_pos)
		grid_state[temp_piece.grid_pos] = temp_piece
		temp_piece.piece_selected.connect(_on_piece_selected)
		parent.add_child(temp_piece)
