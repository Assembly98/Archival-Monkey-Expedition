extends Node3D

@onready var newCam: Node3D = $lectern/newCamPos
@onready var newCam2: Node3D = $lectern/newCamPos2
@onready var bookAnim = $lectern/bookUsable/AnimationPlayer
@onready var camera_3d: Camera3D = $Camera3D
@onready var lastCam = $Monkey/Node3D/SpringArm3D/Camera3D
@onready var monkey: CharacterBody3D = $Monkey
@onready var lectern: Node3D = $lectern


var camBool = false
var bookBool = false


func _physics_process(delta: float) -> void:
	
	
	if Global.inSelection and camBool == false:
		camera_3d.global_position = lastCam.global_position
		camera_3d.rotation = lastCam.global_rotation
		camBool = true
		camera_3d.current = true
	
	if Global.inSelection and camBool == true:
		camera_3d.global_position = camera_3d.global_position.move_toward(newCam.global_position, 10 * delta)
		camera_3d.global_rotation = camera_3d.global_rotation.move_toward(newCam.global_rotation, 3.5 * delta)
	
	#print(monkey.rotation_degrees.dot(lectern.rotation_degrees))
	#print(camera_3d.rotation.dot(newCam2.rotation))
	
	if Global.inSelection:
		monkey.look_at(lectern.global_position)
		monkey.global_position.x = move_toward(monkey.global_position.x, lectern.global_position.x, 35 * delta)
		#if not round(monkey.global_position.x) <= round(lectern.global_position.x):
			#monkey.rotation_degrees = monkey.rotation_degrees.move_toward(lectern.rotation_degrees, -250 * delta)
			#monkey.global_position.x = move_toward(monkey.global_position.x, lectern.global_position.x, 35 * delta)
			#monkey.global_position.z = move_toward(monkey.global_position.z, lectern.global_position.z-0.9, 35 * delta)
	
	if Global.jumpIn == true:
		Global.jumpIn = false
		await get_tree().create_timer(1).timeout
		bookAnim.speed_scale = 1.4
		bookAnim.play("hit")
		
	
	if Global.selected == true:
		camera_3d.global_position = camera_3d.global_position.move_toward(newCam2.global_position, 14 * delta)
		camera_3d.global_rotation = camera_3d.global_rotation.move_toward(newCam2.global_rotation, 7 * delta)
	
		if camera_3d.rotation.dot(newCam2.rotation) > 10.3:
			bookAnim.speed_scale = 0.5
			if bookBool == false:
				bookAnim.speed_scale = 1
				bookAnim.play("close")
				bookBool = true
			await get_tree().create_timer(3).timeout
			Global.animFinsihed = true
		
	if Global.inSelection == false:
		camera_3d.global_position = camera_3d.global_position.move_toward(lastCam.global_position, 45 * delta)
		camera_3d.global_rotation = camera_3d.global_rotation.move_toward(lastCam.global_rotation, 12 * delta)
	if camera_3d.global_position == lastCam.global_position and camera_3d.global_rotation == lastCam.global_rotation:
		camera_3d.current = false
		camBool = false
		
