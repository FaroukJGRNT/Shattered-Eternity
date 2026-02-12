extends StateMachine
class_name PlayerStateMachine

@onready var player : Player = owner
var old_state : PlayerState

func connect_state(state : PlayerState):
	state.transitioned.connect(on_state_transition)
	state.AnimPlayer = AnimPlayer
	state.player = player

func _ready() -> void:
	super._ready()
	# Gather all different states in the dictionnary
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			connect_state(child)
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

func special_state_transition(new_state : State):
	if current_state != new_state:
		old_state = current_state
		current_state.exit()
		current_state = new_state
		current_state.enter()
