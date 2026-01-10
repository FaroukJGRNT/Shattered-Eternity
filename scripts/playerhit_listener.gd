extends HitListener

@export var parry_recoil := 7.0
@export var max_parry_speed := 450.0

@export var guard_recoil := 14.0
@export var max_guard_speed := 850.0

func handle_guard(area : HitBox) -> GuardResult: 
	if daddy.get_state() == "guard":
		if daddy.facing * area.facing == -1:
			if daddy.anim_player.animation == "guard_start":
				daddy.change_state("parry")
				if area.owner is LivingEntity:
					area.owner.get_stunned(20, 0.6)
				daddy.velocity.x = min(area.motion_value * parry_recoil, max_parry_speed)
				daddy.velocity.x *= area.facing
				daddy.hurtbox.desactivate()
				return GuardResult.PARRY
			daddy.velocity.x = min(area.motion_value * guard_recoil, max_guard_speed)
			daddy.velocity.x *= area.facing
			return GuardResult.BLOCK
	return GuardResult.HIT

func update_lifebar(dmg):
	var lb = get_tree().get_first_node_in_group("PlayerHealthBar")
	lb.update_health_bar(dmg)
