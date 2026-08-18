extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Plane.rotation_degrees.y += 1


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Monkey":
		Global.pagesCollected += 1
		queue_free()
