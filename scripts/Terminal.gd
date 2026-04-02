extends Interactable

@export var task_index: int = 1

var activated: bool = false

func interact():
	if activated:
		return
	activated = true
	LevelManager.complete_task(task_index)
