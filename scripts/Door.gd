extends StaticBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var is_open: bool = false

func _ready():
	LevelManager.all_tasks_complete.connect(_open_door)

func _open_door():
	if is_open:
		return
	is_open = true
	var tween = create_tween()
	tween.tween_property(mesh_instance, "position", mesh_instance.position + Vector3(0, 3.5, 0), 1.2)
