extends Node3D

@export var x_length: int
@export var y_length: int

func _enter_tree() -> void:
	GlobalVariables.tile_list=[]
	var y: int = 0
	var x: int = 0
	var row_list=[]
	for tile in get_children():
		row_list.append(tile)
		tile.coordinates=Vector2(x, y)
		x+=1
		if (x==x_length):
			x=0
			y+=1
			GlobalVariables.tile_list.append(row_list.duplicate(true))
			row_list=[]
	
	
