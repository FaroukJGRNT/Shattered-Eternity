extends Projectile

func set_premade_damage(entity : LivingEntity):
	$EnemyHitBox.premade_dmg = entity.deal_damage($EnemyHitBox.motion_value, $EnemyHitBox.atk_type)

func _process(delta: float) -> void:
	super._process(delta)
	if not get_parent().owner:
		var par = get_parent()
		var ow = get_parent().owner
		return
	print("WE HAVE SOMETHING")
	if get_parent().owner.target.position.distance_to(position) <= $EnemyHitBox/CollisionShape2D.shape.radius:
		if get_parent().owner.target.state_machine.get_current_state() is EvadeState:
			$EnemyHitBox.desactivate()
