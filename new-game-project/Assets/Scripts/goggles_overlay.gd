extends Control

var goggles_on: bool = false

func _physics_process(_delta) -> void:
	if Input.is_action_just_pressed("highlight"):
		if goggles_on == true:
			goggles_on = false
			$ColorRect.visible = false
		else:
			goggles_on = true
			$ColorRect.visible = true
	
	if goggles_on:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var cam: Camera3D = get_viewport().get_camera_3d()
		
		$RayCast3D.target_position = cam.project_ray_normal(mouse_pos) * 1000
		
		if $RayCast3D.is_colliding():
			var result: Object = $RayCast3D.get_collider()
			var script: Script = result.get_script()
			
			if script:
				print("Script")
			else:
				print("No script")
