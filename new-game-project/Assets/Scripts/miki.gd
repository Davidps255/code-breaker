extends CharacterBody3D

@export var player: CharacterBody3D
@export var line_edit: CommandLine
@export var props: Node3D
@onready var nav_agent = $NavigationAgent3D
var tile_options: Array
var tile_coordinates: Vector2
var is_interactable: bool = true
var interactable_type: String = "miki"
var interacting_with_player: bool = false
var following_order: bool = false
var following_function: bool = false
var order_queue: Array
var order_type: String = "move"
var miki_animator: AnimationPlayer
var cardinal_vectors: Array = [Vector2(0,-1), Vector2(1,0), Vector2(0,1), Vector2(-1,0)]
const SPEED: float = 5.0

var prop_to_move = null
var target_prop = null
var target_tile = null
var is_carrying_target: bool = false
var target_carried = null
var is_in_hallway: bool = false
var is_under_manual_control: bool = false
var frame_counter: int = 0

var documentation_open: bool = false

func _ready() -> void:
	miki_animator=find_child("MIKIver1_2").find_child("AnimationPlayer")

func find_target_destination(target):
	tile_options=[]
	var target_coordinates: Vector2 = target.tile_coordinates
	#print(target.position)
	for i in range(4):
		var possible_x: int = target_coordinates[0] + cardinal_vectors[i][0]
		var possible_y: int = target_coordinates[1] + cardinal_vectors[i][1]
		if 0 <= possible_x and possible_x < len(GlobalVariables.tile_list[0]):
			if 0 <= possible_y and possible_y < len(GlobalVariables.tile_list):
				tile_options.append(GlobalVariables.tile_list[possible_y][possible_x])
	var closest_tile: NavigationRegion3D = null
	for tile in tile_options:
		if tile.inacessible==true and is_under_manual_control==false:
			pass
		else:
			if closest_tile==null:
				closest_tile=tile
			else:
				if (position.distance_to(tile.global_position) < position.distance_to(closest_tile.global_position)):
					closest_tile=tile
	
	if closest_tile!=null:
		nav_agent.target_position=closest_tile.global_position
	else:
		print("MIKI COULD NOT FIND VIABLE PATHFIND TILE")

func move_to_target():
	var current_location: Vector3 = global_position
	var next_location: Vector3 = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	new_velocity.y=0;
	
	velocity=velocity.move_toward(new_velocity, 0.25)
	if velocity != Vector3(0,0,0) and not interacting_with_player:
		var old = rotation.y
		look_at(velocity+position)
		var new = rotation.y
		rotation.y = lerp(old, new, .1)


func _physics_process(delta: float) -> void:
	if following_function and order_queue.size()>0 and not following_order:
		_on_line_edit_basic_order(order_queue[0][0], order_queue[0][1], order_queue[0][2])
		order_queue.remove_at(0)
		if order_queue.size()==0:
			following_function=false
		
	if target_carried != null and is_carrying_target:
		target_carried.tile_coordinates = tile_coordinates
		target_carried.global_position = self.position + Vector3(0, 4, 0)
		
	if interacting_with_player and miki_animator.current_animation_position>1.1:
			miki_animator.pause()
	if is_in_hallway:
		#print("hallway movement")
		nav_agent.target_position=player.global_position
		following_order = false
		following_function = false
		order_queue = []
		move_to_target()
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if not following_order and not is_in_hallway:
		#print("NORMAL MOVEMENT")
		find_target_destination(player)
		move_to_target()
		
	if following_order==true and order_type=="move":
		if is_carrying_target == false:
			find_target_destination(prop_to_move)
			move_to_target()
			if (self.global_position.distance_to(prop_to_move.global_position) < 3.0):
				is_carrying_target = true
				target_carried = prop_to_move
				prop_to_move.is_template=false
				
		if is_carrying_target == true:
			find_target_destination(target_prop)
			move_to_target()
			if (self.global_position.distance_to(target_prop.global_position) < 3.0):
				is_carrying_target = false
				target_carried = null
				following_order=false
				prop_to_move.global_position = target_prop.global_position + Vector3(0, 1, 0)
				if target_prop.script_type=="printer":
					prop_to_move.global_position = target_prop.global_position + Vector3(0, 1.5, 0)
					target_prop.template=prop_to_move
					prop_to_move.is_template=true
				prop_to_move.tile_coordinates = target_prop.tile_coordinates
				
	elif following_order == true and order_type=="move_miki":
		frame_counter+=1
		nav_agent.target_position=target_tile.global_position
		move_to_target()

		if (frame_counter>1000) or (global_position.distance_to(nav_agent.target_position) < 0.1):
			is_under_manual_control = false
			following_order=false
			frame_counter=0
		
	move_and_slide()
	
