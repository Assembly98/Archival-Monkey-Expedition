extends Node3D

var timerOn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(get_child_count())
	if get_child_count() == 1 and timerOn == false:
		#await get_tree().create_timer(1).timeout
		$Timer.start()
		timerOn = true

func _on_timer_timeout() -> void:
	
	add_child.call_deferred(load("res://movingPlatformVertical.tscn").instantiate())
	timerOn = false
