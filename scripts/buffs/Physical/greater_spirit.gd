extends Buff
class_name GreaterSpiritBuff

var mana_mul := 1.2

func _init() -> void:
    is_one_shot = true
    buff_type = BuffType.PHYSICAL
    buff_name = "Greater Spirit"
    buff_description = "Increases permanently max mana by 20%"
    has_timer = false

func activate(additional : Variant = null):
    daddy.max_mana *= mana_mul

func desactivate():
    pass
