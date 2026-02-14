extends Buff

var mana_mul := 1.2

func _init() -> void:
    has_timer = false

func activate(additional : Variant = null):
    daddy.max_mana *= mana_mul

func desactivate():
    pass
