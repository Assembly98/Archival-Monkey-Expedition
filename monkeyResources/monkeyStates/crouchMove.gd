extends State
class_name crouchMove

@onready var anim = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D

func update(delta : float) -> void:
	anim.play("crouchMove")
	
	var moveInput = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (playerVars._camera_pivot.basis * Vector3(moveInput.x, 0, moveInput.y))
	direction.y = 0.0
	direction = direction.normalized()
	if direction.length() > 0:
		playerVars.lastMoveDir = -direction
	var targetDir := Vector3.BACK.signed_angle_to(playerVars.lastMoveDir, Vector3.UP)
	playerVars.rotation.y = lerp_angle(playerVars.rotation.y, targetDir, 30.0 * delta)
	
	playerVars.velocity = playerVars.velocity.move_toward(direction * 5, 20 * delta)
	
	var groundSpd = Vector2(playerVars.velocity.x, playerVars.velocity.z).length()
	
	if groundSpd > 5.0: #and is_on_floor():
		#direction = (Vector3(-sin(playerVars.rotation.y), 0, -cos(playerVars.rotation.y)))
		#direction.y = 0.0
		#direction = direction.normalized()
		if Input.is_action_just_pressed("jump"):
			anim.speed_scale = 1.25
			playerVars.velocity.y += 15
			playerVars.velocity += direction * 20
			anim.play("longJump")
			transition.emit(self, "longJump")
	
	if Input.is_action_just_released("backButton") and playerVars.velocity == Vector3.ZERO:
		transition.emit(self, "Idle")
	if Input.is_action_just_released("backButton"):
		transition.emit(self, "moving")
	
	if not direction and playerVars.velocity == Vector3.ZERO:
		transition.emit(self, "crouching")
