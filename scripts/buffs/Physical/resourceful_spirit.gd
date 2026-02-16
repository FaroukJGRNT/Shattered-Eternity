extends Buff
class_name ResourcefulSpiritBuff

var mana_mul := 0.8

func _init() -> void:
    is_one_shot = true
    buff_type = BuffType.PHYSICAL
    buff_name = "Resourceful Spirit"
    buff_description = "Reduces permanently mana consumption by 20%"
    has_timer = false

func activate(additional : Variant = null):
    daddy.mana_cons_multipliers.append(mana_mul)

func desactivate():
    pass
