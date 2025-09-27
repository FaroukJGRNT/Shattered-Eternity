extends PlayerState

func enter():
	print("Charging")
	AnimPlayer.play("hammer_charging")

func update(delta):
	if AnimPlayer.frame >= 2:
		AnimPlayer.play("hammer_charged")

	if Input.is_action_just_released("attack") and AnimPlayer.animation == "hammer_charged":
		transitioned.emit("hammerchargedattack")
		return

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
