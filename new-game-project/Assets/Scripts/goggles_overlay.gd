extends Control

var goggles_on: bool = false

#func _physics_process(_delta) -> void:
	##if Input.is_action_just_pressed("highlight"):
		##if goggles_on == true:
			##goggles_on = false
			##$ColorRect.visible = false
		##else:
			##goggles_on = true
			##$ColorRect.visible = true
	#
	##if goggles_on:
		#var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		#var cam: Camera3D = get_viewport().get_camera_3d()
		#
		#$RayCast3D.target_position = cam.project_ray_normal(mouse_pos) * 100.0
		#$RayCast3D.force_raycast_update()
		#print($RayCast3D.target_position)
		#
		#if $RayCast3D.is_colliding():
			#print(mouse_pos)
			#print("colliding")
		#
		#if $RayCast3D.is_colliding():
			#var result: Object = $RayCast3D.get_collider()
			#var script: Script = result.get_script()
			#
			#print(result.name)

func _physics_process(_delta: float) -> void:
	# Assuming goggles_on is true for this example
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var cam: Camera3D = get_viewport().get_camera_3d()
	
	# 1. Calculate the start and end points of the ray in GLOBAL space
	var ray_origin: Vector3 = cam.project_ray_origin(mouse_pos)
	var ray_end: Vector3 = ray_origin + cam.project_ray_normal(mouse_pos) * 100.0
	
	# 2. Set up the raycast query
	var space_state = get_viewport().get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collision_mask = 1
	
	# 3. Perform the raycast
	var result: Dictionary = space_state.intersect_ray(query)
	
	# 4. Check if we hit something
	if result:
		print("Colliding with: ", result.collider.name)
		print("Hit at global position: ", result.position)
		
		# If you need to check the script:
		var hit_object = result.collider
		if hit_object.get_script():
			print("Object has a script attached.")
