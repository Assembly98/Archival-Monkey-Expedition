extends State
class_name longJump

@onready var anim = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D

func enter() -> void:
	playerVars.headShader.set_shader_parameter("uvX", -0.210)

func physicsUpdate(delta : float) -> void:
	var y_velocity := playerVars.velocity.y
	playerVars.velocity.y = 0
	
	var moveInput = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (playerVars._camera_pivot.basis * Vector3(moveInput.x, 0, moveInput.y))
	direction.y = 0.0
	direction = direction.normalized()
	if direction.length() > 0:
		playerVars.lastMoveDir = -direction
	var targetDir := Vector3.BACK.signed_angle_to(playerVars.lastMoveDir, Vector3.UP)
	if not direction.dot(playerVars.velocity) < 0:
		playerVars.rotation.y = lerp_angle(playerVars.rotation.y, targetDir, 0.5 * delta)
	
	
	
	var groundSpd = Vector2(playerVars.velocity.x, playerVars.velocity.z).length()
	
	playerVars.velocity = playerVars.velocity.move_toward(direction * 12, 35 * delta)
	
	#if direction:
		#playerVars.velocity.x += direction.x * 0.1
		#playerVars.velocity.z += direction.z * 0.1
	
	playerVars.velocity.y = y_velocity + (-50) * delta
	
	if Input.is_action_just_pressed("action"):
		playerVars.velocity.y = 0
		playerVars.velocity.y += 20
		anim.speed_scale = 3
		anim.play("spinJump")
		transition.emit(self, "spinJump")
	
	if playerVars.is_on_floor() and playerVars.velocity == Vector3.ZERO:
		transition.emit(self, "Idle")
	elif playerVars.is_on_floor() and playerVars.velocity != Vector3.ZERO:
		transition.emit(self, "moving")

	if Global.playerHit:
		transition.emit(self, "isHit")
