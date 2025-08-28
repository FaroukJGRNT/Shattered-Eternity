extends HitBox

func _ready() -> void:
	damage = owner.deal_damage(50)
	targeted_groups = ["Player"]
