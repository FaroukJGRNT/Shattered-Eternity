extends EnemyHitBox

func _ready() -> void:
	is_guard_break = true
	is_phys_atk = false
	motion_value = 18
	cam_shake_value = 5
	hitstop_time = 0.05
	hitstop_scale = 0.1
