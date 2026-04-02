extends CharacterBody3D

@export var speed: float = 10.0
@export var sprint_speed: float = 18.0
@export var crouch_speed: float = 4.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3
@export var normal_height: float = 1.0
@export var crouch_height: float = 0.4

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var camera_x_rotation: float = 0.0
var is_crouching: bool = false
var is_sprinting: bool = false

signal movement_state_changed(state: String)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation

func _physics_process(delta):
	var movement_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	var wants_crouch = Input.is_action_pressed("crouch")
	var wants_sprint = Input.is_action_pressed("sprint") and not wants_crouch

	if wants_crouch and not is_crouching:
		is_crouching = true
		is_sprinting = false
		collision_shape.shape.height = crouch_height
		head.position.y = 0.0
		emit_signal("movement_state_changed", "CROUCH")
	elif not wants_crouch and is_crouching:
		is_crouching = false
		collision_shape.shape.height = normal_height * 2.0
		head.position.y = 0.5
		emit_signal("movement_state_changed", "WALK")

	if wants_sprint and not is_crouching:
		if not is_sprinting:
			is_sprinting = true
			emit_signal("movement_state_changed", "SPRINT")
	elif is_sprinting and not wants_sprint:
		is_sprinting = false
		emit_signal("movement_state_changed", "WALK")

	var current_speed: float
	if is_crouching:
		current_speed = crouch_speed
	elif is_sprinting:
		current_speed = sprint_speed
	else:
		current_speed = speed

	velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_crouching:
		velocity.y = jump_power

	move_and_slide()
