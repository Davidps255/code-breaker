extends Node3D
@export var script_name: String
@export var script_type: String = "poweredplate"
@export var is_stationary: bool = true
@export var is_movable: bool = false
@export var tile_coordinates: Vector2 = Vector2(-9,-9)
@export var powered_object: String
@export var is_printable: bool = false
@export var is_template: bool = false
@export var is_clone: bool = false
@export var sole_occupant: bool = false 

var active: bool = false
signal pressed()
signal unpressed()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if "script_name" in body and body.is_movable==true and body.script_type=="battery":
		active=true
		emit_signal("pressed")

func _on_area_3d_body_exited(body: Node3D) -> void:
	var colliding_bodies = $Area3D.get_overlapping_bodies()
	var movable_found: bool = false
	for object in colliding_bodies: 
		if "script_name" in object and object.is_movable==true and object.script_type=="battery":
			movable_found = true
			break
	if "script_name" in body and body.is_movable==true and body.script_type=="battery" and movable_found == false and active==true:
		active=false
		emit_signal("unpressed")
