extends State
class_name flying

@onready var anim  = $"../../monkey/AnimationPlayer"
@onready var monkeyModel = $"../../monkey"
@export var playerVars : CharacterBody3D

func enter() -> void:
	playerVars.velocity = Vector3.ZERO
	anim.speed_scale = 2.45
	playerVars.applyShake()
	anim.play("launchIntro")
	

func update(delta : float) -> void:
	
	if playerVars.shakeStrength > 0:
		playerVars.shakeStrength = lerpf(playerVars.shakeStrength, 0, playerVars.shakeFade * delta)
		%Camera3D.v_offset = playerVars.randOffset().y
		
func physicsUpdate(delta : float) -> void:
	playerVars.storedVelocity += 4.5
	
	if anim.current_animation == "flying":
		monkeyModel.rotation_degrees.y += 2.39
		anim.speed_scale = 1.25
	else:
		monkeyModel.rotation_degrees.y = playerVars.rotation.y
	
	print(Global.pathProgess)
	
	
	playerVars.position = Global.playerFlyingPos
	playerVars.rotation.x = -Global.playerFlyingRot.x - ((Global.pathProgess*3.125))
	playerVars.rotation.y = Global.playerFlyingRot.y #- (Global.pathProgess*3.125)
	playerVars.rotation.z = Global.playerFlyingRot.z * 1.25 #- (Global.pathProgess*3.125)
	
	if Global.pathProgess < 1:
		Global.pathProgess += 0.0025
	
	if Global.pathProgess > 0.95:
		anim.speed_scale = 2.5
		anim.play_backwards("backflipping")
		
	
	if Global.pathProgess >= 1:
		Global.inLaunchZone = false
		Global.pathProgess = 0
		Global.landing = true
		playerVars.rotation.x = 0
		playerVars.rotation.z = 0
		playerVars.rotation.y = 90
		
		transition.emit(self, "inAir")
		
