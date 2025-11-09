extends AttackState
class_name AerialAttack

func enter():
	super.enter()
	player.velocity.x = 0
	player.velocity.y = 5

func update(delta):
	super.update(delta)
	player.handle_vertical_movement(player.get_gravity().y * delta)
	if player.is_on_floor():
		transitioned.emit("landing")

func exit():
	super.exit()
	player.friction = 0
# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if recovery_state_name == "":
		recovery_state_name = "airborne"
	if attack_again:
		if next_combo_state_name == "":
			AnimPlayer.play("fall")
			transitioned.emit("airborne")
		else:
			transitioned.emit(next_combo_state_name)
	else:
		AnimPlayer.play("fall")
		transitioned.emit("airborne")
