extends TextureProgressBar

func _process(delta: float) -> void:
	max_value = owner.max_posture
	value = owner.posture
