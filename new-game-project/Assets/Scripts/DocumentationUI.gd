extends Control

var command_1_texture: Texture2D = preload("res://Assets/Temporary Documentation Command Images/Screenshot 2026-01-31 154127.png")
var command_2_texture: Texture2D = preload("res://Assets/Temporary Documentation Command Images/Screenshot 2026-01-31 162001.png")
var command_3_texture: Texture2D = preload("res://Assets/Temporary Documentation Command Images/Screenshot 2026-01-314 162001.png")
var command_4_texture: Texture2D = preload("res://Assets/Temporary Documentation Command Images/Screenshot 2026-01-315 162001.png")

@export var panel_texture_rect: TextureRect

func _on_button_1_pressed() -> void:
	panel_texture_rect.texture=command_1_texture

func _on_button_2_pressed() -> void:
	panel_texture_rect.texture=command_2_texture
	
func _on_button_3_pressed() -> void:
	panel_texture_rect.texture=command_3_texture

func _on_button_4_pressed() -> void:
	panel_texture_rect.texture=command_4_texture
