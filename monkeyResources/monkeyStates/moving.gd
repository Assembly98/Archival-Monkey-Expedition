extends State
class_name moving

@onready var anim = $"../../monkey/AnimationPlayer"
@onready var monkey: Node3D = $"../../monkey"
@export var playerVars : CharacterBody3D
var skidding : bool = false
var stairsBool : bool = false

func enter() -> void:
	playerVars.timer.start()
	playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.eyeTextPos[0])

func physicsUpdate(delta : float) -> void:
	anim.speed_scale = 1.4
	
	
	
	if not playerVars.is_on_floor():
		transition.emit(self, "inAir")
	
	var moveInput = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (playerVars._camera_pivot.basis * Vector3(moveInput.x, 0, moveInput.y))
	direction.y = 0.0
	direction = direction.normalized()
	
	if direction.length() > 0:
		playerVars.lastMoveDir = -direction
	var targetDir := Vector3.BACK.signed_angle_to(playerVars.lastMoveDir, Vector3.UP)
	playerVars.rotation.y = lerp_angle(playerVars.rotation.y, targetDir, 35.0 * delta)
	
	
	
	if direction and not direction.dot(playerVars.velocity) < 0:
		playerVars.velocity = playerVars.velocity.lerp((direction * 10), 25 * delta)
	else:
		playerVars.velocity = playerVars.velocity.move_toward(Vector3.ZERO, 35 * delta)
	
	if direction.dot(playerVars.velocity) < 0 and playerVars.velocity != Vector3.ZERO:
		playerVars.velocity -= Vector3(7, 0, 7) * delta
		
		if playerVars.velocity.length() > 7:
			anim.play("skid")
			monkey.rotation_degrees.y = 180
		#skidding = true
		#if Input.is_action_just_pressed("jump"):
			#anim.speed_scale = 1
			#anim.play("sideJump")
			#playerVars.velocity = playerVars.velocity.move_toward(direction * 100, 250 * delta)
			#monkey.rotation_degrees.y = 90
			#playerVars.velocity.y += 25
			#transition.emit(self, "inAir")
	else:
		monkey.rotation_degrees.y = 0
		skidding = false
		if playerVars.is_on_floor():
			if not Global.propellor:
				anim.play("run")
			else:
				anim.play("runGlider")
	
	
	if playerVars.step_cast.is_colliding() and playerVars.velocity.y <= 0.0 and playerVars.step_cast.get_collision_normal(0).angle_to(Vector3.UP) < playerVars.floor_max_angle and playerVars.is_on_floor():
		playerVars.global_position.y = playerVars.step_cast.get_collision_point(0).y + 0.85
		playerVars._camera_pivot.global_position.y = playerVars.global_position.y #+ 0.85
		playerVars.velocity.y = 0.0
		playerVars.grounded = true
		#playerVars.floor_snap_length = 0.0
	else:
		playerVars.grounded = false
		
		#playerVars.floor_snap_length = 50
	
	
	
	#if direction and abs(playerVars.velocity.length()) < 20:
		#playerVars.velocity.x += direction.x * playerVars.speed
		#playerVars.velocity.z += direction.z * playerVars.speed
	#else:
		#playerVars.velocity.x = move_toward(playerVars.velocity.x, 0, 10)
		#playerVars.velocity.z = move_toward(playerVars.velocity.z, 0, 10)
	#
	#if is_equal_approx(direction.length_squared(), 0) and round(playerVars.velocity.length()) == 0:
		##transition.emit(self, "Idle")
		#playerVars.velocity = Vector3.ZERO
	
	#if direction == -playerVars.velocity.normalized(): 
		##print("backing")
		#playerVars.velocity = playerVars.velocity.move_toward(Vector3.ZERO, 250 * delta)
	
	if not direction and playerVars.velocity == Vector3.ZERO:
		transition.emit(self, "Idle")
	
	
	if playerVars.timer.time_left <= 0.05:
		playerVars.jumps = 0
	
	if skidding == false and Input.is_action_just_pressed("jump") and not Input.is_action_pressed("backButton"):
		if Global.propellor == false:
			playerVars.jumps += 1
			playerVars.velocity.y += playerVars.jumpVel[playerVars.jumps - 1]
			anim.speed_scale = 1.75
			if playerVars.velocity.length() < 10:
				playerVars.jumps = wrapi(playerVars.jumps, 0, 2)
				if playerVars.jumps == 1:
					anim.play("jump")
					playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[1])
				else:
					anim.play("jump2")
					playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[2])
			elif playerVars.velocity.length() > 10:
				playerVars.jumps = wrapi(playerVars.jumps, 0, playerVars.jumpVel.size())
				if playerVars.jumps == 1:
					anim.play("jump")
					playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[1])
				elif playerVars.jumps == 2:
					anim.play("jump2")
					playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[2])
				else:
					anim.play_backwards("backflipping")
					playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[1])
		else:
			anim.play("gliderJump")
			playerVars.velocity.y += 20
		transition.emit(self, "inAir")
	#else:
	#	$"../../jumpTimer".paused = true
	
	
	if Input.is_action_just_pressed("backButton"):
		anim.play("crouch")
		transition.emit(self, "crouching")
	
	
	if Input.is_action_just_pressed("action") and not Global.inSelection:
		$"../../Area3D/CollisionShape3D".disabled = false
		#playerVars.velocity = playerVars.velocity.move_toward(playerVars.velocity/200, 500*delta)
		anim.speed_scale = 3
		#playerVars.rotation.y = lerp_angle(playerVars.rotation.y, targetDir, 25.0 * delta)
		anim.play("spinJump")
		#await anim.animation_finished
		#await anim.animation_finished
		#anim.play("spinJump")
		transition.emit(self, "spinAttack")
	
	if Input.is_action_just_pressed("action") and Global.inputBool == true:
		transition.emit(self, "levelChoosing")
	
	if Global.playerHit:
		transition.emit(self, "isHit")
	
		
	#print("jumpTime: ", playerVars.timer.time_left)
	#print("vel: ", playerVars.velocity.length())
	

func onFloor():
	return playerVars.is_on_floor() or stairsBool
	
