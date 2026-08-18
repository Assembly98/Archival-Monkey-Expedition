extends State
class_name idleEnemy

@onready var anim = $"../../enemyTempModel/AnimationPlayer"
@export var rootVars : CharacterBody3D


func enter() -> void:
	anim.speed_scale = 1
	anim.play("Idle")

func physicsUpdate(delta : float) -> void:
	anim.play("Idle")
	if rootVars.playerDetected == true:
		transition.emit(self, "chase")
