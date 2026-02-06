extends EnemyAttackState

@export var custom_decel = 5

func update(delta):
	if AnimPlayer.frame < 10:
		if not enemy.is_target_in_front():
			enemy.turn_around()

	var index = 0
	for frame in usable_mov_frames:
		if AnimPlayer.frame == frame:
			enemy.velocity.x += (usable_velocs[index].x) * enemy.facing
			enemy.velocity.y += (usable_velocs[index].y)
			usable_mov_frames.pop_front()
			usable_velocs.pop_front()
			break
		index += 1
	
	if AnimPlayer.frame >= 23:

		if enemy.velocity.x > 0:
			enemy.velocity.x = max(enemy.velocity.x - custom_decel * delta * 30, 0)
		if enemy.velocity.x < 0:
			enemy.velocity.x = min(enemy.velocity.x + custom_decel * delta * 30, 0)
	enemy.move_and_slide()
