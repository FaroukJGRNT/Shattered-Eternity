extends PlayerState

func _init() -> void:
	is_state_blocking = true

func enter():
	pass
func update(delta):
	player.initiate_ground_actions()

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit("idle")
