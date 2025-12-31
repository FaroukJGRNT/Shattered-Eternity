extends AllyHitBox

func _ready() -> void:
	push_back = Pushback.STRONG
	motion_value = 60
	cam_shake_value = 25
	hitstop_time = 0.07
	hitstop_scale = 0.1
