extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$launchZone/Path3D/PathFollow3D.progress_ratio = Global.pathProgess
	
	Global.playerFlyingPos = $launchZone/Path3D/PathFollow3D/Node3D.global_position
	Global.playerFlyingRot = $launchZone/Path3D/PathFollow3D.rotation
	if Global.inLaunchZone:
		Global.launchZonePos = $Area3D.position

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Monkey":
		Global.inLaunchZone = true



func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Monkey":
		Global.inLaunchZone = false
