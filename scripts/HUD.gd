extends CanvasLayer

@onready var objective_label: Label = $Panel/VBox/TitleLabel
@onready var move_label: Label = $Panel/VBox/MoveLabel

func _ready():
	LevelManager.ui_updated.connect(_refresh_tasks)

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.movement_state_changed.connect(_on_movement_state_changed)

	_refresh_tasks()

func _refresh_tasks():
	if not LevelManager.has_gun:
		objective_label.text = "Objective: Find a weapon."
	else:
		objective_label.text = "Status: Hunt the Targets (%d / 3)" % LevelManager.enemies_killed

func _on_movement_state_changed(state: String):
	move_label.text = "Movement: " + state
