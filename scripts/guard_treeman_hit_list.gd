extends HitListener

func handle_guard(area : HitBox) -> GuardResult:
	print("IT WAS FACING: ", area.facing)
	if daddy.state_machine.get_current_state().name != "Staggered" and daddy.facing * area.facing == -1:
		if daddy.state_machine.get_current_state().name == "Attack":
			return GuardResult.BLOCK
		daddy.state_machine.on_state_transition("block")
		daddy.velocity.x = min(area.motion_value * 5.5, 250)
		daddy.velocity.x *= area.facing
		return GuardResult.BLOCK
	return GuardResult.HIT

func handle_guard_break(area : HitBox):
	if daddy.state_machine.get_current_state().name != "Staggered" and daddy.facing * area.facing == -1:
		daddy.posture += daddy.max_posture
		daddy.velocity.x += 100 * area.facing
		create_label(Color.ROYAL_BLUE, "GUARD BROKEN!", 1.3)
