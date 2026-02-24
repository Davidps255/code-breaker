extends Node3D

const SPEED: float = 5.0
@export var script_name: String
@export var script_type: String = "printer"
@export var is_stationary: bool = true
@export var is_movable: bool = false
@export var tile_coordinates: Vector2 
@export var charges_remaining: int = 1
@export var is_printable: bool = false
@export var is_template: bool = false
@export var is_clone: bool = false
@export var template = null
@export var miki: CharacterBody3D
@export var props: Node3D

var clone = null
var frames_passed: int =0
func play_print_animation():
	print("PRINTING")
	$AnimationPlayer.play("ArmatureAction")

func printer_print():
	charges_remaining-=1
	print(template)
	clone = template.duplicate(true)

	template.is_template=false
	template=null

func _physics_process(delta: float) -> void:
	if clone!=null:
		print(clone)
		frames_passed+=1
		if frames_passed>100:
			print("CLONE COMPLETE")
			props.add_child(clone)
			#clone.is_clone=true
			clone.global_position=miki.global_position+Vector3(0,2,0)
			clone=null
			frames_passed=0
