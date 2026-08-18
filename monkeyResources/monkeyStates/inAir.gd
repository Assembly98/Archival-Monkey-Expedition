extends State
class_name  inAir

@onready var anim  = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D

func enter() -> void:
	if not Input.is_action_just_pressed("jump") and not Global.landing:
		anim.play("falling")
	
		

func physicsUpdate(delta : float) -> void:
	
	#playerVars.speed = 8.0
	
	var y_velocity := playerVars.velocity.y
	playerVars.velocity.y = 0
	
	var moveInput = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (playerVars._camera_pivot.basis * Vector3(moveInput.x, 0, moveInput.y))
	direction.y = 0.0
	direction = direction.normalized()
	
	if direction.length() > 0:
		playerVars.lastMoveDir = -direction
	var targetDir := Vector3.BACK.signed_angle_to(playerVars.lastMoveDir, Vector3.UP)
	playerVars.rotation.y = lerp_angle(playerVars.rotation.y, targetDir, 5.0 * delta)
	
	playerVars.velocity = playerVars.velocity.move_toward(direction * 10, 25 * delta)
	
	if not Global.inLaunchZone and not Global.landing and not Global.propellor:
		playerVars.velocity.y = y_velocity + ((-50)) * delta
		#print("norm")
	elif  Global.propellor:
		print(y_velocity)
		if y_velocity >= -1:
			playerVars.velocity.y = y_velocity + ((-10)) * delta
		else:
			playerVars.velocity.y = -1
		
		if playerVars.velocity.length() < 12:
			anim.play("gliding")
		else:
			anim.play("glidingFast")
	elif Global.landing:
		playerVars.velocity.y = y_velocity + (-playerVars.storedVelocity) * delta
		anim.play("backflipping")
		#print("flips")
	else:
		#print("justRight")
		#print("Gloabl launch pos: ", Global.launchZonePos)
		#print("Gloabl launch rot: ", Global.launchZoneRot)
		playerVars.velocity = Vector3.ZERO
		playerVars.position = playerVars.position.move_toward(Global.launchZonePos, 10 * delta)
		playerVars.rotation.x = move_toward(playerVars.rotation.x, Global.launchZoneRot.z, 10 * delta)
	
	if Input.is_action_just_pressed("action") and Global.inLaunchZone:
		anim.speed_scale = 4
		anim.play("spinJump")
		await anim.animation_finished
		anim.play("spinJump")
		await anim.animation_finished
		await get_tree().create_timer(0.45).timeout
		transition.emit(self, "flying")
	
	if Input.is_action_just_pressed("action"):
		playerVars.velocity.y = 0
		playerVars.velocity.y += 20
		anim.speed_scale = 3
		playerVars.rotation.y = lerp_angle(playerVars.rotation.y, targetDir, 25.0 * delta)
		anim.play("spinJump")
		#await anim.animation_finished
		#anim.play("spinJump")
		transition.emit(self, "spinJump")
	
	if Input.is_action_just_pressed("action2"):
		direction = (Vector3(-sin(playerVars.rotation.y), 0, -cos(playerVars.rotation.y)))
		direction = direction.normalized()
		playerVars.velocity = Vector3.ZERO
		playerVars.velocity.y += 17
		playerVars.velocity += direction * 25
		anim.speed_scale = 1.75
		anim.play("dive")
		transition.emit(self, "dive")
	
	#if Input.is_action_just_pressed("testJump"):
		#playerVars.velocity.y += 17
	
	
	if playerVars.is_on_floor() and playerVars.velocity == Vector3.ZERO:
		transition.emit(self, "Idle")
	elif playerVars.is_on_floor() and playerVars.velocity != Vector3.ZERO:
		transition.emit(self, "moving")
	
	if playerVars.isOnWall() and playerVars.canWallSlide():
		transition.emit(self, "onWall")
	if Global.playerLvEnd == true:
		transition.emit(self, "playerEnd")
	
	if Global.playerHit:
		transition.emit(self, "isHit")
