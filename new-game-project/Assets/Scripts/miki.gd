extends CharacterBody3D

@export var player: CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
const SPEED: float = 5.0


var documentation_open: bool = false

func update_target_location():
	nav_agent.target_position=player.position
	

func _physics_process(delta: float) -> void:
	update_target_location()
	if not is_on_floor():
		velocity += get_gravity() * delta
	var current_location: Vector3 = transform.origin
	var next_location: Vector3 = nav_agent.get_next_path_position();
	var new_velocity = (next_location - current_location).normalized() * SPEED

	velocity=velocity.move_toward(new_velocity, 0.25)

	move_and_slide()
