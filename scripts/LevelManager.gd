extends Node

var tasks_completed: int = 0
var has_gun: bool = false
var enemies_killed: int = 0
var key_collected_l2: bool = false

signal task_completed(task_index: int)
signal all_tasks_complete
signal boss_spawned
signal ui_updated
signal show_prompt(text: String)
signal hide_prompt

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
	has_gun = false
	enemies_killed = 0
	key_collected_l2 = false
	emit_signal("ui_updated")

func obtain_gun():
	has_gun = true
	emit_signal("ui_updated")

func collect_key_l2():
	key_collected_l2 = true
	emit_signal("ui_updated")

func enemy_died():
	enemies_killed += 1
	emit_signal("ui_updated")
	if enemies_killed >= 3:
		get_tree().change_scene_to_file.call_deferred("res://scenes/level_2_win.tscn")
