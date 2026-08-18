@tool
extends Node3D
@onready var headShader = $"../metarig/Skeleton3D/Cube".get_surface_override_material(0)

var uvX1 : float = 0.0
var uvY : float = 0.0
var uvX2 : float = 0.0
var uvY2 : float = 0.0

var localY : float
var lastY : float

var subBool : bool = false

func _physics_process(delta: float) -> void:
	
	headShader.set_shader_parameter("eyeSize", scale.y)
	
	if position.y == 0:
		position.y = 0.525
	
	if subBool == false:
		position.y = 0.525
		lastY = position.y
		subBool = true
	
	localY = position.y - lastY
	
	
	if position.x < 0.04 and position.x > -0.21:
		uvX1 = position.x * 9
	if position.x > -0.04 and position.x < 0.158:
		uvX2 = position.x * 9
	uvY = localY * 9
	headShader.set_shader_parameter("pupilUV1", Vector2(uvX1, uvY))
	headShader.set_shader_parameter("pupilUV2", Vector2(uvX2, uvY))
