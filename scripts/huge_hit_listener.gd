extends HitListener

func handle_guard(area : HitBox) -> GuardResult:
	if daddy.anim_player.animation == "guard" and area.facing * daddy.facing == -1:
		return GuardResult.BLOCK
	return GuardResult.HIT

func handle_guard_break(area : HitBox, current_state : State):
	if daddy.anim_player.animation == "guard" and area.is_guard_break:
		daddy.posture += (daddy.max_posture * 0.2)
		match daddy.poise_type:
			daddy.Poises.PLAYER:
				daddy.get_staggered()
				daddy.velocity.x += MEDIUM_PUSHBACK * area.facing
			daddy.Poises.SMALL:
				daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
			daddy.Poises.MEDIUM:
				daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
			daddy.Poises.LARGE:
				daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
		create_label(Color.ROYAL_BLUE, "GUARD BROKEN!", 1.3)
