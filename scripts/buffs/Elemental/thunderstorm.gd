extends Buff

var mul := 1.2

func _init() -> void:
    has_timer = false

func activate(additional : Variant = null):
    daddy.thunder_attack_multipliers.append(mul)

func desactivate():
    pass
