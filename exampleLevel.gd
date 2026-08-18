extends Node3D

@onready var bridgeMesh = $MeshInstance3D
@onready var bridgeCol = $StaticBody3D/CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	Global.keyCoinGoal = $coinContainer.get_child_count()
	bridgeCol.disabled = true
	bridgeMesh.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if Global.currentKeyCoins == Global.keyCoinGoal:
		bridgeCol.disabled = false
		if not $AnimationPlayer.animation_finished:
			$AnimationPlayer.play("bridgeUnlocked")

func _physics_process(delta: float) -> void:
	$launchZone/Path3D/PathFollow3D.progress_ratio = Global.pathProgess
	
	Global.playerFlyingPos = $launchZone/Path3D/PathFollow3D/Node3D.global_position
	Global.playerFlyingRot = $launchZone/Path3D/PathFollow3D/Node3D.global_rotation
