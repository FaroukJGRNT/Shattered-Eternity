extends AllyHitBox

func _ready() -> void:
	damage = owner.deal_damage(40)
	cam_shake_value = 5
	hitstop_time = 0.08
	hitstop_scale = 0.1
