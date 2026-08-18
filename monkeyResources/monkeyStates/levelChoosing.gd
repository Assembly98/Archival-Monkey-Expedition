extends State
class_name levelChoosing

@onready var anim = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D
var animPlaying = false
var textAnim = false

func enter() -> void:
	playerVars.velocity = Vector3.ZERO
	animPlaying = false
	textAnim = false
	anim.speed_scale = 1
	anim.play("topPeeking")
	$"../../monkey/faceAnimator".play("lookDown")


func update(delta : float) -> void:
	
	if textAnim == false:
		if playerVars.textTracker > 550:
			playerVars.headShader.set_shader_parameter("eyeUVX", playerVars.eyeTextPos[1])
		else:
			playerVars.headShader.set_shader_parameter("eyeUVX", playerVars.eyeTextPos[0])
		
	playerVars.textTracker += 1
	playerVars.textTracker = wrapi(playerVars.textTracker, 0, 575)
	
	print(anim.current_animation)
	
	if Input.is_action_just_pressed("action2") and animPlaying == false and not textAnim == true:
		anim.play_backwards("topPeeking")
		animPlaying = true
	if Input.is_action_just_pressed("jump"):
		textAnim = true
		Global.jumpIn = true
		anim.speed_scale = 1.35
		playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[3])
		playerVars.headShader.set_shader_parameter("mouthUVY", 0)
		anim.play("jumpIn")
		await anim.animation_finished
		await get_tree().create_timer(1).timeout
		Global.selected = true
	else:
		playerVars.headShader.set_shader_parameter("mouthUVX", playerVars.mouthTextPos[4])
		playerVars.headShader.set_shader_parameter("mouthUVY", -0.1)
		
	if anim.current_animation_position == 0 and animPlaying == true:
		Global.inSelection = false
		playerVars.headShader.set_shader_parameter("mouthUVY", 0)
		$"../../monkey/faceAnimator".play("RESET")
		transition.emit(self, "Idle")
		
