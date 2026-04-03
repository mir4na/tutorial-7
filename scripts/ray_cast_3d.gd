extends RayCast3D

func _process(delta):
	var hit = false
	if is_colliding():
		var obj = get_collider()
		if obj is Interactable:
			hit = true
			var txt = "Press E to interact"
			if "prompt_text" in obj:
				txt = obj.prompt_text
			LevelManager.show_prompt.emit(txt)
			
			if Input.is_action_just_pressed("interact"):
				obj.interact()
				
	if not hit:
		LevelManager.hide_prompt.emit()
