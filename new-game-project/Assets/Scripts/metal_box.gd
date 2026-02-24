extends CharacterBody3D

const SPEED: float = 5.0
@export var script_name: String
@export var script_type: String = "metal_box"
@export var is_stationary: bool = true
@export var is_movable: bool = true
@export var tile_coordinates: Vector2 = Vector2(100,100)
@export var is_printable: bool = true
@export var is_template: bool = false
@export var is_clone: bool = false


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	move_and_slide()
