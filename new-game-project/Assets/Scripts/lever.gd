extends Node3D
var is_interactable: bool = true
var interactable_type: String = "lever"
signal lever_pushed
@export var sole_occupant: bool = false 

func interact(enter_or_exit: String):
	print("LEVER PUSHED")
	emit_signal("lever_pushed")
