extends AnimatedSprite2D
@export var s_hitbox1 : Area2D
@export var s_hitbox2 : Area2D
@export var s_hitbox3 : Area2D

@export var s_hitbox4 : Area2D
@export var s_hitbox5 : Area2D
@export var s_hitbox6 : Area2D

@export var hurtbox : Area2D

func _process(delta: float) -> void:
	pass

func _on_frame_changed() -> void:
	# default reset
	hurtbox.disabled = false
	hurtbox.monitoring = true
	s_hitbox1.active = false
	s_hitbox2.active = false
	s_hitbox3.active = false
	s_hitbox4.active = false
	s_hitbox5.active = false
	s_hitbox6.active = false
	s_hitbox1.monitoring = false
	s_hitbox2.monitoring = false
	s_hitbox3.monitoring = false
	s_hitbox4.monitoring = false
	s_hitbox5.monitoring = false
	s_hitbox6.monitoring = false
	if animation == "sword_attack_1":
		match frame:
			2: # frames où l’arme doit toucher
				s_hitbox1.monitoring = true
				s_hitbox1.active = true
			_:
				s_hitbox1.monitoring = false
				s_hitbox1.active = false
	if animation == "sword_attack_2":
		match frame:
			1: # frames où l’arme doit toucher
				s_hitbox2.monitoring = true
				s_hitbox2.active = true
			_:
				s_hitbox2.monitoring = false
				s_hitbox2.active = false
	if animation == "sword_attack_3":
		match frame:
			1: # frames où l’arme doit toucher
				s_hitbox3.monitoring = true
				s_hitbox3.active = true
			_:
				s_hitbox3.monitoring = false
				s_hitbox3.active = false

	if animation == "hammer_attack_1":
		match frame:
			6: # frames où l’arme doit toucher
				s_hitbox4.monitoring = true
				s_hitbox4.active = true
			_:
				s_hitbox4.monitoring = false
				s_hitbox4.active = false
	if animation == "hammer_attack_2":
		match frame:
			2, 3: # frames où l’arme doit toucher
				s_hitbox5.monitoring = true
				s_hitbox5.active = true
			_:
				s_hitbox5.monitoring = false
				s_hitbox5.active = false
	if animation == "hammer_charged_attack":
		match frame:
			1: # frames où l’arme doit toucher
				s_hitbox6.monitoring = true
				s_hitbox6.active = true
			_:
				s_hitbox6.monitoring = false
				s_hitbox6.active = false

	if animation == "slide":
		match frame:
			0, 1, 2: # frames où le joueur est invulnerable
				hurtbox.monitoring = false
				hurtbox.disabled = true
			_:
				hurtbox.monitoring = true
				hurtbox.disabled = false
