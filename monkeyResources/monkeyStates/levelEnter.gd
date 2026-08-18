extends State
class_name levelEnter

@onready var anim = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D

func enter() -> void:
	anim.play_backwards("backflipping")
	Global.landing = true
	Global.inSelection = false

func physicsUpdate(delta : float) -> void:
	anim.play_backwards("backflipping")
	var direction = (Vector3(-sin(playerVars.rotation.y), 0, -cos(playerVars.rotation.y)))
	print("landing")
	print(anim.is_playing())
	print(anim.current_animation_position)
	playerVars.velocity.y -= 1.5
	playerVars.velocity += direction * 1.5
	
	print(Engine.get_frames_per_second())
	
	anim.speed_scale = 2.5
	
	
	if playerVars.is_on_floor():
		transition.emit(self, "Idle")
		
