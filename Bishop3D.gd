extends Piece


func _ready() -> void:
	super._ready()
	self.piece_type = "bishop"

func get_valid_moves(grid_state: Dictionary) -> Array[Vector3i]:
	var moves: Array[Vector3i] = []
	var game_manager = get_node("/root/GridRoot/GameManager")

	# Planar diagonal directions (XY, YZ, XZ planes)
	var directions := [
		Vector3i(1, 1, 0), Vector3i(-1, 1, 0), Vector3i(1, -1, 0), Vector3i(-1, -1, 0),  # XY
		Vector3i(0, 1, 1), Vector3i(0, -1, 1), Vector3i(0, 1, -1), Vector3i(0, -1, -1),  # YZ
		Vector3i(1, 0, 1), Vector3i(-1, 0, 1), Vector3i(1, 0, -1), Vector3i(-1, 0, -1),  # XZ
	]

	for dir in directions:
		for step in range(1, 8):  # Max board size
			var pos = grid_pos + dir * step
			if not is_within_bounds(pos):
				break
			
			if grid_state.has(pos) and grid_state[pos] != null:
				if grid_state[pos].owner_id != owner_id:
					if not game_manager.would_be_in_check(grid_state, grid_pos, pos, owner_id):
						create_capture_indicator(pos)
						moves.append(pos)  # Can capture
				break  # Blocked by any piece
			else:
				if not game_manager.would_be_in_check(grid_state, grid_pos, pos, owner_id):
					moves.append(pos)  # Empty space — valid move

	return moves

func is_within_bounds(pos: Vector3i) -> bool:
	return (
		pos.x >= 0 and pos.x < 8 and
		pos.y >= 0 and pos.y < 8 and
		pos.z >= 0 and pos.z < 8
	)

func get_valid_moves_without_capture(grid_state: Dictionary, ignore_king_safety := false) -> Array[Vector3i]:
	var moves: Array[Vector3i] = []

	# Planar diagonal directions (XY, YZ, XZ planes)
	var directions := [
		Vector3i(1, 1, 0), Vector3i(-1, 1, 0), Vector3i(1, -1, 0), Vector3i(-1, -1, 0),  # XY
		Vector3i(0, 1, 1), Vector3i(0, -1, 1), Vector3i(0, 1, -1), Vector3i(0, -1, -1),  # YZ
		Vector3i(1, 0, 1), Vector3i(-1, 0, 1), Vector3i(1, 0, -1), Vector3i(-1, 0, -1),  # XZ
	]

	for dir in directions:
		for step in range(1, 8):  # Max board size
			var pos = grid_pos + dir * step
			if not is_within_bounds(pos):
				break

			if grid_state.has(pos) and grid_state[pos] != null:
				if grid_state[pos].owner_id != owner_id:
					
					moves.append(pos)  # Can capture
				break  # Blocked by any piece
			else:
				moves.append(pos)  # Empty space — valid move

	return moves
