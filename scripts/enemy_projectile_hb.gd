extends HitBox
class_name ProjectileHitBox

# Custom HitBox for projectiles
# Will call on_hit on hit lol

func on_hit():
	super.on_hit()
	owner.on_hit()
