extends State
class_name isHit

@onready var anim = $"../../monkey/AnimationPlayer"
@export var rootVars : CharacterBody3D

func enter() -> void:

	pass

func physicsUpdate(delta : float) -> void:
	anim.play("hit")
	rootVars.headShader.set_shader_parameter("mouthUVX", rootVars.mouthTextPos[3])
	rootVars.velocity = (Vector3(-sin(rootVars.rotation.y), 0, -cos(rootVars.rotation.y)) * -5)
	await anim.animation_finished
	Global.playerHit = false
	transition.emit(self, "Idle")
