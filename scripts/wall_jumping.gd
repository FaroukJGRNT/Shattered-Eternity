extends PlayerState

func enter():
	player.velocity.y = player.JUMP_VELOCITY
	AnimPlayer.play("walljumping")
	
func update(delta):
	player.velocity.x = player.AERIAL_SPEED * 2 * player.facing * -1
	# Change state descending
	if player.velocity.y >= 10:
		transitioned.emit("airborne")
	if player.is_on_floor():
		transitioned.emit("idle")

	player.handle_vertical_movement(delta)
	
func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
