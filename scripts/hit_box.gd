extends EnemyHitBox

func _ready() -> void:
	motion_value = 20
	cam_shake_value = 5
	hitstop_time = 0.05
	hitstop_scale = 0.1
