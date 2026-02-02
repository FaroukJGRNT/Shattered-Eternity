extends HitBox
class_name AllyAerialHitBox

@export var up_value := 0

func on_hit():
	if not life_used:
		if owner.velocity.y < 0:
			owner.velocity.y -= up_value / 2
		elif owner.velocity.y >= 0 and owner.velocity.y <= 50:
			owner.velocity.y -= up_value * 4
		else:
			owner.velocity.y -= up_value * 5

		life_used = true
