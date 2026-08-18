extends Area3D

var monkey = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$glider.rotation_degrees.y += 0.5


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Monkey":
		Global.propellor = true
		queue_free()
		
