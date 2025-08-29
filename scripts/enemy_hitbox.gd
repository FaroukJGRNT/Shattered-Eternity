extends HitBox
class_name EnemyHitBox

func _init() -> void:
	super()
	targeted_groups = ["Player"]
