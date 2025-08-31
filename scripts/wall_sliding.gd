extends PlayerState

func enter():
	AnimPlayer.play("wallsliding")

func update(delta):
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.JUMP_VELOCITY
		player.velocity.x = -800 * player.facing
		player.move_and_slide()
		transitioned.emit("airborne")
		player.direction *= -1
		player.facing *= -1
		return
	player.handle_vertical_movement(delta)
	if player.is_on_floor():
		transitioned.emit("idle")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
