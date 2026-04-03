extends Node

var item_count: int = 0

var slots: Array = ["", "", ""]
var selected_slot: int = 0

signal ui_updated
signal inventory_changed

func reset():
	item_count = 0
	slots = ["", "", ""]
	selected_slot = 0
	emit_signal("inventory_changed")
	emit_signal("ui_updated")

func select_slot(index: int):
	selected_slot = index
	emit_signal("inventory_changed")

func pickup(item_name: String) -> bool:
	for i in range(slots.size()):
		if slots[i] == "":
			slots[i] = item_name
			item_count += 1
			emit_signal("inventory_changed")
			return true
	return false

func consume_selected() -> String:
	var item = slots[selected_slot]
	slots[selected_slot] = ""
	emit_signal("inventory_changed")
	return item
