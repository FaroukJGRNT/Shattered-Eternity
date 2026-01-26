extends AttackState

var deceleration_ = 18

func enter():
	player.velocity.x = -280 * player.facing
	super.enter()

func update(delta):
	super.update(delta)
	if player.velocity.x > 0:
		player.velocity.x -= deceleration_ * delta * 50
	if player.velocity.x < 0:
		player.velocity.x += deceleration_ * delta * 50
	player.move_and_slide()
