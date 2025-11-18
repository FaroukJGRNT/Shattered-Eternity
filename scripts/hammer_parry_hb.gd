extends AllyHitBox

func _ready() -> void:
	can_stun = true
	motion_value = 80
	cam_shake_value = 20
	hitstop_time = 0.07
	hitstop_scale = 0.1
