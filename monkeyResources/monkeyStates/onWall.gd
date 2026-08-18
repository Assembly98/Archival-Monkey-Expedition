extends State
class_name onWall

@onready var anim  = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D

func enter() -> void:
	anim.play("onWall")
	playerVars.velocity.y = 0

func physicsUpdate(delta : float) -> void:
	var y_velocity := playerVars.velocity.y
	#playerVars.velocity.y = 0
	
	playerVars.velocity = (Vector3.UP * (-100)) * delta
	
	var moveInput = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (playerVars._camera_pivot.basis * Vector3(moveInput.x, 0, moveInput.y))
	direction.y = 0.0
	direction = direction.normalized()
	
	print(playerVars.ray.get_collision_normal())
	
	if Input.is_action_just_pressed("jump"):
		playerVars.velocity.y = 0
		playerVars.velocity.y += 30
		playerVars.velocity += playerVars.ray.get_collision_normal() * 20
		anim.play("jump2")
		playerVars.headShader.set_shader_parameter("uvX", -0.210)
		playerVars.rotation_degrees.y += 180
		transition.emit(self, "inAir")
	
	if playerVars.is_on_floor():
		transition.emit(self, "Idle")
	
	#if round(direction) != playerVars.ray.get_collision_normal():
		#transition.emit(self, "inAir")
	
	if not playerVars.isOnWall() and not playerVars.is_on_floor():
		transition.emit(self, "inAir")
		
	
	
