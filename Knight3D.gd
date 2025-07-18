extends Piece

var knight_moves_3d := [
	Vector3i( 2,  1,  0), Vector3i( 2, -1,  0), Vector3i(-2,  1,  0), Vector3i(-2, -1,  0),
	Vector3i( 1,  2,  0), Vector3i( 1, -2,  0), Vector3i(-1,  2,  0), Vector3i(-1, -2,  0),

	Vector3i( 2,  0,  1), Vector3i( 2,  0, -1), Vector3i(-2,  0,  1), Vector3i(-2,  0, -1),
	Vector3i( 1,  0,  2), Vector3i( 1,  0, -2), Vector3i(-1,  0,  2), Vector3i(-1,  0, -2),

	Vector3i( 0,  2,  1), Vector3i( 0,  2, -1), Vector3i( 0, -2,  1), Vector3i( 0, -2, -1),
	Vector3i( 0,  1,  2), Vector3i( 0,  1, -2), Vector3i( 0, -1,  2), Vector3i( 0, -1, -2),
]

func get_valid_moves(grid_state: Dictionary) -> Array[Vector3i]:
	var valid_moves: Array[Vector3i] = []
	for move in knight_moves_3d:
		var new_pos = grid_pos + move
		if is_within_bounds(new_pos):  # Ensure new_pos is inside the 8x8x8 cube
			if is_empty_or_enemy(grid_state, new_pos):  # Your logic here
				valid_moves.append(new_pos)
	return valid_moves


func is_within_bounds(pos: Vector3) -> bool:
	return pos.x >= 0 and pos.x < 8 and pos.y >= 0 and pos.y < 8 and pos.z >= 0 and pos.z < 8
	
func is_empty_or_enemy(grid_state: Dictionary ,pos: Vector3i) -> bool:
	if not grid_state.has(pos):
		return true  # Tile is empty (no piece stored at this position)
	var piece = grid_state[pos]
	if piece == null:
		return true  # Tile is empty
	if piece.owner_id != owner_id:
		create_capture_indicator(pos)
		return true  # Enemy piece
	return false  # Same team piece
