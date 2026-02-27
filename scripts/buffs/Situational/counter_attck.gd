extends Buff
class_name CounterAtkBuff

var crit_mul := 1.5

func _init() -> void:
	super._init()
	buff_type = BuffType.SITUATIONAL
	item_name = "Counter Attack"
	item_description = "Increases critical damage by 50% after a parry"
	timeout = 4.0
	trigger_event = LivingEntity.Event.PARRY

func activate(additional : Variant = null):
	daddy.crit_multipliers.append(crit_mul)

func desactivate():
	daddy.crit_multipliers.erase(crit_mul)
