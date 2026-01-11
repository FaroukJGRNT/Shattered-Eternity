extends HitBox
class_name AllyHitBox

func _init() -> void:
	super()
	targeted_groups = ["Enemy", "EnemyProjectile"]
