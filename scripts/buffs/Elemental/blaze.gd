extends Buff
class_name BlazeBuff

var mul := 1.2

func _init() -> void:
	super._init()
	is_one_shot = true
	buff_type = BuffType.ELEMENTAL
	item_name = "Blaze"
	item_description = "Increases permanently fire attack by 20%"
	has_timer = false

func activate(additional : Variant = null):
	daddy.fire_attack_multipliers.append(mul)

func desactivate():
	pass
