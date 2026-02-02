extends Node

@onready var bus_layout := preload("res://Assets/Audio Bus/bus_layout.tres")

const DEFAULT_VOLUME = 1.0

var volumes := {
	"Master" : DEFAULT_VOLUME,
	"Music" : DEFAULT_VOLUME,
	"SFX" : DEFAULT_VOLUME
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_layout(bus_layout)
	
	for bus in volumes.keys():
		_apply_volume(bus)


func get_volume(bus: String) -> float:
	# Returns bus volume if it exists, otherwise default volume
	return volumes.get(bus, DEFAULT_VOLUME)


func set_volume(bus: String, volume: float) -> void:
	volume = clamp(volume, 0.0, 1.0) # Ensures that volume stays wtihin 0.0 to 1.0
	volumes[bus] = volume # Sets volume
	_apply_volume(bus)


func _apply_volume(bus: String) -> void:
	var busIdx := AudioServer.get_bus_index(bus)
	if busIdx == -1: # Bus not found
		return
	AudioServer.set_bus_volume_linear(busIdx, volumes[bus])
