extends CharacterBody3D

@export var speed: float = 6.0
@export var gravity: float = 9.8

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var player: Node3D = null
var active: bool = false

func _ready():
	visible = false
	set_physics_process(false)
	LevelManager.boss_spawned.connect(_on_boss_spawned)

func _on_boss_spawned():
	visible = true
	active = true
	set_physics_process(true)
	call_deferred("_find_player")

func _find_player():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if not active or player == null:
		return

	nav_agent.target_position = player.global_position

	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	direction.y = 0.0

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	move_and_slide()

	if global_position.distance_to(player.global_position) < 1.2:
		_catch_player()

func _catch_player():
	active = false
	get_tree().change_scene_to_file("res://scenes/lose_screen_l2.tscn")
