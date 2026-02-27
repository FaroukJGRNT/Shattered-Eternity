extends Buff
class_name EnduranceBuff

var defense_mul := 0.2

func _init() -> void:
	buff_type = BuffType.SITUATIONAL
	item_name = "Endurance"
	item_description = "Increases physical defense by 20% on hit taken"
	timeout = 7.0
	trigger_event = LivingEntity.Event.HIT_TAKEN

func activate(additional : Variant = null):
	daddy.defense_multipliers.append(defense_mul)

func desactivate():
	daddy.defense_multipliers.erase(defense_mul)
