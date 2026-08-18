extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	var y_velocity := velocity.y
	velocity.y = 0
	
	velocity.y = y_velocity + ((-50)) * delta
		
	move_and_slide()
