extends Node
class_name PlayerStateMachine

@export var AnimPlayer : AnimatedSprite2D
@export var player : Player
var current_state : PlayerState
var transition_state : PlayerState
var old_state : PlayerState
var states : Dictionary = {}
@onready var movie_player : AnimationPlayer = $"../AnimationPlayer"

func _ready() -> void:
	# Gather all different states in the dictionnary
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_state_transition)
			child.AnimPlayer = AnimPlayer
			child.player = player
			child.movie_player = movie_player
			if child is ChargingState:
				child.connect("attack_charged", player.on_attack_charged, )
	current_state = states["idle"]
	old_state = current_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func on_state_transition(new_state_name):
	if states[new_state_name] != current_state:  
		old_state = current_state
		current_state.exit()
		current_state = states[new_state_name.to_lower()]
		current_state.enter()

func get_current_state():
	return current_state

func _on_animated_sprite_2d_animation_finished() -> void:
	current_state.on_animation_end()
