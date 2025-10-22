extends AttackState

func enter():
	AnimPlayer.play("sword_attack_3")

func update(delta):
	if Input.is_action_just_pressed("dash") and AnimPlayer.frame >= 2:
		transitioned.emit("backdashing")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit("idle")
