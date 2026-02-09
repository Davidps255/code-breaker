extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const MIN_CAMERA_ROTATION: int = -30
const MAX_CAMERA_ROTATION: int = 60
var mouse_sensitvity: float = GameSettings.mouse_sensitivty
@export var neck: Node3D
@export var camera: Camera3D


func _ready() -> void:
	GameSettings.sensitivity_changed.connect(_on_game_settings_sensitivity_changed)


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * mouse_sensitvity)
			camera.rotate_x(-event.relative.y * mouse_sensitvity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(MIN_CAMERA_ROTATION), deg_to_rad(MAX_CAMERA_ROTATION))


func _on_game_settings_sensitivity_changed() -> void:
	mouse_sensitvity = GameSettings.mouse_sensitivty
