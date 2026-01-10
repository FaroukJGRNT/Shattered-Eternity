extends BasicEnemy

func enemy_ai():
	# Bro has no defensive
	
	# Priority event : Enemy close behind us
	if is_target_close() and not is_target_in_front() and $EnemyStateMachine/Kick.option_timer <= 0:
		state_machine.on_state_transition("kick")
		return

	if not is_target_in_front():
		turn_around()	
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
			state_machine.on_state_transition("tackle")
			return
	# Is the target close
	else:
		state_machine.on_state_transition("tackle")


	# Potentially custom stuff: (Enemy behind me --> reverse)
	# Or is this nigga guardbreaking for no reason ? fuk u
