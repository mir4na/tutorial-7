extends Node

var item_count: int = 0
var has_key: bool = false

signal item_collected(item_name: String)
signal key_collected

func add_item(item_name: String):
	item_count += 1
	emit_signal("item_collected", item_name)

func collect_key():
	has_key = true
	emit_signal("key_collected")

func reset():
	item_count = 0
	has_key = false
