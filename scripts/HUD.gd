extends CanvasLayer

@onready var task1_label: Label = $Panel/VBox/Task1Label
@onready var task2_label: Label = $Panel/VBox/Task2Label
@onready var task3_label: Label = $Panel/VBox/Task3Label
@onready var items_label: Label = $Panel/VBox/ItemsLabel
@onready var key_label: Label = $Panel/VBox/KeyLabel
@onready var move_label: Label = $Panel/VBox/MoveLabel
@onready var boss_warning: Label = $BossWarning

func _ready():
	LevelManager.task_completed.connect(_on_task_completed)
	LevelManager.boss_spawned.connect(_on_boss_spawned)
	InventoryManager.item_collected.connect(_on_item_collected)
	InventoryManager.key_collected.connect(_on_key_collected)

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.movement_state_changed.connect(_on_movement_state_changed)

	boss_warning.visible = false
	_refresh_tasks()

func _refresh_tasks():
	var done = LevelManager.tasks_completed
	task1_label.text = ("[x] " if done > 0 else "[ ] ") + "Collect 3 items"
	task2_label.text = ("[x] " if done > 1 else "[ ] ") + "Activate terminal"
	task3_label.text = ("[x] " if done > 2 else "[ ] ") + "Grab the exit key"
	items_label.text = "Items: %d / 3" % InventoryManager.item_count
	key_label.text = "Key: " + ("YES" if InventoryManager.has_key else "NO")

func _on_task_completed(_task_index: int):
	_refresh_tasks()

func _on_boss_spawned():
	boss_warning.visible = true

func _on_item_collected(_item_name: String):
	items_label.text = "Items: %d / 3" % InventoryManager.item_count

func _on_key_collected():
	key_label.text = "Key: YES"

func _on_movement_state_changed(state: String):
	move_label.text = "Movement: " + state
