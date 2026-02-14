extends Buff

var bonus := 1.2

func _init() -> void:
	timeout = 7.0
	trigger_event = LivingEntity.Event.ENEMY_KILLED
 
func activate(additional : Variant = null):
	daddy.attack_multipliers.append(bonus)

func desactivate():
	daddy.attack_multipliers.erase(bonus)
