extends ProjectileTemplate

func _process(delta: float) -> void:
	super._process(delta)
	if not target:
		print("Leaving")
		return
	if target.position.distance_to(position) <= $EnemyHitBox/CollisionShape2D.shape.radius:
		if target.state_machine.get_current_state() is EvadeState:
			hitbox.desactivate()
			print("Player detected evading, deactivatedd")
