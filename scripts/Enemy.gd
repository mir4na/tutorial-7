extends CharacterBody3D

@export var move_speed: float = 3.5
@export var chase_speed: float = 5.5
@export var attack_range: float = 15.0
@export var chase_range: float = 15.0
@export var leash_range: float = 20.0
@export var attack_cooldown: float = 4.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var roam_timer: Timer = $RoamTimer
@onready var attack_timer: Timer = $AttackTimer

var player: Node3D = null
var phase: int = 0
var bullet_scene = preload("res://scenes/EnemyBullet.tscn")

func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")
	randomize()
	_pick_random_roam_target()
	roam_timer.start(randf_range(3.0, 6.0))

func _physics_process(delta):
	if player == null:
		return

	var dist = global_position.distance_to(player.global_position)

	if dist <= chase_range:
		phase = 1
		nav_agent.target_position = player.global_position
		if attack_timer.is_stopped():
			attack_timer.start(attack_cooldown)
	elif dist > leash_range and phase == 1:
		phase = 0
		attack_timer.stop()
		_pick_random_roam_target()

	var current_speed = chase_speed if phase == 1 else move_speed

	if not nav_agent.is_navigation_finished():
		var next = nav_agent.get_next_path_position()
		var dir = global_position.direction_to(next)
		dir.y = 0.0
		velocity = dir * current_speed
	else:
		velocity = Vector3.ZERO

	move_and_slide()

	if phase == 1:
		var look_dir = (player.global_position - global_position)
		look_dir.y = 0.0
		if look_dir.length() > 0.1:
			look_at(global_position + look_dir, Vector3.UP)

func _pick_random_roam_target():
	var rx = randf_range(-12, 12)
	var rz = randf_range(-12, 12)
	nav_agent.target_position = Vector3(rx, global_position.y, rz)

func _on_roam_timer_timeout():
	if phase == 0:
		_pick_random_roam_target()
	roam_timer.start(randf_range(3.0, 6.0))

func _on_attack_timer_timeout():
	if player == null:
		return
	var dist = global_position.distance_to(player.global_position)
	if dist <= attack_range:
		_fire_at_player()
		attack_timer.start(attack_cooldown)

func _fire_at_player():
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.global_position = global_position + Vector3(0, 1.0, 0)
	var dir = (player.global_position + Vector3(0, 1.0, 0) - b.global_position).normalized()
	b.direction = dir

func die():
	LevelManager.enemy_died()
	queue_free()
