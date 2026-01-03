extends HitListener

func handle_guard(area : HitBox) -> GuardResult: 
	if daddy.get_state() == "guard":
		if daddy.facing * area.facing == -1:
			if daddy.anim_player.animation == "guard_start":
				daddy.change_state("parry")
				area.owner.get_stunned(30, 0.6)
				daddy.velocity.x = area.motion_value * area.facing * 20
				daddy.hurtbox.desactivate()
				return GuardResult.PARRY
			daddy.velocity.x = area.motion_value * area.facing * 20
			return GuardResult.BLOCK
	return GuardResult.HIT
