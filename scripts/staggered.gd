extends EnemyState

var stagger_cooldown = 5.0

func _init() -> void:
	is_state_blocking = true

func enter():
	stagger_cooldown = 5.0
	AnimPlayer.play("stagger_start")

func update(delta):
	stagger_cooldown -= delta
	if stagger_cooldown <= 0:
		AnimPlayer.play("stagger_end")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if AnimPlayer.animation == "stagger_end":
		transitioned.emit("decide")
	if AnimPlayer.animation == "stagger_start":
		AnimPlayer.play("staggered")
