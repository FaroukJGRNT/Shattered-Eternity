extends PlayerState

func enter():
	AnimPlayer.play("run")

func update(delta):
	player.initiate_ground_actions()
	var speed = player.RUN_SPEED
	if player.resonance_value >= 100:
		speed += speed / 3	
	player.handle_horizontal_movement(speed, delta)

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
