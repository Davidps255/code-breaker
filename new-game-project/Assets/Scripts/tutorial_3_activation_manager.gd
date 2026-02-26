extends Node3D
var pressure: int = 0
var inaccessible_door_open: bool = false
@export var doors: AnimationPlayer


func _on_pressure_plate_pressed() -> void:
	pressure+=1
	if pressure==2:
		doors.speed_scale = 1
		doors.play("ArmatureAction")

func _on_poweredplate_pressed() -> void:
	pressure+=1
	if pressure==2:
		doors.speed_scale = 1
		doors.play("ArmatureAction")

func _on_pressure_plate_unpressed() -> void:
	pressure-=1
	if pressure==1:
		doors.speed_scale = -1
		doors.play("ArmatureAction")

func _on_poweredplate_unpressed() -> void:
	pressure-=1
	if pressure==1:
		doors.speed_scale = -1
		doors.play("ArmatureAction")


func _on_lever_static_body_lever_pushed() -> void:
	inaccessible_door_open = !inaccessible_door_open
	if inaccessible_door_open:
		doors.speed_scale=1
	else:
		doors.speed_scale=-1
	doors.play("ArmatureAction_001")
