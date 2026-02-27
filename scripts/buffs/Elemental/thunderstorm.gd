extends Buff
class_name ThunderstormBuff

var mul := 1.2

func _init() -> void:
	super._init()
	is_one_shot = true
	buff_type = BuffType.ELEMENTAL
	item_name = "Thunderstorm"
	item_description = "Increases permanently thunder attack by 20%"
	has_timer = false

func activate(additional : Variant = null):
	daddy.thunder_attack_multipliers.append(mul)

func desactivate():
	pass
