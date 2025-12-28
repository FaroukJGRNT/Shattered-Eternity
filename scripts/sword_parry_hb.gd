extends AllyHitBox

func _ready() -> void:
	push_back = Pushback.STRONG
	motion_value = 150
	cam_shake_value = 35
	hitstop_time = 0.07
	hitstop_scale = 0.1
