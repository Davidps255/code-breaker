extends Control

var goggles_on: bool = false

func _physics_process(_delta) -> void:
	if Input.is_action_just_pressed("highlight"):
		if goggles_on == true:
			goggles_on = false
			$ColorRect.visible = false
		else:
			goggles_on = true
			$ColorRect.visible = true
