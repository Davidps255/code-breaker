extends CharacterBody3D

const SPEED: float = 5.0
@export var script_name: String
@export var script_type: String = "metal_box"
@export var is_stationary: bool = true
@export var is_movable: bool = true
var tile_coordinates: Vector2 = Vector2(-9,-9)



func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	move_and_slide()
