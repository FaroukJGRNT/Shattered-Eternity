extends AllyHitBox

func _init() -> void:
	super()
	active = true
	motion_value = 25
	cam_shake_value = 7
	hitstop_time = 0.08
	hitstop_scale = 0.3
