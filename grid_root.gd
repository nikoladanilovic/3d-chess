extends Node3D

@export var grid_size := 8
@export var cell_size := 1.0
@export var line_color := Color(0.8, 0.8, 1.0)

@onready var piece_scene = preload("res://Piece.tscn")
@export var piece_parent : Node3D  # Optional Node3D to organize pieces

func _ready():
	var mesh_instance := MeshInstance3D.new()
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_LINES)

	for x in grid_size:
		for y in grid_size:
			for z in grid_size:
				var base := Vector3(x, y, z) * cell_size
				draw_wireframe_cube(st, base, cell_size)

	var mesh := st.commit()
	mesh_instance.mesh = mesh

	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = line_color
	mesh_instance.material_override = mat

	add_child(mesh_instance)
	
	#spawn_piece(Vector3i(0, 0, 0))
	#spawn_piece(Vector3i(4, 2, 5))
	#spawn_piece(Vector3i(2, 3, 6))

func draw_wireframe_cube(st: SurfaceTool, base: Vector3, size: float):
	var corners = [
		base,
		base + Vector3(size, 0, 0),
		base + Vector3(size, size, 0),
		base + Vector3(0, size, 0),
		base + Vector3(0, 0, size),
		base + Vector3(size, 0, size),
		base + Vector3(size, size, size),
		base + Vector3(0, size, size),
	]

	var edges = [
		[0, 1], [1, 2], [2, 3], [3, 0],  # bottom face
		[4, 5], [5, 6], [6, 7], [7, 4],  # top face
		[0, 4], [1, 5], [2, 6], [3, 7],  # verticals
	]

	for edge in edges:
		st.add_vertex(corners[edge[0]])
		st.add_vertex(corners[edge[1]])
		
func spawn_piece(grid_pos: Vector3i):
	var piece = piece_scene.instantiate()
	piece.cell_size = cell_size
	piece.move_to_grid(grid_pos)
	piece_parent.add_child(piece)  # Or just add_child(piece) if no container
