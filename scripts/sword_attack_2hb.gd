extends AllyHitBox

func _ready() -> void:
	damage = owner.deal_damage(50)
	cam_shake_value = 6
