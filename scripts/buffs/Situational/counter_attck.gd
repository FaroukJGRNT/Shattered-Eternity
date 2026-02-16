extends Buff
class_name CounterAtkBuff

var crit_mul := 1.5

func _init() -> void:
    buff_type = BuffType.SITUATIONAL
    buff_name = "Counter Attack"
    buff_description = "Increases critical damage by 50% after a parry"
    timeout = 4.0
    trigger_event = LivingEntity.Event.PARRY

func activate(additional : Variant = null):
    daddy.crit_multipliers.append(crit_mul)

func desactivate():
    daddy.crit_multipliers.erase(crit_mul)
