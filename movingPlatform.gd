extends CharacterBody3D


var isMoving = false
@export var delayTime : float
@export var distanceTime : float
@export var direction : Vector3
@export var spd : float = 0.1

func _ready() -> void:
	$startTimer.start(delayTime)

func _physics_process(delta: float) -> void:
	
	
	if isMoving:
		position += direction * spd
	else:
		velocity = Vector3.ZERO
	
	#velocity.x = 0
	#velocity.y = 0

func _on_distance_timer_timeout() -> void:
	isMoving = false
	spd *= -1
	$startTimer.start(delayTime)


func _on_start_timer_timeout() -> void:
	isMoving = true
	$distanceTimer.start(distanceTime)
