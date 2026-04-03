extends CanvasLayer

@onready var move_label: Label = $Panel/VBox/MoveLabel

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.movement_state_changed.connect(_on_movement_state_changed)

func _on_movement_state_changed(state: String):
	move_label.text = "Movement: " + state
