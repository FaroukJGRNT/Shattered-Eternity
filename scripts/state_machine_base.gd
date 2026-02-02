extends Node
class_name StateMachine

@onready var AnimPlayer : AnimatedSprite2D = owner.anim_player
var states : Dictionary = {}
var current_state : State

func _ready() -> void:
	AnimPlayer.connect("animation_finished", _on_animated_sprite_2d_animation_finished)

func on_state_transition(new_state_name):
	pass

func get_current_state():
	return current_state

func _on_animated_sprite_2d_animation_finished() -> void:
	current_state.on_animation_end()
