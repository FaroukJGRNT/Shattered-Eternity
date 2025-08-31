extends EnemyState

var attack_cooldown = 1.5
var on_cooldown = false

func enter():
	attack_cooldown = 1.5
	on_cooldown = false
	AnimPlayer.play("attack")

func update(delta):
	if on_cooldown:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			transitioned.emit("chase")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if AnimPlayer.animation == "attack":
		on_cooldown = true
		AnimPlayer.play("idle")
