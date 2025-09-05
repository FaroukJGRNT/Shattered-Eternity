extends PlayerState

var attack_again := false

func enter():
	attack_again = false
	AnimPlayer.play("sword_attack_1")

func update(delta):
	if Input.is_action_just_pressed("attack"):
		attack_again = true
	if Input.is_action_just_pressed("dash") and AnimPlayer.frame >= 3:
		transitioned.emit("backdashing")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if attack_again:
		transitioned.emit("swordattack2")
	else:
		transitioned.emit("idle")
