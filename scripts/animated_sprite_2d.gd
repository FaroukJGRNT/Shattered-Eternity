extends AnimatedSprite2D
@export var hitbox : Area2D

func _on_frame_changed() -> void:
	if animation == "attack":
		match frame:
			4, 5: # frames où l’arme doit toucher
				hitbox.monitoring = true
				hitbox.active = true
			_:
				hitbox.monitoring = false
				hitbox.active = false
