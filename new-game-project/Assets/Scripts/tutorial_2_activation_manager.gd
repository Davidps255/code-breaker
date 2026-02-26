extends Node3D


@export var exit_door: AnimationPlayer
@export var printer: Node3D
@export var props: Node3D

var pressure: int = 0

func _on_simple_lever_lever_pushed() -> void:
	if printer.charges_remaining>0 and printer.template != null and printer.template.is_template:
		printer.play_print_animation()
		printer.printer_print()


func _on_pressure_plate_pressed() -> void:
	pressure+=1
	if pressure==2:
		exit_door.speed_scale = 1
		exit_door.play("DoorLeft|ArmatureAction")


func _on_pressure_plate_unpressed() -> void:
	pressure-=1
	if pressure==1:
		exit_door.speed_scale = -1
		exit_door.play("DoorLeft|ArmatureAction")
		
func _on_pressure_plate_2_pressed() -> void:
	pressure+=1
	if pressure==2:
		exit_door.speed_scale = 1
		exit_door.play("DoorLeft|ArmatureAction")
		
func _on_pressure_plate_2_unpressed() -> void:
	pressure-=1
	if pressure==1:
		exit_door.speed_scale = -1
		exit_door.play("DoorLeft|ArmatureAction")
