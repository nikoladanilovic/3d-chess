extends Piece



func get_valid_moves(grid_state: Dictionary) -> Array[Vector3i]:
	var moves: Array[Vector3i] = []
	var directions := [
		Vector3i(1, 0, 0), Vector3i(-1, 0, 0),
		Vector3i(0, 1, 0), Vector3i(0, -1, 0),
		Vector3i(0, 0, 1), Vector3i(0, 0, -1),
	]

	for dir in directions:
		for step in range(1, 8):
			var pos = grid_pos + dir * step
			if not is_within_bounds(pos):
				break
			if grid_state.has(pos) and not grid_state[pos] == null:
				if grid_state[pos].owner_id != owner_id:
					create_capture_indicator(pos)
					moves.append(pos)  # Can capture
				break  # Blocked
			moves.append(pos)

	return moves

func is_within_bounds(pos: Vector3i) -> bool:
	return (
		pos.x >= 0 and pos.x < 8 and
		pos.y >= 0 and pos.y < 8 and
		pos.z >= 0 and pos.z < 8
	)
