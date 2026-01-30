extends Control

@export var start_scene: PackedScene


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)
