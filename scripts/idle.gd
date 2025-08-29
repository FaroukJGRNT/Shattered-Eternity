extends PlayerState

func enter():
	AnimPlayer.play("idle")

func update(delta):
	player.initiate_ground_actions()
	player.handle_horizontal_movement(player.RUN_SPEED)

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
