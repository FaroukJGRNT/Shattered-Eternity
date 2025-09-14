extends EnemyState

var chase_start = 0
var last_frame_pos = 0
var stagger_cooldown = 7.0

func enter():
	AnimPlayer.play("staggered")

func update(delta):
	stagger_cooldown -= delta
	if stagger_cooldown <= 0:
		transitioned.emit("wander")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
