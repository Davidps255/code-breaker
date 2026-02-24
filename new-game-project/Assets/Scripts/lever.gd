extends Node3D
var is_interactable: bool = true
var interactable_type: String = "miki"
signal lever_pushed

func interact(enter_or_exit: String):
	print("LEVER PUSHED")
	emit_signal("lever_pushed")
