extends Node

var tasks_completed: int = 0

signal task_completed(task_index: int)
signal all_tasks_complete
signal boss_spawned

func complete_task(task_index: int):
	if task_index > tasks_completed:
		return
	tasks_completed = task_index + 1
	emit_signal("task_completed", task_index)
	if tasks_completed >= 3:
		emit_signal("all_tasks_complete")
		emit_signal("boss_spawned")

func reset():
	tasks_completed = 0
