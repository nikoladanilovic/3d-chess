extends Piece

var isBlack = true

func get_valid_moves(grid_state: Dictionary) -> Array[Vector3i]:
	
	if original_color != Color.BLACK:
		isBlack = false
	
	var dir := 1 if isBlack else -1
	
	var valid_moves : Array[Vector3i] = []
	var move_directions: Array[Vector3i]= []
	# Define movement directions (only move if the destination is empty)
	move_directions = [
		Vector3i(0, 1 * dir, 0),     # Forward
		Vector3i(0, 0, 1 * dir),     # Up/down
		Vector3i(0, 1 * dir, 1 * dir),  # Forward + Up/Down
	]

	for d in move_directions:
		var target := grid_pos + d
		if is_within_bounds(target):
			if not grid_state.has(target) or grid_state[target] == null:
				valid_moves.append(target)

	# Define capture directions (must have an enemy piece)
	var capture_directions: Array[Vector3i]= []
	capture_directions = [
		Vector3i(1, 1 * dir, 1 * dir),
		Vector3i(-1, 1 * dir, 1 * dir),
		Vector3i(1, 1 * dir, 0),
		Vector3i(-1, 1 * dir, 0),
		Vector3i(1, 0, 1 * dir),
		Vector3i(-1, 0, 1 * dir),
	]

	for d in capture_directions:
		var target := grid_pos + d
		if is_within_bounds(target):
			if grid_state.has(target) and grid_state[target] != null:
				var piece = grid_state[target]
				if piece.owner_id != owner_id:
					create_capture_indicator(target)
					valid_moves.append(target)

	return valid_moves

func is_within_bounds(pos: Vector3i) -> bool:
	return pos.x >= 0 and pos.x < 8 and pos.y >= 0 and pos.y < 8 and pos.z >= 0 and pos.z < 8
