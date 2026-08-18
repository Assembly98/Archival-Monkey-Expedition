extends CharacterBody3D

@onready var anim = $"enemyTempModel/AnimationPlayer"

var player = null

var playerDetected : bool = false
var canAttack : bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	
	move_and_slide()

func isHit():
	anim.speed_scale = 2.9
	anim.play("hit")
	await anim.animation_finished
	queue_free()


func _on_player_detection_body_entered(body: Node3D) -> void:
	if body.name == "Monkey":
		player = body
		playerDetected = true
		print("pdTrue")


func _on_player_detection_body_exited(body: Node3D) -> void:
	if body.name == "Monkey":
		#player = null
		playerDetected = false
		print("pdFalse")


func _on_attack_range_body_entered(body: Node3D) -> void:
	if body.name == "Monkey":
		player = body
		canAttack = true


func _on_attack_range_body_exited(body: Node3D) -> void:
	if body.name == "Monkey":
		#player = null
		canAttack = false
