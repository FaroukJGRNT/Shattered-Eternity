extends PlayerState

func _ready() -> void:
	is_state_blocking = true

func enter():
	AnimPlayer.play("jump_start")

func update(delta):
	player.handle_horizontal_movement(player.RUN_SPEED/10, delta)

func exit():
	player.velocity.y = player.JUMP_VELOCITY
	if player.velocity.x >= player.AERIAL_SPEED:
		player.velocity.x = player.AERIAL_SPEED * player.global_speed_scale

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit("airborne")
