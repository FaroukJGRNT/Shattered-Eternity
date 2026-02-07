extends PlayerState

func _init() -> void:
	is_state_blocking = true

func enter():
	player.dead = true
	AnimPlayer.play("death")

func update(delta):
	player.velocity = Vector2(0, -50)
	player.move_and_slide()

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	Toolbox.handle_event(Toolbox.GameEvents.PLAYER_DEAD, owner)
