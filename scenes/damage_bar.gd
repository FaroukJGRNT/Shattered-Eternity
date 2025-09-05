extends ProgressBar

@export var life_bar : TextureProgressBar

func _on_enemy_damage_taken() -> void:
	max_value = life_bar.max_value
	value = life_bar.value
	$Timer.start()


func _on_timer_timeout() -> void:
	# Crée un tween
	var tween = create_tween()
	# Anime la propriété "value" de cette ProgressBar
	tween.tween_property(self, "value", life_bar.value, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
