extends Control

var level1: String = "res://Workspaces/Room1.tscn"

@onready var OptionsPanel: Panel = $OptionsPanel

func _ready() -> void:
	$Music.play()
	var buttons: Array = get_tree().get_nodes_in_group("Button")
	for button in buttons:
		button.pressed.connect(_on_button_pressed)
	get_tree().paused = false


func _on_button_pressed() -> void:
	$ButtonSFX.play()


func _on_start_button_pressed() -> void:
	TransitionScreen.transition()
	fade_volume(2)
	await TransitionScreen.transition_finished
	get_tree().change_scene_to_file(level1)


func fade_volume(time: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Music, "volume_db", -80.0, time)


func _on_options_button_pressed() -> void:
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	if $OptionsPanel.position.x < 1150.0:
		tween.tween_property($OptionsPanel,"position", Vector2(1160, $OptionsPanel.position.y), 0.5)
	else:
		tween.tween_property($OptionsPanel, "position", Vector2(660, $OptionsPanel.position.y), 0.5)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_music_finished() -> void:
	$Music.play()
