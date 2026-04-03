extends CharacterBody3D

@export var move_speed: float = 3.5
@export var chase_speed: float = 5.5
@export var attack_range: float = 12.0
@export var shoot_distance: float = 8.0
@export var chase_range: float = 12.0
@export var leash_range: float = 18.0
@export var attack_cooldown: float = 4.0

@onready var roam_timer: Timer = $RoamTimer
@onready var attack_timer: Timer = $AttackTimer

var player: Node3D = null
var phase: int = 0
var roam_direction: Vector3 = Vector3.ZERO
var bullet_scene = preload("res://scenes/EnemyBullet.tscn")
var gravity: float = 9.8

var max_hp: int = 3
var hp: int = 3

func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")
	_pick_random_direction()
	roam_timer.start(randf_range(2.5, 5.0))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player == null:
		move_and_slide()
		return

	var dist = global_position.distance_to(player.global_position)

	if dist <= chase_range:
		if phase == 0:
			phase = 1
			if attack_timer.is_stopped():
				attack_timer.start(attack_cooldown)
	elif dist > leash_range and phase == 1:
		phase = 0
		attack_timer.stop()
		_pick_random_direction()

	if phase == 0:
		velocity.x = roam_direction.x * move_speed
		velocity.z = roam_direction.z * move_speed
	else:
		var dir = (player.global_position - global_position)
		dir.y = 0.0
		if dist > shoot_distance:
			if dir.length() > 0.1:
				dir = dir.normalized()
			velocity.x = dir.x * chase_speed
			velocity.z = dir.z * chase_speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0

		var look_dir = Vector3(player.global_position.x - global_position.x, 0, player.global_position.z - global_position.z)
		if look_dir.length() > 0.1:
			look_at(global_position + look_dir, Vector3.UP)

	move_and_slide()

	if phase == 0 and was_colliding():
		roam_direction = -roam_direction.rotated(Vector3.UP, randf_range(0.5, 1.5))

func was_colliding() -> bool:
	return get_slide_collision_count() > 0

func _pick_random_direction():
	var angle = randf_range(0, TAU)
	roam_direction = Vector3(cos(angle), 0, sin(angle))

func _on_roam_timer_timeout():
	if phase == 0:
		_pick_random_direction()
	roam_timer.start(randf_range(2.5, 5.0))

func _on_attack_timer_timeout():
	if player == null:
		return
	var dist = global_position.distance_to(player.global_position)
	if dist <= attack_range:
		_fire_at_player()
	if phase == 1:
		attack_timer.start(attack_cooldown)

func _fire_at_player():
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.global_position = global_position + Vector3(0, 1.0, 0)
	var dir = (player.global_position + Vector3(0, 1.0, 0) - b.global_position).normalized()
	b.direction = dir

func take_damage(amount: int):
	hp -= amount
	var ratio = float(hp) / float(max_hp)
	if has_node("HPBarCenter/HPFg"):
		var fg = get_node("HPBarCenter/HPFg")
		fg.scale.x = max(0.01, ratio)
	
	if hp <= 0:
		die()

func die():
	LevelManager.enemy_died()
	queue_free()
