extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const MIN_CAMERA_ROTATION: int = -30
const MAX_CAMERA_ROTATION: int = 60
var MOUSE_SENSITIVITY: float = GameManager.mouse_sensitivty
@export var neck: Node3D
@export var camera: Camera3D
@export var documentation_ui: Control
@export var interact_area: Area3D

var documentation_open: bool = false
var interacting: bool = false
var tile_coordinates: Vector2 = Vector2(-9,-9)
var is_player: bool = true
var list_of_interactables: Array = []

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#print(position)
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("interact"): #enter interaction
		if list_of_interactables != []:
			print("INTERACITNG WITH")
			print(list_of_interactables[0])
			list_of_interactables[0].interact("enter")
			
			
	if Input.is_action_just_pressed("ui_cancel") and interacting==true: #cancel interaction
		interacting=false
		list_of_interactables[0].interact("exit")

	if not interacting:  #all movement + documentation open
		if Input.is_action_just_pressed("space") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		if Input.is_action_just_pressed("open_documentation"):
			documentation_ui.visible=!documentation_ui.visible
			documentation_open=!documentation_open	
			if documentation_open:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		
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
		interact_area.rotation=neck.rotation;
		
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not documentation_open and not interacting:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(MIN_CAMERA_ROTATION), deg_to_rad(MAX_CAMERA_ROTATION))


func _on_interact_area_body_entered(body: Node3D) -> void: #interactable enters interact range
	if "is_interactable" in body:
		print(body)
		list_of_interactables.insert(0, body)


func _on_interact_area_body_exited(body: Node3D) -> void: #interactable leaves interact range
	if "is_interactable" in body:
		for interactable in list_of_interactables:
			if interactable.interactable_type == body.interactable_type:
				list_of_interactables.erase(body)
