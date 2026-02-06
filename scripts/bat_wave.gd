extends ProjectileTemplate

func _process(delta: float) -> void:
	super._process(delta)
	if not target:
		return
	if target.position.distance_to(position) <= $EnemyHitBox/CollisionShape2D.shape.radius:
		if target.state_machine.get_current_state() is EvadeState:
			hitbox.desactivate()
			("Player detected evading, deactivatedd")
