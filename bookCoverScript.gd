extends Node3D

@onready var shader = $Armature/Skeleton3D/Cube.get_surface_override_material(0)
var bookCover

func _process(delta: float) -> void:
	shader.set_shader_parameter("albedo_texture", bookCover)
