extends Interactable

class_name PickableItem

@export var item_name: String = "Item"
@export var is_key: bool = false
@export var is_gun: bool = false

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

func _ready():
	var mat = mesh_instance.mesh.material
	if is_key:
		prompt_text = "Press E to claim Key Card"
	elif is_gun:
		prompt_text = "Press E to claim Gun"
	else:
		prompt_text = "Press E to pick up " + item_name

func interact():
	var collected = false
	if is_gun:
		collected = InventoryManager.pickup("Gun")
		if collected: LevelManager.obtain_gun()
	elif is_key:
		collected = InventoryManager.pickup("Key Card")
	else:
		collected = InventoryManager.pickup(item_name)
		
	if not collected:
		return

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position + Vector3(0, 1.5, 0), 0.4)
	tween.tween_property(self, "rotation_degrees", rotation_degrees + Vector3(0, 360, 0), 0.4)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.4)
	await tween.finished
	queue_free()
