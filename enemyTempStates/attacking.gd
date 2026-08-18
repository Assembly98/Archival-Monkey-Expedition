extends State
class_name attacking

@onready var anim = $"../../enemyTempModel/AnimationPlayer"
@export var rootVars : CharacterBody3D

func enter() -> void:
	anim.speed_scale = 1
	anim.play("Attack")
	

func physicsUpdate(delta : float) -> void:
	
	print(snapped(anim.current_animation_position, 0.01))
	
	if snapped(anim.current_animation_position, 0.01) >= 0.85 and snapped(anim.current_animation_position, 0.01) >= 0.9:
		$"../../attackCollision/CollisionShape3D".disabled = false
	if snapped(anim.current_animation_position, 0.01) >= 1.11:
		$"../../attackCollision/CollisionShape3D".disabled = true
	
		await anim.animation_finished
	
		transition.emit(self, "idleEnemy")



func _on_attack_collision_body_entered(body: Node3D) -> void:
	if body.name == "Monkey":
		body.isHit()
		body.rotation = rootVars.rotation
