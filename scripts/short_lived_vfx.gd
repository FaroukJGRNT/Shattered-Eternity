extends AnimatedSprite2D
class_name ShortLivedVFX

func _on_animation_finished() -> void:
	queue_free()
