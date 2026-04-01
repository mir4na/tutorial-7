extends Interactable

@export var light : NodePath
@export var on_by_default = true
@export var energy_when_on = 10
@export var energy_when_off = 3

@onready var light_node : Light3D = get_node(light)

@export var switch: NodePath
@onready var switch_node: MeshInstance3D = get_node(switch)

var on = on_by_default

func _ready():
	light_node.light_energy = energy_when_on if on else energy_when_off

func interact():
	on = !on
	light_node.light_energy = energy_when_on if on else energy_when_off
	if on:
		switch_node.position += Vector3(0,0,0.308)
	else:
		switch_node.position -= Vector3(0,0,0.308)
		
		
