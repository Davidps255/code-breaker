extends Node3D

@export var tutorial_1: Node3D
@export var tutorial_1_pressure_plate: Node3D
@export var tutorial_1_floor_tiles: Node3D

@export var tutorial_2: Node3D
@export var tutorial_2_props: Node3D
@export var tutorial_2_floor_tiles: Node3D

@export var tutorial_3: Node3D
@export var tutorial_3_props: Node3D
@export var tutorial_3_floor_tiles: Node3D

@export var miki: CharacterBody3D


var hallway_1_entered: bool = false
var tutorial_2_entered: bool = false


func _enter_tree() -> void:
	_set_tiles(5, tutorial_1_floor_tiles)


func _on_hallway_1_entrance_body_entered(body: Node3D) -> void:
	if hallway_1_entered == false:
		if "is_player" in body:
			miki.is_in_hallway = true
			hallway_1_entered = true

func _on_hallway_1_exit_body_entered(body: Node3D) -> void:
	if tutorial_2_entered == false:
		if "interactable_type" in body and body.interactable_type=="miki":
			miki.is_in_hallway = false
			tutorial_1_pressure_plate.emit_signal("unpressed")
			miki.props = tutorial_2_props
			print(miki.props.get_children())
			_set_tiles(5, tutorial_2_floor_tiles)
			tutorial_2_entered = true


func _set_tiles(x_length: int, tilemanager: Node3D) -> void:
	var x = 0
	var y = 0
	GlobalVariables.tile_list=[]
	var row_list=[]
	for tile in tilemanager.get_children():
		row_list.append(tile)
		tile.coordinates=Vector2(x, y)
		tile.update_coordinates()
		x+=1
		if (x==x_length):
			x=0
			y+=1
			GlobalVariables.tile_list.append(row_list.duplicate(true))
			row_list=[]
