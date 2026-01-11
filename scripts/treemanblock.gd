extends EnemyAttackState

func enter():
	super.enter()
	AnimPlayer.frame = 0

func update(delta):
	super.update(delta)
	if enemy.velocity.x == 0:
		transitioned.emit("decide")

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
