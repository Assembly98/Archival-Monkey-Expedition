extends Node3D

var newSection = false
@onready var lastCam = $Monkey/Node3D/SpringArm3D/Camera3D
@onready var camera_3d: Camera3D = $Camera3D
@onready var newCam2: Node3D = $camPos2
@onready var newCam1: Node3D = $camPos1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	$launchZone/Path3D/PathFollow3D.progress_ratio = Global.pathProgess
	
	Global.playerFlyingPos = $launchZone/Path3D/PathFollow3D/Node3D.global_position
	Global.playerFlyingRot = $launchZone/Path3D/PathFollow3D/Node3D.global_rotation
	
	
	
	
	if $enemyGroup.get_child_count() == 0 and newSection == false:
		$Cube_001.visible = true
		if $Cube_001.position.x < 120:
			camera_3d.current = true
			print(camera_3d.global_position)
			camera_3d.global_position = camera_3d.global_position.move_toward(newCam1.global_position, 350*delta)
			camera_3d.global_rotation = camera_3d.global_rotation.move_toward(newCam1.global_rotation, 10*delta)
			if camera_3d.global_position == newCam1.global_position:
				$Cube_001.position.x += 0.25
		else:
			
			newSection = true
			await get_tree().create_timer(2).timeout
			camera_3d.current = false
			
	if not camera_3d.current:
		$Camera3D.global_position = lastCam.global_position
		$Camera3D.global_rotation = lastCam.global_rotation	
		
	if Global.pagesCollected == 5:
		$treeStairs.visible = true
		if $treeStairs.position.y < 14:
			$treeStairs.position.y += 0.1
			camera_3d.current = true
			camera_3d.global_position = camera_3d.global_position.move_toward(newCam2.global_position, 250 * delta)
			camera_3d.global_rotation = camera_3d.global_rotation.move_toward(newCam2.global_rotation, 40 * delta)
		else:
			Global.pagesCollected = 0
			camera_3d.current = false
			
