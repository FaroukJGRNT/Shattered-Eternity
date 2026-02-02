extends StateMachine
class_name PlayerStateMachine

@onready var player : Player = owner
var old_state : PlayerState


func _ready() -> void:
	super._ready()
	# Gather all different states in the dictionnary
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_state_transition)
			child.AnimPlayer = AnimPlayer
			child.player = player
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
