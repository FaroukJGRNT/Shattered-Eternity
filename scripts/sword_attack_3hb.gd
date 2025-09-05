extends AllyHitBox

func _ready() -> void:
	damage = owner.deal_damage(60)
	cam_shake_value = 7
