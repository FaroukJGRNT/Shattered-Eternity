extends ParryAttackState

func exit():
	super.exit()
	player.velocity.x = 0
