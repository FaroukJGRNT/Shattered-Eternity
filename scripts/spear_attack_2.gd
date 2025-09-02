extends PlayerState

var attack_again := false

func enter():
	AnimPlayer.play("spear_attack_2")

func update(delta):
	if Input.is_action_just_pressed("attack"):
		attack_again = true

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if attack_again:
		transitioned.emit("spearattack3")
	else:
		transitioned.emit("idle")
