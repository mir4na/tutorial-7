extends Area3D

@export var speed: float = 25.0
var direction: Vector3 = Vector3.FORWARD

func _ready():
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(4.0).timeout.connect(queue_free)

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
		get_tree().change_scene_to_file.call_deferred("res://scenes/lose_screen_l2.tscn")
	elif not body.is_in_group("enemy"):
		queue_free()
