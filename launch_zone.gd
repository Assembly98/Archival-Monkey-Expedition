extends Area3D

@onready var anim = $starLauncher/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.inLaunchZone:
		Global.launchZonePos = position
		Global.launchZoneRot = rotation
		
	if Global.inLaunchZone == true:
		if Input.is_action_just_pressed("action"):
			anim.speed_scale = 1.5
			anim.play("windup")
	
	if anim.current_animation == "Idle":
		anim.speed_scale = 1
	else:
		anim.speed_scale = 1.5


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Monkey":
		Global.inLaunchZone = true


func _on_body_exited(body: Node3D) -> void:
	if body.name == "Monkey":
		Global.inLaunchZone = false
