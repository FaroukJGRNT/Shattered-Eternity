extends EnemyAttackState

func on_animation_end():
	if not enemy.is_target_in_close_range():
		transitioned.emit("recovery")
		get_parent().get_node("Recovery").timer = attack_cooldown
	else:
		transitioned.emit(combo_state)
		return

	if recov_anim_name == "":
		recov_anim_name = "idle"
	AnimPlayer.play(recov_anim_name)
