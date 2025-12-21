extends ParryAttackState

var deceleration_ = 60

func update(delta):
	super.update(delta)
	if AnimPlayer.frame == 0:
		player.velocity.x = 750 * player.facing
	if player.velocity.x > 0:
		player.velocity.x -= deceleration_
	if player.velocity.x < 0:
		player.velocity.x += deceleration_
	player.move_and_slide()
