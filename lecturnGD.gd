extends Node3D

#var inputBool = false

@export var level : String
@export var bookCover : CompressedTexture2D
var transitionBool : bool = false

func _ready() -> void:
	transitionBool = false

func _process(delta: float) -> void:
	if Global.animFinsihed == true and transitionBool == false:
		transitionBool = true
		SceneTransition.transition(level)
	$bookUsable.bookCover = bookCover
		

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action") and Global.inputBool == true:
		Global.inSelection = true
	
	#elif Input.is_action_just_released("action"):
	#	inputBool = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Monkey":
		Global.inputBool = true
		print("true")
		

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Monkey":
		Global.inputBool = false
		print("false")
