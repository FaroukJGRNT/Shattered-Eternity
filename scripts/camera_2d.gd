extends Camera2D

var shake_str : float = 0.0
var fade: float = 10.0

func trigger_shake(max_shake: float, _fade: float = fade):
	shake_str = max_shake
	fade =  _fade

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_str > 0.0:
		shake_str = lerp(shake_str, 0.0, fade * delta)
		offset = Vector2(randf_range(-shake_str, shake_str), randf_range(-shake_str, shake_str))
	else:
		offset = Vector2(0, 0)
