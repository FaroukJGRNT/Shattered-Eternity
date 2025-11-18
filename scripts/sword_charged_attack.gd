extends AttackState

var deceleration = 10

func enter():
	player.velocity.x = -150 * player.facing
	super.enter()

func update(delta):
	super.update(delta)
	if player.velocity.x > 0:
		player.velocity.x -= deceleration
	if player.velocity.x < 0:
		player.velocity.x += deceleration
	player.move_and_slide()
