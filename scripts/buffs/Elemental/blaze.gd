extends Buff
class_name BlazeBuff

var mul := 1.2

func _init() -> void:
    is_one_shot = true
    buff_type = BuffType.ELEMENTAL
    buff_name = "Blaze"
    buff_description = "Increases permanently fire attack by 20%"
    has_timer = false

func activate(additional : Variant = null):
    daddy.fire_attack_multipliers.append(mul)

func desactivate():
    pass
