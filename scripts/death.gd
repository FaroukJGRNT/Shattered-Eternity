extends EnemyState

func enter():
	AnimPlayer.play("death")

func update(delta):
	pass
func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	owner.queue_free()
