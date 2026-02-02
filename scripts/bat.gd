extends BasicEnemy
class_name Bat

func _physics_process(delta: float) -> void:
	current_state = state_machine.get_current_state()
	# Add the gravity.
	if not is_on_floor():
		if current_state is EnemyAttackState:
			velocity += get_gravity() * delta / 50
		else: 
			velocity += get_gravity() * delta / 10

	if current_state.is_state_blocking:
		return

	direct_sprite()

	if current_mode == Mode.BASIC_AGGRO:
		enemy_ai()

func enemy_ai():
	# Are my attacks blocked a lot
		# Break guard (if you know how to)

	# Always see if you can back off
	if is_target_in_close_range():
		if randf_range(0, 1) >= 0.5:
			# Chose a defensive action
			var ready_acts = []
			for act in defensive_actions:
				if act.option_timer <= 0:
					ready_acts.append(act)

			var num = len(ready_acts)
			if num > 0:
				$EnemyStateMachine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
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
			$EnemyStateMachine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
		else:
			$EnemyStateMachine.on_state_transition("chase")
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
			$EnemyStateMachine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
		else:
			return

	# Potentially custom stuff: (Enemy behind me --> reverse)
	# Or is this nigga guardbreaking for no reason ? fuk u
