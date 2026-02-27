extends Buff
class_name VoraciousSpiritBuff

var mana_mul := 1.2

func _init() -> void:
	super._init()
	is_one_shot = true
	buff_type = BuffType.PHYSICAL
	item_name = "Voracious Spirit"
	item_description = "Increases permanently mana regeneration by 20%"
	has_timer = false

func activate(additional : Variant = null):
	daddy.mana_regen_multipliers.append(mana_mul)

func desactivate():
	pass
