extends StaticBody3D

func _on_static_body_3d_body_entered(body: Node3D) -> void:
	if body.name == "rbMonkey":
		body.setPlanetName(name)


func _on_static_body_3d_body_exited(body: Node3D) -> void:
	if body.name == "rbMonkey":
		body.setPlanetName("planetoidTestRoom")
