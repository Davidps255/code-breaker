extends ScrollContainer


# Options sliders
@onready var master: HSlider = $VBoxContainer/MasterPanel/MasterSlider
@onready var music: HSlider = $VBoxContainer/MusicPanel/MusicSlider
@onready var sfx: HSlider = $VBoxContainer/SFXPanel/SFXSlider
@onready var mouse: HSlider = $VBoxContainer/MousePanel/MouseSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master.value = SoundManager.get_volume("Master")
	music.value = SoundManager.get_volume("Music")
	sfx.value = SoundManager.get_volume("SFX")
	mouse.value = GameSettings.get_mouse_sensitivty() / 0.02 - 0.1


func _on_master_slider_value_changed(value: float) -> void:
	SoundManager.set_volume("Master", value)


func _on_music_slider_value_changed(value: float) -> void:
	SoundManager.set_volume("Music", value)


func _on_sfx_slider_value_changed(value: float) -> void:
	SoundManager.set_volume("SFX", value)


func _on_mouse_slider_value_changed(value: float) -> void:
	GameSettings.set_mouse_sensitivity((value + 0.1) * 0.02)
