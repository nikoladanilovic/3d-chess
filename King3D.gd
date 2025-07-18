extends Piece


func get_valid_moves(grid_state: Dictionary) -> Array[Vector3i]:
	var directions : Array[Vector3i] = []
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			for dz in range(-1, 2):
				if dx == 0 and dy == 0 and dz == 0:
					continue  # Skip current position
				directions.append(Vector3i(dx, dy, dz))
	
	var valid_moves : Array[Vector3i] = []
	for dir in directions:
		var new_pos := grid_pos + dir
		if is_within_bounds(new_pos):
			if not grid_state.has(new_pos) or is_enemy_at(new_pos, grid_state) or grid_state.get(new_pos) == null:
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
