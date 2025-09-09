extends EnemyState

var chase_start = 0
var last_frame_pos = 0

func enter():
	chase_start = enemy.position.x

func update(delta):
	if abs(enemy.position.x - enemy.target.position.x) <= enemy.ATTACK_RANGE and\
	(enemy.position.x - enemy.target.position.x) * enemy.direction.x < 0:
		transitioned.emit("attack")
		return
	AnimPlayer.play("run")
	# Move in direction of the target
	enemy.direction = (enemy.target.position - enemy.position).normalized()
	enemy.velocity.x = enemy.SPEED * enemy.direction.x
	last_frame_pos = enemy.position.x
	enemy.move_and_slide()

	if abs(chase_start - enemy.position.x) >= enemy.max_aggro_distance:
		transitioned.emit("wander")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
