extends Piece


func _ready() -> void:
	super._ready()
	self.piece_type = "queen"

# 6 straight directions + 8 cubic diagonals
var directions: Array[Vector3i] = [
	# Axis directions
	Vector3i(1, 0, 0), Vector3i(-1, 0, 0),
	Vector3i(0, 1, 0), Vector3i(0, -1, 0),
	Vector3i(0, 0, 1), Vector3i(0, 0, -1),

	# 3D cube diagonals (±1, ±1, ±1)
	Vector3i(1, 1, 1), Vector3i(1, 1, -1), Vector3i(1, -1, 1), Vector3i(1, -1, -1),
	Vector3i(-1, 1, 1), Vector3i(-1, 1, -1), Vector3i(-1, -1, 1), Vector3i(-1, -1, -1),
]

func get_valid_moves(grid_state: Dictionary) -> Array[Vector3i]:
	var game_manager = get_node("/root/GridRoot/GameManager")
	var valid_moves: Array[Vector3i] = []

	for dir in directions:
		var pos := grid_pos
		while true:
			pos += dir
			if not is_within_bounds(pos):
				break

			if not grid_state.has(pos):
				if not game_manager.would_be_in_check(grid_state, grid_pos, pos, owner_id):
					valid_moves.append(pos)
				continue

			var piece = grid_state[pos]
			if piece == null:
				if not game_manager.would_be_in_check(grid_state, grid_pos, pos, owner_id):
					valid_moves.append(pos)
			elif piece.owner_id != owner_id:
				if not game_manager.would_be_in_check(grid_state, grid_pos, pos, owner_id):
					create_capture_indicator(pos)
					valid_moves.append(pos)
					break  # Capture enemy, then stop
			else:
				break  # Blocked by friendly piece

	return valid_moves


func is_within_bounds(pos: Vector3i) -> bool:
	return pos.x >= 0 and pos.x < 8 and pos.y >= 0 and pos.y < 8 and pos.z >= 0 and pos.z < 8

func get_valid_moves_without_capture(grid_state: Dictionary, ignore_king_safety := false) -> Array[Vector3i]:
	var valid_moves: Array[Vector3i] = []

	for dir in directions:
		var pos := grid_pos
		while true:
			pos += dir
			if not is_within_bounds(pos):
				break

			if not grid_state.has(pos):
				valid_moves.append(pos)
				continue

			var piece = grid_state[pos]
			if piece == null:
				valid_moves.append(pos)
			elif piece.owner_id != owner_id:
				valid_moves.append(pos)
				break  # Capture enemy, then stop
			else:
				break  # Blocked by friendly piece

	return valid_moves
