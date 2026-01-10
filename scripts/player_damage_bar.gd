extends ProgressBar

func update_bar(dmg) -> void:
	max_value = get_parent().max_value
	value = get_parent().value + dmg
	
	var tween = create_tween()
	tween.tween_property(self, "value", get_parent().value, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _ready() -> void:
	max_value = 100
	value = 100
