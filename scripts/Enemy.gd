extends CharacterBody3D

@export var move_speed: float = 3.5
@export var attack_range: float = 15.0
@export var attack_cooldown: float = 4.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var roam_timer: Timer = $RoamTimer
@onready var attack_timer: Timer = $AttackTimer

var player: Node3D = null

func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")
	randomize()
	_pick_random_roam_target()

func _physics_process(delta):
	# Movement logic
	if not nav_agent.is_navigation_finished():
		var next_path_pos = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(next_path_pos)
		direction.y = 0
		velocity = direction * move_speed
		move_and_slide()
		
	# Combat logic
	if player:
		var dist = global_position.distance_to(player.global_position)
		if dist <= attack_range:
			if attack_timer.is_stopped():
				attack_timer.start(attack_cooldown)
		else:
			if not attack_timer.is_stopped():
				attack_timer.stop()

func _pick_random_roam_target():
	# Roughly pick a random spot in the maze (Level 2 is roughly within -20 to 20 X/Z)
	var random_x = randf_range(-15, 15)
	var random_z = randf_range(-15, 15)
	nav_agent.target_position = Vector3(random_x, 0, random_z)
	roam_timer.start(randf_range(3.0, 6.0))

func _on_roam_timer_timeout():
	_pick_random_roam_target()

func _on_attack_timer_timeout():
	if player:
		# Double check range on timeout
		if global_position.distance_to(player.global_position) <= attack_range:
			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(global_position + Vector3(0,1,0), player.global_position + Vector3(0,1,0))
			var result = space_state.intersect_ray(query)
			if result and result.collider == player:
				# Enemy shot player
				get_tree().change_scene_to_file("res://scenes/lose_screen_l2.tscn")

func die():
	LevelManager.enemy_died()
	queue_free()
