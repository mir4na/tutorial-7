extends Interactable

class_name PickableItem

@export var item_name: String = "Item"
@export var is_key: bool = false

func interact():
	if is_key:
		InventoryManager.collect_key()
		LevelManager.complete_task(2)
	else:
		InventoryManager.add_item(item_name)
		if InventoryManager.item_count >= 3 and LevelManager.tasks_completed == 0:
			LevelManager.complete_task(0)

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position + Vector3(0, 1.5, 0), 0.4)
	tween.tween_property(self, "rotation_degrees", rotation_degrees + Vector3(0, 360, 0), 0.4)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.4)
	await tween.finished
	queue_free()

