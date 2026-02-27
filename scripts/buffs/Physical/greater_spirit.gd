extends Buff
class_name GreaterSpiritBuff

var mana_mul := 1.2

func _init() -> void:
	super._init()
	is_one_shot = true
	buff_type = BuffType.PHYSICAL
	item_name = "Greater Spirit"
	item_description = "Increases permanently max mana by 20%"
	has_timer = false

func activate(additional : Variant = null):
	daddy.max_mana *= mana_mul

func desactivate():
	pass
