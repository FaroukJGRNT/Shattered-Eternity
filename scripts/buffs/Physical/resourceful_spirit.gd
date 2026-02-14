extends Buff

var mana_mul := 0.8

func _init() -> void:
    has_timer = false

func activate(additional : Variant = null):
    daddy.mana_cons_multipliers.append(mana_mul)

func desactivate():
    pass
