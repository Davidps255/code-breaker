extends Control

@export var start_scene: PackedScene
const MASTER_INDEX = 0

func _ready() -> void:
	$OptionsPanel.hide()
	$AudioStreamPlayer.play()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)


func _on_options_button_pressed() -> void:
	$OptionsPanel.visible = not $OptionsPanel.visible


func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MASTER_INDEX, linear_to_db(value))
	# print(AudioServer.get_bus_volume_linear(MASTER_INDEX))
