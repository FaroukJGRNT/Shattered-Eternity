extends Buff
class_name RevengeBuff

var attack_mul := 1.2

func _init() -> void:
	buff_type = BuffType.SITUATIONAL
	buff_name = "Revenge"
	buff_description = "Increases all offensive stats by 20% on hit taken"
	timeout = 7.0
	trigger_event = LivingEntity.Event.HIT_TAKEN

func activate(additional : Variant = null):
	daddy.attack_multipliers.append(attack_mul)
	daddy.thunder_attack_multipliers.append(attack_mul)
	daddy.ice_attack_multipliers.append(attack_mul)
	daddy.fire_attack_multipliers.append(attack_mul)

func desactivate():
	daddy.attack_multipliers.erase(attack_mul)
	daddy.thunder_attack_multipliers.erase(attack_mul)
	daddy.ice_attack_multipliers.erase(attack_mul)
	daddy.fire_attack_multipliers.erase(attack_mul)
