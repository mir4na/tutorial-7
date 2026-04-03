extends Interactable

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

@export var open_on_key: bool = false
@export var required_key: String = "Exit Key"
var is_open: bool = false

func _ready():
	prompt_text = "Press E to open Door"

func interact():
	if is_open:
		return
	if open_on_key:
		if InventoryManager.slots[InventoryManager.selected_slot] == required_key:
			InventoryManager.consume_selected()
			_open_door()
	else:
		if LevelManager.tasks_completed >= 3:
			_open_door()

func _open_door():
	is_open = true
	prompt_text = ""
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector3(0, 25.0, 0), 2.5)
