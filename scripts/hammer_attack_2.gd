extends PlayerState

func enter():
	AnimPlayer.play("hammer_attack_2")

func update(delta):
	if Input.is_action_just_pressed("dash") and AnimPlayer.frame >= 4 :
		transitioned.emit("backdashing")
	if Input.is_action_just_pressed("dash") and AnimPlayer.frame >= 4:
		transitioned.emit("backdashing")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit("idle")
