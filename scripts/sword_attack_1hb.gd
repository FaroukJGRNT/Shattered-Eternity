extends AllyHitBox

func _ready() -> void:
	damage = owner.deal_damage(40)
	cam_shake_value = 5
