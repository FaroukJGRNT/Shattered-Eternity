extends EnemyAttackState

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if AnimPlayer.animation == "guard_start":
		AnimPlayer.play("guard")
	elif AnimPlayer.animation == "guard":
		AnimPlayer.play_backwards("guard_end")
	else:
		get_parent().get_node("Recovery").timer = attack_cooldown
		transitioned.emit("recovery")
		if recov_anim_name == "":
			recov_anim_name = "idle"
		AnimPlayer.play(recov_anim_name)
