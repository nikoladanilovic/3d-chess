extends Piece


func _ready() -> void:
	super._ready()
	self.piece_type = "king"

func get_valid_moves(grid_state: Dictionary) -> Array[Vector3i]:
	var game_manager = get_node("/root/GridRoot/GameManager")
	
	var directions : Array[Vector3i] = []
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			for dz in range(-1, 2):
				if dx == 0 and dy == 0 and dz == 0:
					continue  # Skip current position
				directions.append(Vector3i(dx, dy, dz))
	var enemy_id = 1 if game_manager.active_player == 2 else 2
	var valid_moves : Array[Vector3i] = []
	for dir in directions:
		var new_pos := grid_pos + dir
		if is_within_bounds(new_pos):
			if not grid_state.has(new_pos) or is_enemy_at(new_pos, grid_state) or grid_state.get(new_pos) == null:
				if not game_manager.would_be_in_check(grid_state, grid_pos, new_pos, owner_id):
					if not game_manager.is_position_attacked_by(new_pos, enemy_id, grid_state):
						valid_moves.append(new_pos)  # Can't move into danger
					
	return valid_moves
	

func get_valid_moves_without_capture(grid_state: Dictionary, ignore_king_safety := false) -> Array[Vector3i]:
	var game_manager = get_node("/root/GridRoot/GameManager")
	var directions : Array[Vector3i] = []
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			for dz in range(-1, 2):
				if dx == 0 and dy == 0 and dz == 0:
					continue  # Skip current position
				directions.append(Vector3i(dx, dy, dz))
	
	var enemy_id = 1 if game_manager.active_player == 2 else 2
	var valid_moves : Array[Vector3i] = []
	for dir in directions:
		var new_pos := grid_pos + dir
		if is_within_bounds(new_pos):
			if not grid_state.has(new_pos) or is_enemy_at_without_capture(new_pos, grid_state) or grid_state.get(new_pos) == null:
				if not ignore_king_safety and not game_manager.is_position_attacked_by(new_pos, enemy_id, grid_state):  # 1 - owner_id = enemy
					valid_moves.append(new_pos)
				
	
	return valid_moves

# Check if the new position is within the 8x8x8 cube bounds
func is_within_bounds(pos: Vector3i) -> bool:
	return pos.x >= 0 and pos.x < 8 and pos.y >= 0 and pos.y < 8 and pos.z >= 0 and pos.z < 8

# Placeholder to decide if a piece at new_pos is an enemy
func is_enemy_at(pos: Vector3i, grid_state: Dictionary) -> bool:
	var piece = grid_state.get(pos)
	if piece == null:
		return false
	if piece.owner_id != owner_id:
		create_capture_indicator(pos)
	
	# Replace this with your own logic for checking team alignment
	return piece.owner_id != owner_id


func is_enemy_at_without_capture(pos: Vector3i, grid_state: Dictionary) -> bool:
	var piece = grid_state.get(pos)
	if piece == null:
		return false
	
	# Replace this with your own logic for checking team alignment
	return piece.owner_id != owner_id
