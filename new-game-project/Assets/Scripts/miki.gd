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
var order_type: String = "movement"
var cardinal_vectors: Array = [Vector2(-1,0), Vector2(1,0), Vector2(0,-1), Vector2(0,1)]
const SPEED: float = 5.0

var prop_to_move = null
var target_prop = null
var is_carrying_target: bool = false

var documentation_open: bool = false

func find_target_destination(target):
	tile_options=[]
	var target_coordinates: Vector2 = target.tile_coordinates
	for i in range(4):
		var possible_x: int = target_coordinates[0] +cardinal_vectors[i][0]
		var possible_y: int = target_coordinates[1] + cardinal_vectors[i][1]
		if 0 < possible_x and possible_x < len(GlobalVariables.tile_list[0]):
			if 0 < possible_y and possible_y < len(GlobalVariables.tile_list):
				tile_options.append(GlobalVariables.tile_list[possible_y][possible_x])

	var closest_tile: NavigationRegion3D = null
	for tile in tile_options:
		if closest_tile==null:
			closest_tile=tile
		else:
			if (position.distance_to(tile.position) < position.distance_to(closest_tile.position)):
				closest_tile=tile
	
	if closest_tile!=null:
		nav_agent.target_position=closest_tile.position
	else:
		print("MIKI COULD NOT FIND VIABLE PATHFIND TILE")

func move_to_target():
	var current_location: Vector3 = position
	var next_location: Vector3 = nav_agent.get_next_path_position();
	var new_velocity = (next_location - current_location).normalized() * SPEED
	new_velocity.y=0;
	
	velocity=velocity.move_toward(new_velocity, 0.25)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not following_orders:
		find_target_destination(player)
		move_to_target()
		
	if following_orders==true and order_type=="movement":
		if is_carrying_target == false:
			find_target_destination(prop_to_move)
			move_to_target()
			if (self.position.distance_to(prop_to_move.position) < 2.3):
				is_carrying_target = true
		if is_carrying_target == true:
			prop_to_move.position = self.position + Vector3(0, 4, 0)
			find_target_destination(target_prop)
			move_to_target()
			if (self.position.distance_to(target_prop.position) < 2.3):
				is_carrying_target = false
				following_orders=false
				prop_to_move.position = target_prop.position + Vector3(0, 1, 0)
				

	move_and_slide()
	
func interact(enter_or_exit: String) -> void:
	interacting_with_player = true
	line_edit.visible = true
	
	if enter_or_exit == "enter":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if enter_or_exit == "exit":
		interacting_with_player = false
		line_edit.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_line_edit_basic_order(object: String, action: String, parameter: String) -> void:
	if action=="move":
		prop_to_move = null
		target_prop = null
		for prop in props.get_children():
			if "script_name" in prop and prop.script_name==object and prop.is_movable==true:
				prop_to_move=prop
			if "script_name" in prop and prop.script_name==parameter and prop.is_stationary==true:
				target_prop=prop
		print(prop_to_move)
		print(target_prop) 
		if prop_to_move != null and target_prop!=null:
			following_orders=true
			order_type="movement"
			interact("exit")
			player.interacting=false
