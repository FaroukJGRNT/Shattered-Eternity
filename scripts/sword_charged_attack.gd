extends AttackState

var deceleration_ = 10

func enter():
	player.velocity.x = -150 * player.facing
	super.enter()

func update(delta):
	super.update(delta)
	if player.velocity.x > 0:
		player.velocity.x -= deceleration_
	if player.velocity.x < 0:
		player.velocity.x += deceleration_
	player.move_and_slide()
