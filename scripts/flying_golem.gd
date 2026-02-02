extends BasicEnemy
class_name FGolem

func turn_around():
	if facing == -1:
		velocity.x = 1
	if facing == 1:
		velocity.x = -1
	direct_sprite()
	move_and_slide()

func direct_sprite():
	# make sure he faces the right direction
	if velocity.x < 0:
		anim_player.flip_h = true
		hitboxes.scale.x = -1
		hitboxes.scale.y = 1
		hurtbox.scale.x = -1
		facing = -1
	if velocity.x > 0:
		anim_player.flip_h = false
		hitboxes.scale.x = 1
		hitboxes.scale.y = 1
		hurtbox.scale.x = 1
		facing = 1
