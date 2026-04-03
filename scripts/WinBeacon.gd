extends Node3D

var time: float = 0.0

func _process(delta):
	time += delta
	position.y = sin(time * 2.0) * 0.3
	rotation_degrees.y += 60.0 * delta
