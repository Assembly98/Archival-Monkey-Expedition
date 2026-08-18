extends State
class_name Idle

@onready var anim = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D


func enter() -> void:
	$"../../jumpTimer".start()
	playerVars.storedVelocity = 0
	playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[0])
	if Global.landing:
		playerVars.velocity.z = 0
		#print("PFR: ", rad_to_deg(Global.playerFlyingRot.y))
		playerVars.rotation_degrees = Vector3(0, 90, 0)
		print(true)
		playerVars.applyShake()
		anim.play("launchLanding")
		playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[2])
		await anim.animation_finished
		Global.landing = false
		
func update(delta : float) -> void:
	if playerVars.shakeStrength > 0:
		playerVars.shakeStrength = lerpf(playerVars.shakeStrength, 0, playerVars.shakeFade * delta)
		#%Camera3D.h_offset = playerVars.randOffset().x
		%Camera3D.v_offset = playerVars.randOffset().y
	
func physicsUpdate(delta : float) -> void:
		
	anim.speed_scale = 0.5
	if not Global.landing:
		if not Global.propellor:
			anim.play("Idle")
		else:
			anim.play("gliderIdle")
		playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.eyeTextPos[0])
	
	#playerVars.velocity.x = move_toward(playerVars.velocity.x, 0, 10)
	#playerVars.velocity.z = move_toward(playerVars.velocity.z, 0, 10)
	
	playerVars.velocity = playerVars.velocity.move_toward(Vector3.ZERO, 15 * delta)
		
	if Input.get_vector("Left", "Right", "Forward", "Backwards"):
		transition.emit(self, "moving")
	
	if not playerVars.is_on_floor():
		transition.emit(self, "inAir")
	
	if Input.is_action_just_pressed("backButton"):
		anim.play("crouch")
		transition.emit(self, "crouching")
	
	if playerVars.timer.time_left <= 0.05:
		playerVars.jumps = 0
	
	if Input.is_action_just_pressed("jump"):
		playerVars.jumps += 1
		playerVars.velocity.y += playerVars.jumpVel[playerVars.jumps - 1]
		if playerVars.velocity.length() > 10:
			playerVars.jumps = wrapi(playerVars.jumps, 0, 2)
		anim.speed_scale = 1.75
		if playerVars.jumps == 1:
			anim.play("jump")
			playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[1])
		else:
			anim.play("jump2")
			playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[2])
		#anim.play("jump")
		transition.emit(self, "inAir")
	
	#if not playerVars.is_on_floor():
	#	transition.emit(self, "inAir")
	
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
	
	
	
