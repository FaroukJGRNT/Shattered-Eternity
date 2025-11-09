extends AttackState

func update(delta):
	super.update(delta)
	if AnimPlayer.frame < 2:
		player.handle_horizontal_movement(player.RUN_SPEED / 6)
