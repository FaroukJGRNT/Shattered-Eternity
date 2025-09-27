extends PlayerState

var attack_again := false
var charge_timer := 0.0

func enter():
	charge_timer = 0.0
	attack_again = false
	AnimPlayer.play("hammer_attack_1")

func update(delta):
	# Handle charged attack
	if Input.is_action_pressed("attack"):
		charge_timer += delta
	else:
		charge_timer = 0.0
		
	if charge_timer >= 0.20:
		transitioned.emit("hammercharging")
		return

	player.handle_horizontal_movement(player.RUN_SPEED / 8)
	if Input.is_action_just_pressed("attack") and AnimPlayer.frame >= 6:
		attack_again = true
	if Input.is_action_just_pressed("dash") and AnimPlayer.frame >= 7:
		transitioned.emit("backdashing")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if attack_again:
		transitioned.emit("hammerattack2")
	else:
		AnimPlayer.play("hammer_recovery_1")
		transitioned.emit("heavyattackrecovery")
