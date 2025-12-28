extends Buff

var bonus_attack := 0.0

func _init() -> void:
	timeout = 7.0
	trigger_event = LivingEntity.Event.HIT_TAKEN

func activate():
	print("Buff activated !!!!")
	print("Atk before buff: ", daddy.attack)
	bonus_attack = daddy.attack * 0.2
	daddy.attack += bonus_attack
	print("Atk after buff: ", daddy.attack)

func desactivate():
	daddy.attack -= bonus_attack
