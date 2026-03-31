extends Node


var mouse_sensitivty := 0.01
signal sensitivity_changed


func get_mouse_sensitivty() -> float:
	return mouse_sensitivty


func set_mouse_sensitivity(new_sensitivity: float) -> void:
	mouse_sensitivty = new_sensitivity
	sensitivity_changed.emit()
