extends CanvasLayer

signal transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Begin the ColorRect as invisible
	color_rect.visible = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	# After fading to black, make transition invisible again
	if anim_name == "fade_to_black":
		animation_player.play("fade_to_normal")
		transition_finished.emit()
	elif anim_name == "fade_to_normal":
		color_rect.visible = false


# Public function to create a transition
func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")
