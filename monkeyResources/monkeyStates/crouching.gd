extends State
class_name crouching

@onready var anim = $"../../monkey/AnimationPlayer"
@export var playerVars : CharacterBody3D

func update(delta : float) -> void:
	anim.play("crouching")
	
	var moveInput = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (playerVars._camera_pivot.basis * Vector3(moveInput.x, 0, moveInput.y))
	direction.y = 0.0
	direction = direction.normalized()
	if direction or playerVars.velocity.length() > 0:
		transition.emit(self, "crouchMove")
	
	if Input.is_action_just_pressed("jump"):
		direction = (Vector3(-sin(playerVars.rotation.y), 0, -cos(playerVars.rotation.y)))
		playerVars.velocity.y += 30
		playerVars.velocity -= direction * 10
		anim.speed_scale = 1
		anim.play("backflipintro")
		transition.emit(self, "backFlipping")
	
	if Input.is_action_just_released("backButton"):
		transition.emit(self, "Idle")
	print("crouching")
	
	if Global.playerHit:
		transition.emit(self, "isHit")
