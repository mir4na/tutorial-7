extends Area3D

@export var sceneName := "Level 1"

func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file.call_deferred("res://scenes/" + sceneName + ".tscn")
