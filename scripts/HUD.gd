extends CanvasLayer

@onready var obj_label: Label = $Panel/VBox/ObjLabel
@onready var move_label: Label = $Panel/VBox/MoveLabel
@onready var controls_label: Label = $Panel/VBox/ControlsLabel

func _ready():
	LevelManager.ui_updated.connect(_refresh)
	InventoryManager.inventory_changed.connect(_refresh)

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.movement_state_changed.connect(_on_movement_state_changed)

	_refresh()

func _refresh():
	if not LevelManager.key_collected_l2:
		obj_label.text = "1. Find the Key Card\n2. Unlock the Gun Room\n3. Kill all enemies (0/3)"
	elif not LevelManager.has_gun:
		obj_label.text = "✓ Key Card found!\n2. Pick up the Gun\n3. Kill all enemies (0/3)"
	else:
		var k = LevelManager.enemies_killed
		obj_label.text = "✓ Key Card found!\n✓ Gun equipped!\n3. Kill all enemies (%d/3)" % k

func _on_movement_state_changed(state: String):
	move_label.text = "Movement: " + state
