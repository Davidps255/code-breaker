extends CharacterBody3D

@export var player: CharacterBody3D
@export var line_edit: CommandLine
@export var props: Node3D
@onready var nav_agent = $NavigationAgent3D
var tile_options: Array
var is_interactable: bool = true
var interactable_type: String = "miki"
var interacting_with_player: bool = false
var following_orders: bool = false
var order_type: String = "move"
var miki_animator: AnimationPlayer
var cardinal_vectors: Array = [Vector2(-1,0), Vector2(1,0), Vector2(0,-1), Vector2(0,1)]
const SPEED: float = 5.0

var prop_to_move = null
var target_prop = null
var is_carrying_target: bool = false
var is_in_hallway: bool = false

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
	if interacting_with_player and miki_animator.current_animation_position>1.1:
			miki_animator.pause()
	if is_in_hallway:
		#print("hallway movement")
		nav_agent.target_position=player.global_position
		following_orders = false
		move_to_target()
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if not following_orders and not is_in_hallway:
		#print("NORMAL MOVEMENT")
		find_target_destination(player)
		move_to_target()
		
	if following_orders==true and order_type=="move":
		if is_carrying_target == false:
			find_target_destination(prop_to_move)
			move_to_target()
			if (self.global_position.distance_to(prop_to_move.global_position) < 3.0):
				is_carrying_target = true
				prop_to_move.is_template=false
				
		if is_carrying_target == true:
			prop_to_move.global_position = self.position + Vector3(0, 4, 0)
			find_target_destination(target_prop)
			move_to_target()
			if (self.global_position.distance_to(target_prop.global_position) < 3.0):
				is_carrying_target = false
				following_orders=false
				prop_to_move.global_position = target_prop.global_position + Vector3(0, 1, 0)
				if target_prop.script_type=="printer":
					prop_to_move.global_position = target_prop.global_position + Vector3(0, 1.5, 0)
					target_prop.template=prop_to_move
					prop_to_move.is_template=true

				prop_to_move.tile_coordinates = target_prop.tile_coordinates

		
	move_and_slide()
	
func interact(enter_or_exit: String):
	if is_in_hallway:
		return
		
	interacting_with_player = true
	line_edit.visible = true
	
	if enter_or_exit == "enter":
		if following_orders:
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
	if action=="move":
		prop_to_move = null
		target_prop = null
		for prop in props.get_children():
			if action=="move":
				if "script_name" in prop and prop.script_name==object and prop.is_movable==true:
					prop_to_move=prop
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
				_successful_order(action)
				
func _successful_order(action: String):
	following_orders=true
	order_type=action
	interact("exit")
	player.interacting=false
