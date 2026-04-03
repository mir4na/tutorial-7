extends Area3D

@export var speed: float = 30.0
var direction: Vector3 = Vector3.FORWARD

func _ready():
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		return
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(1)
	queue_free()
