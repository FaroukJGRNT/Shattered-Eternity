extends EnemyAttackState

@export var custom_decel = 5

func update(delta):
	if AnimPlayer.frame > 10 and AnimPlayer.frame < 23:
		enemy.velocity.x = 400 * enemy.facing
		enemy.move_and_slide()
		return
	if AnimPlayer.frame < 8:
		if not enemy.is_target_in_front():
			enemy.turn_around()

	if enemy.velocity.x > 0:
		enemy.velocity.x = max(enemy.velocity.x - custom_decel * delta * 50, 0)
	if enemy.velocity.x < 0:
		enemy.velocity.x = min(enemy.velocity.x + custom_decel * delta * 50, 0)
	enemy.move_and_slide()
