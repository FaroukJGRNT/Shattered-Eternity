extends EnemyState

func _init() -> void:
	is_state_blocking = true

func enter():
	enemy.dead = true
	AnimPlayer.play("death")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	owner.queue_free()
