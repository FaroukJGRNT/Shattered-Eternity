extends ProgressBar

func update_bar(dmg) -> void:
	print("I'm being updated")
	max_value = get_parent().max_value
	value = get_parent().value + dmg
	print(max_value)
	print(dmg)
	print(value)
	
	
	var tween = create_tween()
	tween.tween_property(self, "value", get_parent().value, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _ready() -> void:
	max_value = owner.max_life
	value = max_value
