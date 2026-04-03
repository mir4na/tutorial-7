extends CanvasLayer

@onready var prompt_label: Label = $PromptLabel
@onready var slot_1: PanelContainer = $InventoryBar/Slot1
@onready var slot_2: PanelContainer = $InventoryBar/Slot2
@onready var slot_3: PanelContainer = $InventoryBar/Slot3
@onready var label_1: Label = $InventoryBar/Slot1/Label
@onready var label_2: Label = $InventoryBar/Slot2/Label
@onready var label_3: Label = $InventoryBar/Slot3/Label

var normal_style: StyleBoxFlat
var selected_style: StyleBoxFlat

func _ready():
	prompt_label.visible = false
	
	normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color(0, 0, 0, 0.6)
	normal_style.border_width_left = 2
	normal_style.border_width_right = 2
	normal_style.border_width_top = 2
	normal_style.border_width_bottom = 2
	normal_style.border_color = Color(0.2, 0.2, 0.2, 1)
	
	selected_style = normal_style.duplicate()
	selected_style.border_color = Color(1, 0.9, 0.2, 1)
	
	LevelManager.show_prompt.connect(_on_show_prompt)
	LevelManager.hide_prompt.connect(_on_hide_prompt)
	InventoryManager.inventory_changed.connect(_update_inventory_ui)
	
	_update_inventory_ui()

func _on_show_prompt(text: String):
	prompt_label.text = text
	prompt_label.visible = true

func _on_hide_prompt():
	prompt_label.visible = false

func _update_inventory_ui():
	var slots = InventoryManager.slots
	var sel = InventoryManager.selected_slot
	
	label_1.text = "1: " + (slots[0] if slots[0] != "" else "Empty")
	label_2.text = "2: " + (slots[1] if slots[1] != "" else "Empty")
	label_3.text = "3: " + (slots[2] if slots[2] != "" else "Empty")
	
	slot_1.add_theme_stylebox_override("panel", selected_style if sel == 0 else normal_style)
	slot_2.add_theme_stylebox_override("panel", selected_style if sel == 1 else normal_style)
	slot_3.add_theme_stylebox_override("panel", selected_style if sel == 2 else normal_style)
