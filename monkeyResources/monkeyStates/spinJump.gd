extends State
class_name spinJump

@onready var anim  = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D

func enter() -> void:
	playerVars.velocity.x = 0
	playerVars.velocity.z = 0
	
	playerVars.headShader.set_shader_parameter("uvX", -0.157)
	
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
	
	#if direction.length() > 0:
		#playerVars.lastMoveDir = -direction
	#var targetDir := Vector3.BACK.signed_angle_to(playerVars.lastMoveDir, Vector3.UP)
	#playerVars.rotation.y = lerp_angle(playerVars.rotation.y, targetDir, 1.0 * delta)
	
	
	playerVars.velocity = playerVars.velocity.move_toward(direction * 10, 14 * delta)
	
	playerVars.velocity.y = y_velocity + (-50) * delta
	
	print(playerVars.isOnWall())
	
	if playerVars.is_on_floor() and playerVars.velocity == Vector3.ZERO:
		transition.emit(self, "Idle")
	elif playerVars.is_on_floor() and playerVars.velocity != Vector3.ZERO:
		transition.emit(self, "moving")
	if playerVars.isOnWall():
		transition.emit(self, "onWall")
		
	if Input.is_action_just_pressed("action2"):
		direction = (Vector3(-sin(playerVars.rotation.y), 0, -cos(playerVars.rotation.y)))
		direction = direction.normalized()
		playerVars.velocity = Vector3.ZERO
		playerVars.velocity.y += 17
		playerVars.velocity += direction * 25
		anim.speed_scale = 1.75
		anim.play("dive")
		transition.emit(self, "dive")
	
	if Global.playerHit:
		transition.emit(self, "isHit")
