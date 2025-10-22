extends ProgressBar

@export var life_bar : TextureProgressBar

func update_bar(dmg) -> void:
	max_value = life_bar.max_value
	value = life_bar.value + dmg
	
	var tween = create_tween()
	tween.tween_property(self, "value", life_bar.value, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
