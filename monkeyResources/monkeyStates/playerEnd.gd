extends State

class_name playerEnd

@onready var anim = $"../../monkey/AnimationPlayer"
@export var rootVars : CharacterBody3D
var playAnim : bool = true
var backWardsAnim : bool = false

func enter() -> void:
	playAnim = true

func physicsUpdate(delta : float) -> void:
	rootVars.velocity = Vector3.ZERO
	if playAnim == true:
		anim.speed_scale = 0.85
		anim.play("warp")
		await anim.animation_finished
		SceneTransition.transition("res://levelClearScreen3D.tscn")
		playAnim = false
			
