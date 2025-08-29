extends PlayerState

func enter():
	player.velocity.y = -250
	AnimPlayer.play("hit")

func update(delta):
	player.velocity.x = player.facing * -250
	if player.is_on_floor():
		transitioned.emit("idle")
	player.handle_vertical_movement(delta)

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
