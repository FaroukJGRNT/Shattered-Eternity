extends PlayerState

func enter():
	AnimPlayer.play("spear_attack_4")

func update(delta):
	pass

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit("idle")
