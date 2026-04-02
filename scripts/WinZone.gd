extends Area3D

var triggered: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	if triggered:
		return
	if body.is_in_group("player"):
		triggered = true
		get_tree().change_scene_to_file("res://scenes/level_2_win.tscn")
