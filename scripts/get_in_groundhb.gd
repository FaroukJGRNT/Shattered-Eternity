extends EnemyHitBox

func _init() -> void:
	super._init()
	is_phys_atk = true
	motion_value = 40
	cam_shake_value = 5
	hitstop_time = 0.05
	hitstop_scale = 0.1
