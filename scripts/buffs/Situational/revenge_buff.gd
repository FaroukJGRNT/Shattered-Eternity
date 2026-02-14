extends Buff

var attack_mul := 1.2

func _init() -> void:
	timeout = 7.0
	trigger_event = LivingEntity.Event.HIT_TAKEN

func activate():
	daddy.attack_multipliers.append(attack_mul)
	daddy.thunder_attack_multipliers.append(attack_mul)
	daddy.ice_attack_multipliers.append(attack_mul)
	daddy.fire_attack_multipliers.append(attack_mul)

func desactivate():
	daddy.attack_multipliers.erase(attack_mul)
	daddy.thunder_attack_multipliers.erase(attack_mul)
	daddy.ice_attack_multipliers.erase(attack_mul)
	daddy.fire_attack_multipliers.erase(attack_mul)
