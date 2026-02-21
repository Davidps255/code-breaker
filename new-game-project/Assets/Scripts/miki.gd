extends CharacterBody3D

@export var player: CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
var tile_options: Array
var cardinal_vectors: Array = [Vector2(-1,0), Vector2(1,0), Vector2(0,-1), Vector2(0,1)]
const SPEED: float = 5.0


var documentation_open: bool = false

func update_target_location():
	tile_options=[]
	var player_coordinates: Vector2 = player.player_tile_coordinates
	for i in range(4):
		var possible_x: int = player_coordinates[0] +cardinal_vectors[i][0]
		var possible_y: int = player_coordinates[1] + cardinal_vectors[i][1]
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

func _physics_process(delta: float) -> void:
	update_target_location()
	if not is_on_floor():
		velocity += get_gravity() * delta
	var current_location: Vector3 = position
	var next_location: Vector3 = nav_agent.get_next_path_position();
	var new_velocity = (next_location - current_location).normalized() * SPEED
	new_velocity.y=0;
	
	velocity=velocity.move_toward(new_velocity, 0.25)

	move_and_slide()
