extends HitListener

# To customly handle guards. True if guarded, false if not
func handle_guard(area : HitBox) -> GuardResult:
	if daddy.get_state() == "guard":
			return GuardResult.BLOCK
	return GuardResult.HIT

func update_lifebar(dmg : int):
	life_bar.update_health_bar(dmg)
