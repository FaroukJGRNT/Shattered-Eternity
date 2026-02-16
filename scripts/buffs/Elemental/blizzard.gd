extends Buff
class_name BlizzardBuff

var mul := 1.2

func _init() -> void:
    is_one_shot = true
    buff_type = BuffType.ELEMENTAL
    buff_name = "Blizzard"
    buff_description = "Increases permanently ice attack by 20%"
    has_timer = false

func activate(additional : Variant = null):
    daddy.ice_attack_multipliers.append(mul)

func desactivate():
    pass
