extends EnemyState

var walking := false 
var waiting := true
var wait_cooldown = 2.0
var walk_start = 0
var last_frame_pos = 0

func enter():
	pass

func update(delta):
	if waiting:
		AnimPlayer.play("idle")
		wait_cooldown -= delta
		if wait_cooldown <= 0:
			# Turn around
			enemy.facing *= -1
			waiting = false
			walking = true
			walk_start = enemy.position.x

	if walking:
		if enemy.position.x == last_frame_pos:
			walking = false
			waiting = true
			wait_cooldown = 2.0
		AnimPlayer.play("walk")
		enemy.velocity.x = enemy.SPEED * enemy.global_speed_scale  / 2 * enemy.facing
		last_frame_pos = enemy.position.x
		enemy.move_and_slide()
		if abs(walk_start - enemy.position.x) >= enemy.wander_distance:
			walking = false
			waiting = true
			wait_cooldown = 2.0

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
