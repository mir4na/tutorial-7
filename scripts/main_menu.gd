extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_button_pressed():
	if has_node("/root/LevelManager"): get_node("/root/LevelManager").reset()
	if has_node("/root/InventoryManager"): get_node("/root/InventoryManager").reset()
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
