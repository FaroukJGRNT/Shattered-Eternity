extends StateMachine
class_name EnemyStateMachine

@onready var enemy : BasicEnemy = owner

func _ready() -> void:
	super._ready()
	# Gather all different states in the dictionnary
	for child in get_children():
		if child is EnemyState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_state_transition)
			child.AnimPlayer = AnimPlayer
			child.enemy = enemy
	current_state = states["wander"]

func _process(delta: float) -> void:
	for child in get_children():
		if child is EnemyAttackState:
			child.option_timer = max(child.option_timer - delta, 0)
	if current_state:
		current_state.update(delta)

func on_state_transition(new_state_name):
	if enemy.dead and new_state_name != "death":
		return
	if states[new_state_name] != current_state:
		current_state.exit()
		if current_state is EnemyAttackState:
			current_state.option_timer = current_state.option_cooldown
			if current_state.wander_queued:
				current_state.wander_queued = false
				enemy.current_mode = enemy.Mode.CHILLIN
				current_state = states["wander"]
				current_state.enter()
				return
		current_state = states[new_state_name.to_lower()]
		current_state.enter()
