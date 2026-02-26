extends Node3D

@export var exit_door: AnimationPlayer

func _on_pressure_plate_pressed() -> void: #door
	exit_door.speed_scale = 1
	exit_door.play("ArmatureAction")

func _on_pressure_plate_unpressed() -> void: #doorr
	exit_door.speed_scale = -1
	exit_door.play("ArmatureAction")
