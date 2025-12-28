extends Buff

var bonus_defense := 0.0

func _init() -> void:
	timeout = 7.0
	trigger_event = LivingEntity.Event.HIT_TAKEN

func activate():
	bonus_defense = daddy.defense * 0.2
	daddy.defense += bonus_defense

func desactivate():
	daddy.defense -= bonus_defense
