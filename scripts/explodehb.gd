extends EnemyHitBox

func _init() -> void:
	super._init()
	multidirectional = true
	is_phys_atk = true
	motion_value = 100
