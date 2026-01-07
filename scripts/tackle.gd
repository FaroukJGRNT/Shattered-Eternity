extends EnemyAttackState

@export var custom_decel = 25

func update(delta):
	var index = 0
	for frame in usable_mov_frames:
		if AnimPlayer.frame == frame:
			enemy.velocity.x += (usable_velocs[index].x) * enemy.facing
			enemy.velocity.y += (usable_velocs[index].y)
			usable_mov_frames.pop_front()
			usable_velocs.pop_front()
			break
		index += 1
	
	if AnimPlayer.frame >= 35:
		if enemy.velocity.x > 0:
			enemy.velocity.x = max(enemy.velocity.x - custom_decel, 0)
		if enemy.velocity.x < 0:
			enemy.velocity.x = min(enemy.velocity.x + custom_decel, 0)
	enemy.move_and_slide()
