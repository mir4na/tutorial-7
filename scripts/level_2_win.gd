extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_main_menu_pressed():
	# Reset singletons if necessary so next playthrough is fresh
	if has_node("/root/LevelManager"):
		get_node("/root/LevelManager").reset()
	if has_node("/root/InventoryManager"):
		get_node("/root/InventoryManager").reset()
		
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
