extends Buff

var life_mul := 1.2

func _init() -> void:
    has_timer = false

func activate(additional : Variant = null):
    daddy.max_life *= life_mul

func desactivate():
    pass
