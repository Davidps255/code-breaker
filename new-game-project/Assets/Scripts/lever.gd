extends Node3D
var is_interactable: bool = true
var interactable_type: String = "lever"
signal lever_pushed
@export var sole_occupant: bool = false 
@export var script_name: String = "lever-1"
@export var script_type: String = "lever"
@export var is_stationary: bool = true
@export var is_movable: bool = false
var tile_coordinates: Vector2 = Vector2(100,100)
var is_printable: bool = true
var is_template: bool = false
var is_clone: bool = false

func interact(enter_or_exit: String):
	print("LEVER PUSHED")
	emit_signal("lever_pushed")
