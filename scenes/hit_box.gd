extends EnemyHitBox

func _ready() -> void:
	damage = owner.deal_damage(50)