func interact(enter_or_exit: String):
	if is_in_hallway:
		return
		
	interacting_with_player = true
	line_edit.visible = true
	
	if enter_or_exit == "enter":
		if following_order:
			return
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.interacting = true
		miki_animator.play("ArmatureAction")
		
	if enter_or_exit == "exit":
		interacting_with_player = false
		line_edit.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		miki_animator.play()

func _on_line_edit_basic_order(object: String, action: String, parameter: String) -> void:
	if action=="move": # as in move prop to another place
		prop_to_move = null
		target_prop = null
		for prop in props.get_children():
			if action=="move":
				if "script_name" in prop and prop.script_name==object and prop.is_movable==true:
					prop_to_move=prop
					if is_carrying_target == true and target_carried != prop_to_move: #Miki can't move another prop while carrying a prop
						prop_to_move=null
				if "script_name" in prop and prop.script_name==parameter and prop.is_stationary==true:
					target_prop=prop
					if target_prop.script_type=="printer" and target_prop.template!=null and target_prop.template.is_template:
						target_prop=null
					elif target_prop.script_type=="printer" and prop_to_move and prop_to_move.is_printable==false:
						target_prop=null
						
		if prop_to_move != null and target_prop!=null:
			var valid_move: bool = true
			for prop in props.get_children():
				if "tile_coordinates" in prop and prop.tile_coordinates==target_prop.tile_coordinates and prop.sole_occupant==true:
					valid_move=false
					print("SPACE ALREADY OCCUPIED")
			if valid_move:
				_successful_order("move")
				
	elif action=="move_miki" or action=="grab_miki":
		var target_tile_coordinates = null
		match parameter:
			"north": 
				target_tile_coordinates = tile_coordinates + cardinal_vectors[0]
			"east":
				target_tile_coordinates = tile_coordinates + cardinal_vectors[1]
			"south":
				target_tile_coordinates = tile_coordinates + cardinal_vectors[2]
			"west":
				target_tile_coordinates = tile_coordinates + cardinal_vectors[3]
			
		if target_tile_coordinates and 0 <= target_tile_coordinates.x and target_tile_coordinates.x < len(GlobalVariables.tile_list[0]):
			if 0 <= target_tile_coordinates.y and target_tile_coordinates.y < len(GlobalVariables.tile_list):
				target_tile=GlobalVariables.tile_list[target_tile_coordinates.y][target_tile_coordinates.x]
				if action=="move_miki":
					is_under_manual_control=true
					_successful_order("move_miki")
					
				elif action=="grab_miki":
					for prop in props.get_children():
						if "tile_coordinates" in prop and prop.is_movable and prop.tile_coordinates==target_tile.tile_coordinates:
							is_carrying_target = true
							target_carried = prop
							break
					interact("exit")
					if following_function==false:
						player.interacting=false
				
func _successful_order(action: String):
	following_order=true
	order_type=action
	interact("exit")
	if following_function==false:
		player.interacting=false


func _on_line_edit_function_order(list_of_orders: Variant) -> void:
	interact("exit")
	player.interacting=false
	following_function=true
	order_queue=list_of_orders
