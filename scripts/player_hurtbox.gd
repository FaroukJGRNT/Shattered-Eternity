extends HurtBox
class_name PlayerHurtBox

var timer := 1.0
var on_cooldown := false

func _process(delta: float) -> void:
	if on_cooldown:
		timer -= delta
		if timer <= 0:
			on_cooldown = false
			timer = 1.0
