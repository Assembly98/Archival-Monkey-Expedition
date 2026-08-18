extends RigidBody3D

@export var rotationSpd := 15.0

var moveDir := Vector3.ZERO
var lastStrongDir := Vector3.FORWARD
var localGravity := Vector3.DOWN
var shouldReset := false

@onready var camController
@onready var anim = $monkey/AnimationPlayer
@onready var startPos = global_transform.origin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	
	if shouldReset:
		state.transform.origin = startPos
		shouldReset = false
	
	localGravity = state.total_gravity.normalized()
	
	if moveDir.length() > 0.2:
		lastStrongDir = moveDir.normalized()
	moveDir = getModelOrientationInput()
	orientDirTo(lastStrongDir, state.step)
	
	var dir = $Node3D.basis * Vector3(moveDir.x, 0, moveDir.y)
	dir.y = 0.0
	dir.normalized()
	
	if isJumping(state):
		anim.play("jump")
		apply_central_impulse(-localGravity * 20)
	if is_on_floor(state):
		pass
	
	
	if linear_velocity.length() < 10 and moveDir:
		linear_velocity += (dir * 10)
	#else:
		#linear_velocity = Vector3.ZERO
	
	if moveDir:
		anim.play("run")
	else:
		anim.play("Idle")
	
	#$monkey.velocity = linear_velocity
		
func getModelOrientationInput():
	var inputLR := (
		Input.get_action_strength("Left")
		- Input.get_action_strength("Right")
	)
	
	var inputFwd := (
		Input.get_action_strength("Forward")
		- Input.get_action_strength("Backwards")
	)
	
	
	var rawInput = Vector2(inputLR, inputFwd)
	
	var input := Vector3.FORWARD
	
	input.x = rawInput.x * sqrt(1.0 - rawInput.y * rawInput.y/2.0)
	input.z = rawInput.y * sqrt(1.0 - rawInput.x * rawInput.x/2.0)
	
	input = input * $monkey.transform.basis
	return input

func orientDirTo(dir : Vector3, delta : float):
	var leftAxis := -localGravity.cross(dir)
	var rotBasis := Basis(leftAxis, -localGravity, dir).orthonormalized()
	transform.basis = Basis(transform.basis.get_rotation_quaternion().slerp(rotBasis, delta * rotationSpd))
	
func isJumping(state : PhysicsDirectBodyState3D):
	if is_on_floor(state) and Input.is_action_just_pressed("ui_accept"):
		return true
	return false

func is_on_floor(state : PhysicsDirectBodyState3D):
	for contact in state.get_contact_count():
		var contactNormal = state.get_contact_local_normal(contact)
		if contactNormal.dot(-localGravity) > 0.5:
			#anim.play("run")
			return true
	return false
