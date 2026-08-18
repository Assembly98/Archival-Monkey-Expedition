extends State
class_name backFlipping

@onready var anim = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D

func physicsUpdate(delta : float) -> void:
	anim.speed_scale = 1.5
	anim.play("backflipping")
	
	var y_velocity := playerVars.velocity.y
	playerVars.velocity.y = 0
	playerVars.velocity.y = y_velocity + (-50) * delta
	
	if playerVars.is_on_floor() and playerVars.velocity == Vector3.ZERO:
		transition.emit(self, "Idle")
	elif playerVars.is_on_floor() and playerVars.velocity != Vector3.ZERO:
		transition.emit(self, "moving")
	
	if Input.is_action_just_pressed("action"):
		playerVars.velocity.y = 0
		playerVars.velocity.y += 20
		anim.speed_scale = 3
		anim.play("spinJump")
		transition.emit(self, "spinJump")
	
	if Global.playerHit:
		transition.emit(self, "isHit")
	
	print("backflipping")
