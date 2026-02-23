extends NavigationRegion3D

var coordinates: Vector2

func _on_area_3d_body_entered(body: Node3D) -> void:
	if ("tile_coordinates" in body):
		body.tile_coordinates=coordinates
	
