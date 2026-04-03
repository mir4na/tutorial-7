extends CharacterBody3D

@export var speed: float = 7.5
@export var sprint_speed: float = 10.0
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
		# Shift player up so the capsule expansion doesn't clip into the floor
		position.y += (normal_height * 2.0 - crouch_height) / 2.0
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

	# Shooting Logic
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and LevelManager.has_gun:
		# Use a rudimentary cooldown trick by requiring just_pressed, wait, is_mouse_button_pressed does continuous fire.
		# Let's use InputEvent in _input for shooting or just Input.is_action_just_pressed if we mapped it.
		# We didn't map "shoot", so let's handle it manually or just use a flag.
		pass

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1: InventoryManager.select_slot(0)
		elif event.keycode == KEY_2: InventoryManager.select_slot(1)
		elif event.keycode == KEY_3: InventoryManager.select_slot(2)

	if event is InputEventMouseButton:
		var has_g = InventoryManager.slots[InventoryManager.selected_slot] == "Gun"
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and has_g:
			_shoot()

func _shoot():
	var space_state = get_world_3d().direct_space_state
	# Cast from camera center straight forward
	var from = camera.global_position
	var to = from - camera.global_transform.basis.z * 100.0
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result and result.collider.is_in_group("enemy"):
		if result.collider.has_method("die"):
			result.collider.die()
