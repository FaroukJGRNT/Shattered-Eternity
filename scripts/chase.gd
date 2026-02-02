extends EnemyState

func _init() -> void:
	is_state_blocking = true

func enter():
	AnimPlayer.play("walk")

func update(delta):
	# Check if close enough -> Then go to decide
	if enemy.is_target_in_close_range():
		transitioned.emit("decide")
		return
	# Move in direction of the target
	var direction = (enemy.target.position - enemy.position).normalized()
	enemy.velocity.x = enemy.SPEED * enemy.global_speed_scale * direction.x
	enemy.move_and_slide()
	enemy.direct_sprite()

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
