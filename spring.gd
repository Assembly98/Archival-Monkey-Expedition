extends Area3D

var monkeyDetected : bool = false
var monkey = null
@export var springStrength : float = 50

func _physics_process(delta: float) -> void:
	$spring/AnimationPlayer.speed_scale = 3.5
	if monkeyDetected and monkey != null:
		monkey.velocity.y = springStrength
		monkey.anim.play("springJump")
		$spring/AnimationPlayer.play("bounce")


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Monkey":
		monkeyDetected = true
		monkey = body


func _on_body_exited(body: Node3D) -> void:
	if body.name == "Monkey":
		monkeyDetected = false
		monkey = null
