extends PlayerState

func enter():
	AnimPlayer.play("wallsliding")

func update(delta):
	player.handle_horizontal_movement(player.AERIAL_SPEED)
	player.handle_vertical_movement(delta)
	if not player.is_on_wall():
		transitioned.emit("airborne")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
