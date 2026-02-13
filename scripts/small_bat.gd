extends BasicEnemy

var base_y := 0.0
var y_treshold := 20.0

func _ready() -> void:
	super._ready()
	base_y = global_position.y

func _physics_process(delta: float) -> void:
	current_state = state_machine.get_current_state()
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
		#move_and_slide()
		
	if current_state.is_state_blocking:
		return

	direct_sprite()

	if current_mode == Mode.BASIC_AGGRO:
		enemy_ai()

func enemy_ai():
	if not is_target_in_front():
		turn_around()

	if abs(global_position.y - base_y) > y_treshold:
		global_position.y = lerp(global_position.y, base_y, 0.1)
		velocity.x = -100 * facing
		return

	# Are my attacks blocked a lot
		# Break guard (if you know how to)

	# Have I taken a lot of damage quickly
	if (last_decide_hp - life) >= (max_life / 6) and state_machine.old_state.name.to_lower() != "staggered":
		# Chose a defensive action
		var ready_acts = []
		for act in defensive_actions:
			if act.option_timer <= 0:
				ready_acts.append(act)

		var num = len(ready_acts)
		if num > 0:
			state_machine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
			last_decide_hp = life
			return
	
	last_decide_hp = life

	# Is the target far away
	if not is_target_in_close_range():
		# Choose randomly a ranged offens act (If no available, go closer)
		var ready_acts = []
		for act in ranged_offensive_actions:
			if act.option_timer <= 0:
				ready_acts.append(act)
		
		var num = len(ready_acts)
		if num > 0:
			state_machine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
		else:
			state_machine.on_state_transition("chase")
			return
	# Is the target close
	else:
		#  Choose randomly a ready offens act
		var ready_acts = []
		for act in offensive_actions:
			if act.option_timer <= 0:
				ready_acts.append(act)

		var num = len(ready_acts)
		if num > 0:
			state_machine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
		else:
			return
