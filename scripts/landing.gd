extends PlayerState

func enter():
	AnimPlayer.play("landing")

func update(delta):
	player.handle_horizontal_movement(player.RUN_SPEED/2)
	player.direct_sprite()
	player.initiate_ground_actions()

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit("idle")
