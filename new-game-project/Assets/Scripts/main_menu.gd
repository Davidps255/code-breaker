extends Control

@export var start_scene: PackedScene

# Volume sliders
@onready var master = $OptionsPanel/ScrollContainer/VBoxContainer/MasterPanel/MasterSlider
@onready var music = $OptionsPanel/ScrollContainer/VBoxContainer/MusicPanel/MusicSlider
@onready var sfx = $OptionsPanel/ScrollContainer/VBoxContainer/SFXPanel/SFXSlider

func _ready() -> void:
	$Music.play()
	master.value = SoundManager.get_volume("Master")
	music.value = SoundManager.get_volume("Music")
	sfx.value = SoundManager.get_volume("SFX")
	var buttons: Array = get_tree().get_nodes_in_group("Button")
	for button in buttons:
		button.pressed.connect(_on_button_pressed)


func _on_button_pressed(_hi=0) -> void:
	$ButtonSFX.play()


func _on_start_button_pressed() -> void:
	TransitionScreen.transition()
	fade_volume(1)
	await TransitionScreen.transition_finished
	get_tree().change_scene_to_packed(start_scene)


func fade_volume(time: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Music, "volume_db", -80.0, time)


func _on_options_button_pressed() -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	if $OptionsPanel.position.x < 1150.0:
		tween.tween_property($OptionsPanel,"position", Vector2(1160, $OptionsPanel.position.y), 0.5)
	else:
		tween.tween_property($OptionsPanel, "position", Vector2(663, $OptionsPanel.position.y), 0.5)


func _on_master_value_changed(value: float) -> void:
	SoundManager.set_volume("Master", value)


func _on_music_slider_value_changed(value: float) -> void:
	SoundManager.set_volume("Music", value)


func _on_sfx_slider_value_changed(value: float) -> void:
	SoundManager.set_volume("SFX", value)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_music_finished() -> void:
	$Music.play()
