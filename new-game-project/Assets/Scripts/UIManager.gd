extends Control

@export var documentation_ui: Control
@export var pause_menu: Control
var documentation_open: bool = false
var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	documentation_ui.visible = documentation_open
	pause_menu.visible = get_tree().paused
	_update_mouse()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_documentation"): # Default is 'J'
		documentation_open = not documentation_open	
		documentation_ui.visible = documentation_open
		_update_mouse()
	
	if Input.is_action_just_pressed("pause"): # Default is 'Escape'
		paused = not paused
		get_tree().paused = not get_tree().paused
		pause_menu.visible = get_tree().paused
		_update_mouse()


# Locks/unlocks mouse based on whether documentation is open or game is paused
func _update_mouse() -> void:
	if not documentation_open and not get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
