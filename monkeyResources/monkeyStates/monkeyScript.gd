extends CharacterBody3D

@export var respawnPoint : Node3D


@onready var _camera_pivot = $Node3D
@onready var camera_3d : Camera3D = %Camera3D
@onready var anim = $monkey/AnimationPlayer
@onready var ray = $RayCast3D
@onready var floorRay = $floorDetection
@onready var center = $"../Area3D"
@onready var jumpTimer = $jumpTimer
@onready var step_cast: ShapeCast3D = $stepCast
@onready var eyeController = $"../../monkey/eyecontrol"
@onready var spine_015: BoneAttachment3D = $monkey/metarig/Skeleton3D/spine_015
@onready var spine_016: BoneAttachment3D = $monkey/metarig/Skeleton3D/spine_016
@onready var spine_018: BoneAttachment3D = $monkey/metarig/Skeleton3D/spine_018
@onready var spine_019: BoneAttachment3D = $monkey/metarig/Skeleton3D/spine_019


var jumpVel := [20, 25, 35]
var jumps = 0
var storedVelocity : float

var randStrength : float = 10
var shakeFade : float = 15
var rng = RandomNumberGenerator.new()
var shakeStrength : float = 0.0
var grounded : bool = false

var speed : float = 150
const jumpForce : float = 25.0

var lastMoveDir := Vector3.BACK
var sPlant = false
var groundNormal : Vector3
var xForm : Transform3D
@onready var planet = $"../Area3D/CollisionShape3D"
@onready var timer = $jumpTimer
#@onready var cube = $"monkey/metarig/Skeleton3D/Cube"
@onready var headShader = $"monkey/metarig/Skeleton3D/Cube".get_surface_override_material(0)
var eyeTextPos = [0,-0.51]
var mouthTextPos = [0, -0.17, -0.34, -0.508, -0.675, -0.85]
var eyebrowsTextPos = [0]
var textTracker = 0

@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
var _camera_input_direction := Vector2.ZERO
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 6.0
@export var speedCurve : Curve
@export var curve : float
var cameraBool : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion
	)
	if is_camera_motion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_camera_input_direction = event.screen_relative * mouse_sensitivity


func _ready() -> void:
	_camera_pivot.top_level = true

func  _physics_process(delta: float) -> void:
	if textTracker > 350:
		headShader.set_shader_parameter("eyeUVX", eyeTextPos[1])
	else:
		headShader.set_shader_parameter("eyeUVX", eyeTextPos[0])
		
		
	textTracker += 1
	textTracker = wrapi(textTracker, 0, 375)
	
	
	if Global.propellor == true:
		$monkey/metarig/Skeleton3D/BoneAttachment3D/glider.visible = true
	else:
		$monkey/metarig/Skeleton3D/BoneAttachment3D/glider.visible = false

	print("repawning", Global.respawning)
	
	if not Global.respawning2:
		_camera_pivot.position = position
		$monkey/eyecontrol.scale = Vector3.ONE
	else:
		_camera_pivot.position = _camera_pivot.position
		anim.speed_scale = 1
		velocity.y = -35
		anim.play("fallingDown")
		$monkey/eyecontrol.scale = 1.50 * Vector3.ONE
		headShader.set_shader_parameter("mouthUVX", -0.51)
	#floorRay.position = position
	
	var cameraInput = Input.get_vector("cL", "cR", "cF", "cB")
	
	if cameraInput.length() > 0.2:
		_camera_pivot.rotate_y(deg_to_rad(-cameraInput.x * 1.7))
		$Node3D/SpringArm3D.rotate_x(deg_to_rad(cameraInput.y * 1.7))
		$Node3D/SpringArm3D.rotation.x = clamp($Node3D/SpringArm3D.rotation.x, deg_to_rad(-80), deg_to_rad(30))
	
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	#print("MouseMouse: ", Input.get_mouse_mode())
	#print("CurrentMouseMouse: ", Input.MOUSE_MODE_CAPTURED)
	
	#print("jumpTime: ", timer.time_left)

	
	move_and_snap(delta)

func respawn():
	Global.respawning2 = false
	Global.respawning = false
	position = respawnPoint.position

func move_and_snap(delta : float) -> void:
	step_cast.global_position.x = global_position.x + velocity.x * delta
	step_cast.global_position.z = global_position.z + velocity.z * delta
	
	
	step_cast.force_shapecast_update()
	
	move_and_slide()


func isGrounded():
	return is_on_floor() or grounded

func applyShake():
	shakeStrength = randStrength
	
func randOffset():
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))

func isOnWall():
	return ray.is_colliding()
func canWallSlide():
	if not floorRay.is_colliding() or Input.is_action_just_released("jump"):
		return true
	return false

func isHit():
	Global.playerHit = true
	
func end():
	Global.playerLvEnd = true
	
	
