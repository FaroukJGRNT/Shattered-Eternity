extends HitBox

# Is called whenever the hitbox deals damage to a hurtbox
func on_hit():
	owner.on_hit()
