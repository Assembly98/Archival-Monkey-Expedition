extends State

class_name spinAttackextends

@onready var anim  = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D

func enter() -> void:
	#playerVars.velocity.x = 0
	#playerVars.velocity.z = 0
	playerVars.headShader.set_shader_parameter("uvX", -0.105)
	
	
	var moveInput = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (playerVars._camera_pivot.basis * Vector3(moveInput.x, 0, moveInput.y))
	direction.y = 0.0
	direction = direction.normalized()
	
	if direction.length() > 0:
		playerVars.lastMoveDir = -direction
	var targetDir := Vector3.BACK.signed_angle_to(playerVars.lastMoveDir, Vector3.UP)
	playerVars.rotation.y = targetDir
	
func physicsUpdate(delta : float) -> void:
	var y_velocity := playerVars.velocity.y
	playerVars.velocity.y = 0
	
	var moveInput = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (playerVars._camera_pivot.basis * Vector3(moveInput.x, 0, moveInput.y))
	direction.y = 0.0
	direction = direction.normalized()
	
	
	playerVars.velocity = playerVars.velocity.move_toward(direction * 1, 45 * delta)
	
	#playerVars.velocity.y = y_velocity + (-50) * delta
	
	await anim.animation_finished
	
	if playerVars.velocity == Vector3.ZERO:
		transition.emit(self, "Idle")
		$"../../Area3D/CollisionShape3D".disabled = true
	elif playerVars.velocity != Vector3.ZERO:
		transition.emit(self, "moving")
		$"../../Area3D/CollisionShape3D".disabled = true
	
	if Global.playerHit:
		transition.emit(self, "isHit")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemys"):
		body.isHit()
		body.rotation = playerVars.rotation
		print("EnemyHit")
