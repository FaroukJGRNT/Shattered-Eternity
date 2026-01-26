extends PlayerState

func enter():
	AnimPlayer.play("run")

func update(delta):
	player.initiate_ground_actions()
	player.handle_horizontal_movement(player.RUN_SPEED, delta)

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
