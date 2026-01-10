extends PlayerState

func _ready() -> void:
	is_state_blocking = true

func enter():
	AnimPlayer.play("landing")

func update(delta):
	player.get_horizontal_input()
	if player.direction != 0 and AnimPlayer.frame >= 1:
		transitioned.emit("idle")
	player.handle_horizontal_movement(player.RUN_SPEED/1.75)
	player.direct_sprite()
	player.initiate_ground_actions()
	player.move_and_slide()

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit("idle")
