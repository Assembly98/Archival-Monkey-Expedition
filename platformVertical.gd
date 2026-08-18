extends CharacterBody3D


var isMoving = false
@export var spawnTimer : Timer
@export var delayTime : float

func _ready() -> void:
	$startTimer.start(delayTime)

func _physics_process(delta: float) -> void:
	
	
	if isMoving:
		position.y += 0.35
	else:
		velocity.y = 0
	
	#velocity.x = 0
	#velocity.y = 0
	#print("speed: ", velocity.y)


func _on_delete_timer_timeout() -> void:
	queue_free()


func _on_distance_timer_timeout() -> void:
	isMoving = false
	$deleteTimer.start()


func _on_start_timer_timeout() -> void:
	isMoving = true
	$distanceTimer.start()
