extends ParryAttackState

var deceleration = 10

func enter():
	super.enter()
	print("ENTERING HAMMER PARRY")

func update(delta):
	super.update(delta)
	if AnimPlayer.frame == 4:
		player.velocity.x = 250 * player.facing
	if player.velocity.x > 0:
		player.velocity.x -= deceleration
	if player.velocity.x < 0:
		player.velocity.x += deceleration
	player.move_and_slide()
