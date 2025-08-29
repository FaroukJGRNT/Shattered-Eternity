extends AnimatedSprite2D
@export var hitbox : Area2D
@export var hurtbox : Area2D

func _on_frame_changed() -> void:
	if animation == "attack":
		match frame:
			4, 5: # frames où l’arme doit toucher
				hitbox.monitoring = true
				hitbox.active = true
			_:
				hitbox.monitoring = false
				hitbox.active = false
	if animation == "slide":
		print("I Frames")
		match frame:
			0, 1, 2: # frames où le joueur est invulnereable
				hurtbox.monitoring = false
				hurtbox.disabled = true
			_:
				hurtbox.monitoring = true
				hurtbox.disabled = false
