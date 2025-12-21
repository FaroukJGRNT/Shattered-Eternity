extends ParryAttackState

var deceleration_ = 10

func enter():
	super.enter()
	print("ENTERING HAMMER PARRY")

func update(delta):
	super.update(delta)
	if AnimPlayer.frame == 4:
		player.velocity.x = 250 * player.facing
	if player.velocity.x > 0:
		player.velocity.x -= deceleration_
	if player.velocity.x < 0:
		player.velocity.x += deceleration_
	player.move_and_slide()
