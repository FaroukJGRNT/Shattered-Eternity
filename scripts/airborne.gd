extends PlayerState

func enter():
	AnimPlayer.play("jump")
	
func update(delta):
	if player.is_on_wall():
		transitioned.emit("wallsliding")
	# Change animation to fall when descending
	if player.velocity.y > 0 and AnimPlayer.animation == "jump":
		AnimPlayer.play("fall")

	player.initiate_slide()
	player.handle_vertical_movement(delta)
	player.handle_horizontal_movement(player.AERIAL_SPEED)
	
func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
