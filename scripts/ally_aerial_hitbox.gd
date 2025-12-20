extends AllyHitBox
class_name AllyAerialHitBox

@export var up_value := 0

func on_hit():
	owner.velocity.y -= up_value
