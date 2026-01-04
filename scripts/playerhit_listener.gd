extends HitListener

func handle_guard(area : HitBox) -> GuardResult: 
	if daddy.get_state() == "guard":
		if daddy.facing * area.facing == -1:
			if daddy.anim_player.animation == "guard_start":
				daddy.change_state("parry")
				if area.owner is LivingEntity:
					area.owner.get_stunned(20, 0.6)
				daddy.velocity.x = min(area.motion_value * 14, 850)
				daddy.velocity.x *= area.facing
				daddy.hurtbox.desactivate()
				return GuardResult.PARRY
			daddy.velocity.x = min(area.motion_value * 14, 850)
			daddy.velocity.x *= area.facing
			return GuardResult.BLOCK
	return GuardResult.HIT
