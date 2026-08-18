extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.keyCoinGoal = $coinContainer.get_child_count()

func _process(delta: float) -> void:
	if Global.currentKeyCoins == Global.keyCoinGoal:
		$AnimationPlayer.play("wallDown")
		await $AnimationPlayer.animation_finished
		Global.currentKeyCoins += 1

func _physics_process(delta: float) -> void:
	$launchZone/Path3D/PathFollow3D.progress_ratio = Global.pathProgess
	
	Global.playerFlyingPos = $launchZone/Path3D/PathFollow3D/Node3D.global_position
	Global.playerFlyingRot = $launchZone/Path3D/PathFollow3D/Node3D.global_rotation


func _on_area_3d_area_entered(area: Area3D) -> void:
	pass # Replace with function body.
