extends Buff

var bonus_attack := 0.0

func _init() -> void:
	timeout = 7.0
	trigger_event = LivingEntity.Event.ENEMY_KILLED

func activate():
	bonus_attack = daddy.attack * 0.2
	daddy.attack += bonus_attack

func desactivate():
	daddy.attack -= bonus_attack
