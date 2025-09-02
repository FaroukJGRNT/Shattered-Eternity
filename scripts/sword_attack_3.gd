extends PlayerState

func enter():
	AnimPlayer.play("sword_attack_3")

func update(delta):
	pass

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit("idle")
