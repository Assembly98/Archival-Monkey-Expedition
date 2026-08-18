extends State
class_name chase

@onready var anim = $"../../enemyTempModel/AnimationPlayer"
@export var rootVars : CharacterBody3D


func enter() -> void:
	anim.speed_scale = 1.7
	
func physicsUpdate(delta : float) -> void:
	anim.play("running")
	
	
	if rootVars.canAttack:
		transition.emit(self, "attacking")
	
	if not rootVars.playerDetected:
		transition.emit(self, "idleEnemy")
	
	if not rootVars.player == null:
		rootVars.look_at(rootVars.player.global_position, Vector3.UP, true)
		rootVars.rotation.x = 0
		rootVars.rotation.z = 0
		
		
		rootVars.position = rootVars.position.move_toward(rootVars.player.global_position, 7 * delta)
	
	rootVars.apply_floor_snap()
	
	
