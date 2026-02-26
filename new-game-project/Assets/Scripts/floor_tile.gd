extends NavigationRegion3D

var tile_coordinates: Vector2
@export var inacessible: bool = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if ("tile_coordinates" in body):
		body.tile_coordinates=tile_coordinates
	
func update_coordinates():
	for body in $Area3D.get_overlapping_bodies():
		if ("tile_coordinates" in body):
			body.tile_coordinates=tile_coordinates
