extends Buff

var crit_mul := 1.5

func _init() -> void:
    timeout = 4.0
    trigger_event = LivingEntity.Event.PARRY

func activate(additional : Variant = null):
    daddy.crit_multipliers.append(crit_mul)

func desactivate():
    daddy.crit_multipliers.erase(crit_mul)
