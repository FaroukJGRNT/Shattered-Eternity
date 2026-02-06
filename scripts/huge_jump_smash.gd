extends EnemyAttackState

var boosted := false

func enter():
	super.enter()
	boosted = false

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
		
	if AnimPlayer.frame == 12 and not boosted:
		boosted = true
		var x_veloc = abs(owner.position.x - owner.target.position.x) + 100
		var y_veloc = 800 - x_veloc
		
		print(x_veloc)
		print(y_veloc)

		enemy.velocity.x += (x_veloc * owner.facing)
		enemy.velocity.y += y_veloc

	if enemy.velocity.x > 0:
		enemy.velocity.x = max(enemy.velocity.x - deceleration * 50 * delta, 0)
	if enemy.velocity.x < 0:
		enemy.velocity.x = min(enemy.velocity.x + deceleration * 50 * delta, 0)

	enemy.move_and_slide()
