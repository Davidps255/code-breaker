extends Control

var TITLE_SCREEN: String = "res://Workspaces/MainMenu.tscn"
signal unpause

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		unpause.emit()


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file(TITLE_SCREEN)
