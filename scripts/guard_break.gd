extends AllyHitBox

func _ready() -> void:
	can_stun = true
	motion_value = 20
	cam_shake_value = 10
	hitstop_time = 0.03
	hitstop_scale = 0.1
