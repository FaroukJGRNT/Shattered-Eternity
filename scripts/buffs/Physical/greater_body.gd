extends Buff
class_name GreaterBodyBuff

var life_mul := 1.2

func _init() -> void:
    is_one_shot = true
    buff_type = BuffType.PHYSICAL
    buff_name = "Greater Body"
    buff_description = "Increases permanently max life by 20%"
    has_timer = false

func activate(additional : Variant = null):
    daddy.max_life *= life_mul

func desactivate():
    pass
