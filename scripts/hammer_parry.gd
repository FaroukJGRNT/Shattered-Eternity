extends ParryAttackState

var deceleration_ = 10

func enter():
	super.enter()

func update(delta):
	super.update(delta)
	if AnimPlayer.frame == 4:
		player.velocity.x = 250 * player.facing
	if player.velocity.x > 0:
		player.velocity.x -= deceleration_ * 100 * delta
	if player.velocity.x < 0:
		player.velocity.x += deceleration_ * 100 * delta
	player.move_and_slide()
